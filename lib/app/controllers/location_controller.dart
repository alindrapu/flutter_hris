import 'dart:ffi';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math.dart';

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
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, longitude,
        localeIdentifier: "ID");

    final distance = await LocationController.distanceCalHaversine(position);
    return {
      "position": position,
      'address': placemarks,
      "error": false,
      "distance": distance,
    };
  }

// Function Formula Haversine untuk menghitung jarak antara 2 titik
  static Future<Map<String, dynamic>> distanceCalHaversine(
      Position position) async {
    // Define constant
    double pi = 3.141592653589793238;

    // Convert Latitude dan Longitude ke Radians ( Degrees to Radians )
    double degreeToRadian(double degree) {
      return degree * pi / 180;
    }

    // Get posisi perangkat
    final lat1 = degreeToRadian(position.latitude);
    final long1 = degreeToRadian(position.longitude);

    // Penentuan posisi Kantor Kepala Desa Padurenan
    // https://maps.app.goo.gl/Ron86KdkQ8sLrzjZ6
    final lat2 = degreeToRadian(-6.38895232059247);
    final long2 = degreeToRadian(106.7097703659266);

    // Haversine Formula
    final dlat = lat2 - lat1;
    final dlong = long2 - long1;
    final a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlong / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Radius Bumi
    final R = 6371.0;

    // Hitung jarak
    final jarak = R * c;
    final pembulatanJarak = jarak.toStringAsFixed(2);
    final jarakM = double.parse(pembulatanJarak) * 1000;

    return {
      "lat1": "$lat1",
      "long1": "$long1",
      "lat2": "$lat2",
      "long2": "$long2",
      "a": "$a",
      "c": "$c",
      "jarak": "$jarak",
      "pembulatan": pembulatanJarak,
      "jarakM": "$jarakM"
    };
  }
}
