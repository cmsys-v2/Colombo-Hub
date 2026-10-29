import 'dart:math';

enum PaymentGatewayType {
  payhere,
  frimi,
  cod,
}

class PaymentOrder {
  final String orderId;
  final String title;
  final double amount;
  final String vendorId;
  final String serviceType;
  final PaymentGatewayType gateway;
  final String md5Hash;

  const PaymentOrder({
    required this.orderId,
    required this.title,
    required this.amount,
    required this.vendorId,
    required this.serviceType,
    required this.gateway,
    required this.md5Hash,
  });

  double get platformFee => amount * 0.05;
  double get netVendorCredit => amount * 0.95;
}

class PaymentService {
  static String generateOrderId() {
    final rand = Random().nextInt(90000) + 10000;
    return 'ORD-$rand';
  }

  static String generateMd5Hash(String orderId, double amount) {
    const chars = '0123456789ABCDEF';
    final rnd = Random();
    final buffer = StringBuffer('MD5-');
    for (int i = 0; i < 16; i++) {
      buffer.write(chars[rnd.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  static PaymentOrder createOrder({
    required String title,
    required double amount,
    required String vendorId,
    required String serviceType,
    PaymentGatewayType gateway = PaymentGatewayType.payhere,
  }) {
    final orderId = generateOrderId();
    final hash = generateMd5Hash(orderId, amount);
    return PaymentOrder(
      orderId: orderId,
      title: title,
      amount: amount,
      vendorId: vendorId,
      serviceType: serviceType,
      gateway: gateway,
      md5Hash: hash,
    );
  }
}
