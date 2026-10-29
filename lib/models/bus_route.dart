class BusRoute {
  final String id;
  final String corridorName;
  final String expresswayTag;
  final String title;
  final String busType;
  final String departureTime;
  final String arrivalTime;
  final double dailyPrice;
  final double monthlyPassPrice;
  final int seatsLeft;
  final String waypoints;
  final String vendorId;

  const BusRoute({
    required this.id,
    required this.corridorName,
    required this.expresswayTag,
    required this.title,
    required this.busType,
    required this.departureTime,
    required this.arrivalTime,
    required this.dailyPrice,
    required this.monthlyPassPrice,
    required this.seatsLeft,
    required this.waypoints,
    required this.vendorId,
  });

  BusRoute copyWith({
    int? seatsLeft,
  }) {
    return BusRoute(
      id: id,
      corridorName: corridorName,
      expresswayTag: expresswayTag,
      title: title,
      busType: busType,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      dailyPrice: dailyPrice,
      monthlyPassPrice: monthlyPassPrice,
      seatsLeft: seatsLeft ?? this.seatsLeft,
      waypoints: waypoints,
      vendorId: vendorId,
    );
  }
}
