import 'package:geolocator/geolocator.dart';

import 'package:social_maps/src/models/location.dart';

class GeolocatorService {
  final _geolocator = Geolocator();

  Future<Location> getLocation() async {
    if (await isLocationEnabled()) {
      return getCurrentLocation();
    } else {
      return getLastKnownLocation();
    }
  }

  Future<bool> isLocationEnabled() => _geolocator.isLocationServiceEnabled();

  Future<Location> getCurrentLocation() async {
    try {
      final position = await _geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        locationPermissionLevel: GeolocationPermission.locationWhenInUse,
      );
      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Location> getLastKnownLocation() async {
    try {
      final position = await _geolocator.getLastKnownPosition(
        desiredAccuracy: LocationAccuracy.low,
        locationPermissionLevel: GeolocationPermission.locationWhenInUse,
      );
      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return null;
    }
  }
}
