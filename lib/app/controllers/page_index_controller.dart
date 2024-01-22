import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString('nama'),
      'kd_akses': prefs.getString('kd_akses'),
      'token': prefs.getString('token')
    };
  }

  Future<Map<String, dynamic>> determinePosition() async {
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
    return {"position": position, "error": false};
  }

  Future<void> updatePosition(Position position) async {
    Map<String, dynamic> userData = await getUserDetails();
    final userDetails = userData;

    final Map<String, dynamic> body = {
      "kd_akses": userDetails['kd_akses'],
      "latitude": "${position.latitude}",
      "longitude": "${position.longitude}",
    };

    final Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${userDetails["token"]}",
      "Content-Type": "application/json",
    };

    String jsonBody = jsonEncode(body);
    String url = Api.updateCurrentPosition;

    if (kDebugMode) {
      print(headers);
    }

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        Get.snackbar("Berhasil", "Berhasil memperbarui posisi terakhir");
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal memperbarui possi terakhir");
    }
  }

  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> response = await determinePosition();
        if (response["error"] != true) {
          Position position = response["position"];
          await updatePosition(position);

          // if (kDebugMode) {
          //   print("${position.latitude}");
          //   print("${position.longitude}");
          // }
        } else {
          Get.snackbar("Terjadi Kesalahan", response["message"]);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.toNamed(Routes.profile);
        break;
      default:
        pageIndex.value = i;
        Get.toNamed(Routes.home);
    }
  }
}
