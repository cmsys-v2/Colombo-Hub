/// ColomboHub Transport Model
/// Covers Expressway bus corridors, coastal train links, and commuter pass scheduling.
class TransportModel {
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

  const TransportModel({
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

  TransportModel copyWith({
    String? id,
    String? corridorName,
    String? expresswayTag,
    String? title,
    String? busType,
    String? departureTime,
    String? arrivalTime,
    double? dailyPrice,
    double? monthlyPassPrice,
    int? seatsLeft,
    String? waypoints,
    String? vendorId,
  }) {
    return TransportModel(
      id: id ?? this.id,
      corridorName: corridorName ?? this.corridorName,
      expresswayTag: expresswayTag ?? this.expresswayTag,
      title: title ?? this.title,
      busType: busType ?? this.busType,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      monthlyPassPrice: monthlyPassPrice ?? this.monthlyPassPrice,
      seatsLeft: seatsLeft ?? this.seatsLeft,
      waypoints: waypoints ?? this.waypoints,
      vendorId: vendorId ?? this.vendorId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'corridorName': corridorName,
      'expresswayTag': expresswayTag,
      'title': title,
      'busType': busType,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'dailyPrice': dailyPrice,
      'monthlyPassPrice': monthlyPassPrice,
      'seatsLeft': seatsLeft,
      'waypoints': waypoints,
      'vendorId': vendorId,
    };
  }

  factory TransportModel.fromMap(Map<String, dynamic> map) {
    return TransportModel(
      id: map['id'] as String? ?? '',
      corridorName: map['corridorName'] as String? ?? '',
      expresswayTag: map['expresswayTag'] as String? ?? '',
      title: map['title'] as String? ?? '',
      busType: map['busType'] as String? ?? '',
      departureTime: map['departureTime'] as String? ?? '',
      arrivalTime: map['arrivalTime'] as String? ?? '',
      dailyPrice: (map['dailyPrice'] as num?)?.toDouble() ?? 0.0,
      monthlyPassPrice: (map['monthlyPassPrice'] as num?)?.toDouble() ?? 0.0,
      seatsLeft: (map['seatsLeft'] as num?)?.toInt() ?? 0,
      waypoints: map['waypoints'] as String? ?? '',
      vendorId: map['vendorId'] as String? ?? '',
    );
  }
}

/// Backwards compatibility alias
typedef BusRoute = TransportModel;
