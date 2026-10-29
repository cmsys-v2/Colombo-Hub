/// ColomboHub Meal Pool Model
/// Supports corporate cluster lunch pools, eco-tiffin containers, and Rs. 18 flat courier fee splitting.
class MealPoolModel {
  final String id;
  final String catererName;
  final String title;
  final String description;
  final double price;
  final double courierFee;
  final bool isEcoTiffin;
  final String vendorId;
  final String orderCutoffTime;
  final String officeCluster;

  const MealPoolModel({
    required this.id,
    required this.catererName,
    required this.title,
    required this.description,
    required this.price,
    required this.courierFee,
    this.isEcoTiffin = false,
    required this.vendorId,
    this.orderCutoffTime = '10:30 AM',
    this.officeCluster = 'World Trade Center (Fort)',
  });

  double get totalPrice => price + courierFee;

  MealPoolModel copyWith({
    String? id,
    String? catererName,
    String? title,
    String? description,
    double? price,
    double? courierFee,
    bool? isEcoTiffin,
    String? vendorId,
    String? orderCutoffTime,
    String? officeCluster,
  }) {
    return MealPoolModel(
      id: id ?? this.id,
      catererName: catererName ?? this.catererName,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      courierFee: courierFee ?? this.courierFee,
      isEcoTiffin: isEcoTiffin ?? this.isEcoTiffin,
      vendorId: vendorId ?? this.vendorId,
      orderCutoffTime: orderCutoffTime ?? this.orderCutoffTime,
      officeCluster: officeCluster ?? this.officeCluster,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catererName': catererName,
      'title': title,
      'description': description,
      'price': price,
      'courierFee': courierFee,
      'isEcoTiffin': isEcoTiffin,
      'vendorId': vendorId,
      'orderCutoffTime': orderCutoffTime,
      'officeCluster': officeCluster,
    };
  }

  factory MealPoolModel.fromMap(Map<String, dynamic> map) {
    return MealPoolModel(
      id: map['id'] as String? ?? '',
      catererName: map['catererName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      courierFee: (map['courierFee'] as num?)?.toDouble() ?? 18.0,
      isEcoTiffin: map['isEcoTiffin'] as bool? ?? false,
      vendorId: map['vendorId'] as String? ?? '',
      orderCutoffTime: map['orderCutoffTime'] as String? ?? '10:30 AM',
      officeCluster: map['officeCluster'] as String? ?? 'World Trade Center (Fort)',
    );
  }
}

/// Backwards compatibility alias
typedef LunchItem = MealPoolModel;
