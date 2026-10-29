/// ColomboHub Accommodation Model
/// Handles Form-C compliant boarding rooms, shared annexes, and fresh-up pods in Western Province.
class AccommodationModel {
  final String id;
  final String title;
  final String neighborhood;
  final String workplace;
  final int commuteMins;
  final double price;
  final String priceUnit;
  final String durationCategory;
  final String description;
  final int ownerPhotosCount;
  final int scoutPhotosCount;
  final double rating;
  final double depositAmount;
  final List<String> features;
  final double latitude;
  final double longitude;
  final bool isFormCReady;
  final bool isSeparateMeter;
  final String vendorId;

  const AccommodationModel({
    required this.id,
    required this.title,
    required this.neighborhood,
    required this.workplace,
    required this.commuteMins,
    required this.price,
    this.priceUnit = '/mo',
    required this.durationCategory,
    required this.description,
    required this.ownerPhotosCount,
    required this.scoutPhotosCount,
    required this.rating,
    required this.depositAmount,
    required this.features,
    required this.latitude,
    required this.longitude,
    this.isFormCReady = true,
    this.isSeparateMeter = true,
    required this.vendorId,
  });

  AccommodationModel copyWith({
    String? id,
    String? title,
    String? neighborhood,
    String? workplace,
    int? commuteMins,
    double? price,
    String? priceUnit,
    String? durationCategory,
    String? description,
    int? ownerPhotosCount,
    int? scoutPhotosCount,
    double? rating,
    double? depositAmount,
    List<String>? features,
    double? latitude,
    double? longitude,
    bool? isFormCReady,
    bool? isSeparateMeter,
    String? vendorId,
  }) {
    return AccommodationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      neighborhood: neighborhood ?? this.neighborhood,
      workplace: workplace ?? this.workplace,
      commuteMins: commuteMins ?? this.commuteMins,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      durationCategory: durationCategory ?? this.durationCategory,
      description: description ?? this.description,
      ownerPhotosCount: ownerPhotosCount ?? this.ownerPhotosCount,
      scoutPhotosCount: scoutPhotosCount ?? this.scoutPhotosCount,
      rating: rating ?? this.rating,
      depositAmount: depositAmount ?? this.depositAmount,
      features: features ?? this.features,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFormCReady: isFormCReady ?? this.isFormCReady,
      isSeparateMeter: isSeparateMeter ?? this.isSeparateMeter,
      vendorId: vendorId ?? this.vendorId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'neighborhood': neighborhood,
      'workplace': workplace,
      'commuteMins': commuteMins,
      'price': price,
      'priceUnit': priceUnit,
      'durationCategory': durationCategory,
      'description': description,
      'ownerPhotosCount': ownerPhotosCount,
      'scoutPhotosCount': scoutPhotosCount,
      'rating': rating,
      'depositAmount': depositAmount,
      'features': features,
      'latitude': latitude,
      'longitude': longitude,
      'isFormCReady': isFormCReady,
      'isSeparateMeter': isSeparateMeter,
      'vendorId': vendorId,
    };
  }

  factory AccommodationModel.fromMap(Map<String, dynamic> map) {
    return AccommodationModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      neighborhood: map['neighborhood'] as String? ?? '',
      workplace: map['workplace'] as String? ?? '',
      commuteMins: (map['commuteMins'] as num?)?.toInt() ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      priceUnit: map['priceUnit'] as String? ?? '/mo',
      durationCategory: map['durationCategory'] as String? ?? '',
      description: map['description'] as String? ?? '',
      ownerPhotosCount: (map['ownerPhotosCount'] as num?)?.toInt() ?? 0,
      scoutPhotosCount: (map['scoutPhotosCount'] as num?)?.toInt() ?? 0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      depositAmount: (map['depositAmount'] as num?)?.toDouble() ?? 0.0,
      features: (map['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      isFormCReady: map['isFormCReady'] as bool? ?? true,
      isSeparateMeter: map['isSeparateMeter'] as bool? ?? true,
      vendorId: map['vendorId'] as String? ?? '',
    );
  }
}

/// Backwards compatibility alias
typedef StayListing = AccommodationModel;
