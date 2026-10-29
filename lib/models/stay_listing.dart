class StayListing {
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

  const StayListing({
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

  StayListing copyWith({
    int? scoutPhotosCount,
  }) {
    return StayListing(
      id: id,
      title: title,
      neighborhood: neighborhood,
      workplace: workplace,
      commuteMins: commuteMins,
      price: price,
      priceUnit: priceUnit,
      durationCategory: durationCategory,
      description: description,
      ownerPhotosCount: ownerPhotosCount,
      scoutPhotosCount: scoutPhotosCount ?? this.scoutPhotosCount,
      rating: rating,
      depositAmount: depositAmount,
      features: features,
      latitude: latitude,
      longitude: longitude,
      isFormCReady: isFormCReady,
      isSeparateMeter: isSeparateMeter,
      vendorId: vendorId,
    );
  }
}
