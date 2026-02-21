import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../core/constants.dart';
import '../models/fuji_location.dart';

class LocationService {
  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10,
      ),
    );
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  Future<FujiLocation?> getFujiLocation(Position position) async {
    double distanceMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      AppConstants.fujiLatitude,
      AppConstants.fujiLongitude,
    );

    String? city;
    String? prefecture;
    try {
      // NOTE: placemarkFromCoordinates may fail on Web platforms easily.
      // Failing gracefully allows the coordinates to still show.
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        city =
            placemarks.first.locality ?? placemarks.first.subAdministrativeArea;
        prefecture = placemarks.first.administrativeArea;
      }
    } catch (_) {
      // Exited gracefully. The UI will just not include city/prefecture.
    }

    return FujiLocation(
      distanceKm: distanceMeters / 1000,
      currentLat: position.latitude,
      currentLng: position.longitude,
      city: city,
      prefecture: prefecture,
    );
  }
}
