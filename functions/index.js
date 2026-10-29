const { onCall, onRequest, HttpsError } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");
const axios = require("axios");
const crypto = require("crypto");

admin.initializeApp();
const db = admin.firestore();

// API Keys & Secrets configuration with environment fallback
const GOOGLE_MAPS_API_KEY = process.env.GOOGLE_MAPS_API_KEY || "";
const WHATSAPP_ACCESS_TOKEN = process.env.WHATSAPP_ACCESS_TOKEN || "";
const WHATSAPP_PHONE_ID = process.env.WHATSAPP_PHONE_ID || "";
const WHATSAPP_VERIFY_TOKEN = process.env.WHATSAPP_VERIFY_TOKEN || "colombohub_secret_token_2026";
const PAYHERE_MERCHANT_SECRET = process.env.PAYHERE_MERCHANT_SECRET || "4MTIzNDU2Nzg5MDEyMzQ1Ng==";

// 1. Google Maps Distance Matrix Commute Filter
exports.filterByCommuteTime = onCall(
  { region: "asia-south1" },
  async (request) => {
    const { officeLat, officeLng, maxMinutes = 30 } = request.data;
    const snap = await db.collection("accommodations").where("availability", "==", true).limit(20).get();
    
    if (snap.empty) return { suggestions: [] };
    const origins = snap.docs.map(d => `${d.data().location?.lat || d.data().latitude},${d.data().location?.lng || d.data().longitude}`).join("|");
    const mapsKey = GOOGLE_MAPS_API_KEY || (typeof request.auth !== 'undefined' ? process.env.GOOGLE_MAPS_API_KEY : "");

    const res = await axios.get("https://maps.googleapis.com/maps/api/distancematrix/json", {
      params: {
        origins,
        destinations: `${officeLat},${officeLng}`,
        mode: "transit",
        departure_time: "now",
        key: mapsKey,
      },
    });

    const suggestions = [];
    res.data.rows.forEach((row, i) => {
      const el = row.elements[0];
      if (el && el.status === "OK") {
        const durationMin = Math.round(el.duration.value / 60);
        if (durationMin <= maxMinutes) {
          suggestions.push({
            id: snap.docs[i].id,
            ...snap.docs[i].data(),
            commuteMinutes: durationMin,
          });
        }
      }
    });
    return { suggestions };
  }
);

// 2. 10:30 AM Corporate Lunch Pool Scheduler
exports.lockCorporateLunchPools = onSchedule(
  { schedule: "30 10 * * 1-5", timeZone: "Asia/Colombo", region: "asia-south1" },
  async () => {
    const today = new Date().toISOString().slice(0, 10);
    const pools = await db.collection("meal_pools").where("date", "==", today).where("status", "==", "open").get();
    const batch = db.batch();
    pools.forEach(doc => {
      const orders = doc.data().orders || [];
      const sharedFee = orders.length > 0 ? Math.ceil(600 / orders.length) : 0;
      batch.update(doc.ref, { status: "locked", sharedCourierFee: sharedFee });
    });
    await batch.commit();
  }
);

// 3. Meta WhatsApp Cloud API Webhook
exports.whatsappWebhook = onRequest(
  { region: "asia-south1" },
  async (req, res) => {
    if (req.method === "GET") {
      const mode = req.query["hub.mode"];
      const token = req.query["hub.verify_token"];
      const challenge = req.query["hub.challenge"];

      if (mode === "subscribe" && token === WHATSAPP_VERIFY_TOKEN) {
        return res.status(200).send(challenge);
      } else {
        return res.status(403).send("Forbidden");
      }
    }

    if (req.method === "POST") {
      try {
        const body = req.body;
        if (body.object === "whatsapp_business_account") {
          for (const entry of body.entry || []) {
            for (const change of entry.changes || []) {
              const value = change.value;
              if (value && value.messages && value.messages.length > 0) {
                const message = value.messages[0];
                const from = message.from;
                const text = message.text ? message.text.body : "";

                await db.collection("whatsapp_logs").add({
                  from,
                  text,
                  messageId: message.id,
                  receivedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
              }
            }
          }
          return res.status(200).send("EVENT_RECEIVED");
        }
        return res.status(404).send("Not Found");
      } catch (err) {
        return res.status(500).send("Internal Server Error");
      }
    }
    return res.status(405).send("Method Not Allowed");
  }
);

// 4. PayHere Payment Gateway IPN Webhook
exports.payHereNotify = onRequest(
  { region: "asia-south1" },
  async (req, res) => {
    if (req.method !== "POST") return res.status(405).send("Method Not Allowed");

    try {
      const { merchant_id, order_id, payhere_amount, payhere_currency, status_code, md5sig } = req.body;
      const hashedSecret = crypto.createHash("md5").update(PAYHERE_MERCHANT_SECRET).digest("hex").toUpperCase();
      const checkString = `${merchant_id}${order_id}${payhere_amount}${payhere_currency}${status_code}${hashedSecret}`;
      const localHash = crypto.createHash("md5").update(checkString).digest("hex").toUpperCase();

      if (localHash !== (md5sig || "").toUpperCase()) {
        return res.status(400).send("Signature Mismatch");
      }

      if (status_code === "2") {
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
      return res.status(500).send("Server Error");
    }
  }
);
