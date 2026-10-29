/// ColomboHub Courier Model
/// Represents multi-tier document & parcel dispatches with commuter backhaul route savings.
class CourierModel {
  final String id;
  final String tierTag;
  final String title;
  final String description;
  final double price;
  final String priceLabel;
  final String vendorId;
  final double backhaulDiscountPercent;
  final int estimatedDeliveryHours;

  const CourierModel({
    required this.id,
    required this.tierTag,
    required this.title,
    required this.description,
    required this.price,
    required this.priceLabel,
    required this.vendorId,
    this.backhaulDiscountPercent = 0.35,
    this.estimatedDeliveryHours = 4,
  });

  CourierModel copyWith({
    String? id,
    String? tierTag,
    String? title,
    String? description,
    double? price,
    String? priceLabel,
    String? vendorId,
    double? backhaulDiscountPercent,
    int? estimatedDeliveryHours,
  }) {
    return CourierModel(
      id: id ?? this.id,
      tierTag: tierTag ?? this.tierTag,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      priceLabel: priceLabel ?? this.priceLabel,
      vendorId: vendorId ?? this.vendorId,
      backhaulDiscountPercent: backhaulDiscountPercent ?? this.backhaulDiscountPercent,
      estimatedDeliveryHours: estimatedDeliveryHours ?? this.estimatedDeliveryHours,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tierTag': tierTag,
      'title': title,
      'description': description,
      'price': price,
      'priceLabel': priceLabel,
      'vendorId': vendorId,
      'backhaulDiscountPercent': backhaulDiscountPercent,
      'estimatedDeliveryHours': estimatedDeliveryHours,
    };
  }

  factory CourierModel.fromMap(Map<String, dynamic> map) {
    return CourierModel(
      id: map['id'] as String? ?? '',
      tierTag: map['tierTag'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      priceLabel: map['priceLabel'] as String? ?? '',
      vendorId: map['vendorId'] as String? ?? '',
      backhaulDiscountPercent: (map['backhaulDiscountPercent'] as num?)?.toDouble() ?? 0.35,
      estimatedDeliveryHours: (map['estimatedDeliveryHours'] as num?)?.toInt() ?? 4,
    );
  }
}

/// Backwards compatibility alias
typedef CourierOption = CourierModel;

/// Active courier dispatch job for drivers/vendors
class ActiveDispatch {
  final String id;
  final String title;
  final String locationTag;
  final String description;
  final double payoutAmount;
  final String status;

  const ActiveDispatch({
    required this.id,
    required this.title,
    required this.locationTag,
    required this.description,
    required this.payoutAmount,
    this.status = 'READY_FOR_PICKUP',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'locationTag': locationTag,
      'description': description,
      'payoutAmount': payoutAmount,
      'status': status,
    };
  }

  factory ActiveDispatch.fromMap(Map<String, dynamic> map) {
    return ActiveDispatch(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      locationTag: map['locationTag'] as String? ?? '',
      description: map['description'] as String? ?? '',
      payoutAmount: (map['payoutAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'READY_FOR_PICKUP',
    );
  }
}
