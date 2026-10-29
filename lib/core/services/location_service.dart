import 'package:geolocator/geolocator.dart';
import '../constants/app_constants.dart';

class LocationService {
  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Calculates distance in meters and verifies if within 45m geofence
  static double getDistanceMeters({
    required double currentLat,
    required double currentLng,
    required double targetLat,
    required double targetLng,
  }) {
    return Geolocator.distanceBetween(
      currentLat,
      currentLng,
      targetLat,
      targetLng,
    );
  }

  static bool isWithinScoutRadius({
    required double currentLat,
    required double currentLng,
    required double targetLat,
    required double targetLng,
  }) {
    final distance = getDistanceMeters(
      currentLat: currentLat,
      currentLng: currentLng,
      targetLat: targetLat,
      targetLng: targetLng,
    );
    return distance <= AppConstants.maxScoutGpsDistanceMeters;
  }
}
