import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

mixin LocationController {
  static Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message":
            "Gagal mendapatkan lokasi, aktifkan GPS pada perangkat Anda!",
        "error": true
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message":
              "Gagal mendapatkan lokasi, berikan izin untuk mendapatkan lokasi perangkat!",
          "error": true
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Gagal mendapatkan lokasi, berikan izin untuk mendapatkan lokasi perangkat!",
        "error": true
      };
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    final double latitude = position.latitude;
    final double longitude = position.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude, localeIdentifier: "ID");
    return {"position": position,'address': placemarks, "error": false};
  }
}
