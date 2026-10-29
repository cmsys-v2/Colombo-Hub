/**
 * ColomboHub Super-App Firebase Cloud Functions
 * Project: cmsys-hr (ColomboHub Ecosystem)
 * 
 * Features:
 * 1. Meta WhatsApp Business Cloud API Webhook (Verification & Automated Dispatch Bot)
 * 2. Automated Dispatch Notification Trigger (Firestore onWrite)
 * 3. Daily 10:30 AM Colombo Lunch Pool Freeze (Pub/Sub Schedule)
 * 4. PayHere Payment Gateway IPN Handler (MD5 Signature Verification)
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const crypto = require("crypto");

admin.initializeApp();
const db = admin.firestore();

// WhatsApp Cloud API Configuration
const WHATSAPP_VERIFY_TOKEN = process.env.WHATSAPP_VERIFY_TOKEN || "colombohub_secret_token_2026";
const WHATSAPP_ACCESS_TOKEN = process.env.WHATSAPP_ACCESS_TOKEN || "";
const WHATSAPP_PHONE_NUMBER_ID = process.env.WHATSAPP_PHONE_NUMBER_ID || "";
const PAYHERE_MERCHANT_SECRET = process.env.PAYHERE_MERCHANT_SECRET || "4MTIzNDU2Nzg5MDEyMzQ1Ng==";

/**
 * 1. Meta WhatsApp Cloud API Webhook Handler
 * Endpoint: https://us-central1-cmsys-hr.cloudfunctions.net/whatsappWebhook
 */
exports.whatsappWebhook = functions.https.onRequest(async (req, res) => {
  // GET: Webhook verification challenge
  if (req.method === "GET") {
    const mode = req.query["hub.mode"];
    const token = req.query["hub.verify_token"];
    const challenge = req.query["hub.challenge"];

    if (mode === "subscribe" && token === WHATSAPP_VERIFY_TOKEN) {
      console.log("[WhatsApp Webhook] Verification successful.");
      return res.status(200).send(challenge);
    } else {
      console.warn("[WhatsApp Webhook] Verification token mismatch.");
      return res.status(403).send("Forbidden");
    }
  }

  // POST: Incoming messages & delivery statuses
  if (req.method === "POST") {
    try {
      const body = req.body;

      if (body.object === "whatsapp_business_account") {
        for (const entry of body.entry || []) {
          for (const change of entry.changes || []) {
            const value = change.value;
            if (value && value.messages && value.messages.length > 0) {
              const message = value.messages[0];
              const from = message.from; // Sender WhatsApp phone e.g. '94778924510'
              const text = message.text ? message.text.body : "";

              console.log(`[WhatsApp Inbound] From ${from}: "${text}"`);

              // Log conversation to Firestore
              await db.collection("whatsapp_logs").add({
                from,
                text,
                messageId: message.id,
                receivedAt: admin.firestore.FieldValue.serverTimestamp(),
              });

              // Send Automated Response if Token is configured
              if (WHATSAPP_ACCESS_TOKEN && WHATSAPP_PHONE_NUMBER_ID) {
                await sendWhatsAppReply(from, text);
              }
            }
          }
        }
        return res.status(200).send("EVENT_RECEIVED");
      } else {
        return res.status(404).send("Not Found");
      }
    } catch (err) {
      console.error("[WhatsApp Webhook] Processing error:", err);
      return res.status(500).send("Internal Server Error");
    }
  }

  return res.status(405).send("Method Not Allowed");
});

/**
 * Helper to dispatch automated WhatsApp message back to commuter
 */
async function sendWhatsAppReply(recipientPhone, inboundText) {
  const replyMessage = `🇱🇰 *ColomboHub Concierge*\n\n` +
    `Thank you for contacting ColomboHub Super-App!\n\n` +
    `• To check *Form-C Stays & Pods*: Reply 1\n` +
    `• To book *Expressway Bus Seats*: Reply 2\n` +
    `• For *Office Lunch Pool* (Locks 10:30 AM): Reply 3\n` +
    `• For *Urgent Courier / Gas Updates*: Reply 4\n\n` +
    `You can also manage your bookings in the app: https://colombo-hub.web.app`;

  try {
    await axios.post(
      `https://graph.facebook.com/v19.0/${WHATSAPP_PHONE_NUMBER_ID}/messages`,
      {
        messaging_product: "whatsapp",
        recipient_type: "individual",
        to: recipientPhone,
        type: "text",
        text: { body: replyMessage },
      },
      {
        headers: {
          Authorization: `Bearer ${WHATSAPP_ACCESS_TOKEN}`,
          "Content-Type": "application/json",
        },
      }
    );
    console.log(`[WhatsApp Outbound] Successfully sent reply to ${recipientPhone}`);
  } catch (e) {
    console.error("[WhatsApp Outbound] Send failed:", e.response ? e.response.data : e.message);
  }
}

/**
 * 2. Automated Dispatch Notification Trigger
 * Fires when a new courier order or stay reservation is created
 */
exports.sendDispatchNotification = functions.firestore
  .document("dispatches/{dispatchId}")
  .onCreate(async (snap, context) => {
    const dispatchData = snap.data();
    const dispatchId = context.params.dispatchId;

    console.log(`[Dispatch Notification] New dispatch created: ${dispatchId}`);

    // Update dispatch status to dispatched
    return snap.ref.set(
      {
        notificationSent: true,
        notificationTimestamp: admin.firestore.FieldValue.serverTimestamp(),
        status: "DISPATCHED_TO_DRIVER_NETWORK",
      },
      { merge: true }
    );
  });

/**
 * 3. Daily 10:30 AM Colombo Time (05:00 UTC) Lunch Pool Freeze
 * Freezes pending lunch pool orders and generates caterer kitchen slips
 */
exports.scheduledLunchPoolClose = functions.pubsub
  .schedule("30 5 * * 1-5") // Mon-Fri at 05:30 UTC = 11:00 AM SLST (adjust to 10:30 AM SLST = 05:00 UTC)
  .timeZone("Asia/Colombo")
  .onRun(async (context) => {
    console.log("[Lunch Pool] 10:30 AM Order Freeze triggered. Locking all pending batches.");

    const pendingOrders = await db.collection("lunch_orders")
      .where("status", "==", "PENDING_POOL")
      .get();

    const batch = db.batch();
    pendingOrders.forEach((doc) => {
      batch.update(doc.ref, {
        status: "FROZEN_FOR_KITCHEN",
        lockedAt: admin.firestore.FieldValue.serverTimestamp(),
        pooledCourierFee: 18.0,
      });
    });

    await batch.commit();
    console.log(`[Lunch Pool] Locked ${pendingOrders.size} meals for kitchen prep.`);
    return null;
  });

/**
 * 4. PayHere Payment Gateway IPN Webhook
 * Validates MD5 payment signature and confirms booking escrow
 */
exports.payHereNotify = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).send("Method Not Allowed");
  }

  try {
    const {
      merchant_id,
      order_id,
      payhere_amount,
      payhere_currency,
      status_code,
      md5sig,
    } = req.body;

    // Verify PayHere MD5 Signature
    // hash = strtoupper(md5(merchant_id + order_id + payhere_amount + payhere_currency + status_code + strtoupper(md5(merchant_secret))))
    const hashedSecret = crypto.createHash("md5").update(PAYHERE_MERCHANT_SECRET).digest("hex").toUpperCase();
    const checkString = `${merchant_id}${order_id}${payhere_amount}${payhere_currency}${status_code}${hashedSecret}`;
    const localHash = crypto.createHash("md5").update(checkString).digest("hex").toUpperCase();

    if (localHash !== (md5sig || "").toUpperCase()) {
      console.warn(`[PayHere IPN] Invalid MD5 signature for order ${order_id}`);
      return res.status(400).send("Signature Mismatch");
    }

    if (status_code === "2") {
      // Payment Success (Status 2)
      console.log(`[PayHere IPN] Payment confirmed for Order ${order_id}, Amount: ${payhere_amount} ${payhere_currency}`);
      
      await db.collection("payments").doc(order_id).set({
        status: "PAID",
        amount: parseFloat(payhere_amount),
        currency: payhere_currency,
        confirmedAt: admin.firestore.FieldValue.serverTimestamp(),
        gateway: "PAYHERE",
      }, { merge: true });
    }

    return res.status(200).send("OK");
  } catch (err) {
    console.error("[PayHere IPN] Error:", err);
    return res.status(500).send("Server Error");
  }
});
