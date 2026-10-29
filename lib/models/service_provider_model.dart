/// ColomboHub Service Provider Model
/// Covers household essentials (20L water, Litro/Laugfs gas cylinders, laundry drop, technicians).
class ServiceProviderModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceUnit;
  final String iconCode;
  final String vendorId;
  final bool isColSpan2;
  final bool isVerified;
  final String category;
  final int stockCount;

  const ServiceProviderModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceUnit,
    required this.iconCode,
    required this.vendorId,
    this.isColSpan2 = false,
    this.isVerified = true,
    this.category = 'Household',
    this.stockCount = 10,
  });

  ServiceProviderModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? priceUnit,
    String? iconCode,
    String? vendorId,
    bool? isColSpan2,
    bool? isVerified,
    String? category,
    int? stockCount,
  }) {
    return ServiceProviderModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      iconCode: iconCode ?? this.iconCode,
      vendorId: vendorId ?? this.vendorId,
      isColSpan2: isColSpan2 ?? this.isColSpan2,
      isVerified: isVerified ?? this.isVerified,
      category: category ?? this.category,
      stockCount: stockCount ?? this.stockCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'priceUnit': priceUnit,
      'iconCode': iconCode,
      'vendorId': vendorId,
      'isColSpan2': isColSpan2,
      'isVerified': isVerified,
      'category': category,
      'stockCount': stockCount,
    };
  }

  factory ServiceProviderModel.fromMap(Map<String, dynamic> map) {
    return ServiceProviderModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      priceUnit: map['priceUnit'] as String? ?? '',
      iconCode: map['iconCode'] as String? ?? 'tools',
      vendorId: map['vendorId'] as String? ?? '',
      isColSpan2: map['isColSpan2'] as bool? ?? false,
      isVerified: map['isVerified'] as bool? ?? true,
      category: map['category'] as String? ?? 'Household',
      stockCount: (map['stockCount'] as num?)?.toInt() ?? 10,
    );
  }
}

/// Backwards compatibility alias
typedef HouseholdService = ServiceProviderModel;

/// Chat message model for community commuter chat
class ChatMessage {
  final String id;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isAssistant;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isAssistant,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isAssistant': isAssistant,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ?? DateTime.now(),
      isAssistant: map['isAssistant'] as bool? ?? false,
    );
  }
}
