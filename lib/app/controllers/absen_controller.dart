import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/controllers/user_details_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/widgets/confirmation_dialog.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:http/http.dart' as http;

mixin absenController {
  static Future<void> absenPegawai(Position position) async {
    Map<String, dynamic> userData =
        await userDetailsController.getUserDetails();
    final userDetails = userData;

    final localAuth = LocalAuthentication();

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
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;

      if (canCheckBiometrics) {
        final bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Lakukan otentikasi untuk melakukan Absen',
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Otentikasi diperlukan untuk melakukan absen!',
              cancelButton: 'No thanks',
            ),
            IOSAuthMessages(
              cancelButton: 'No thanks',
            ),
          ],
        );

        if (!didAuthenticate) {
          Get.snackbar(
              "Otentikasi Gagal", "Gagal melakukan otentikasi pada perangkat");
          return;
        }
      } else {
        // Handle the case where biometrics are not available
        Get.snackbar("Otentikasi Gagal", "Kesalahan pada otentikasi perangkat");
        return;
      }

      final response =
          await http.post(Uri.parse(url), headers: headers, body: jsonBody);
      if (response.statusCode == 200) {
        Get.dialog(
          ConfirmationDialog(
            title: "Berhasil",
            message: "Berhasil melakukan absensi",
            confirmButtonText: "Kembali",
            onConfirm: () {
              Get.toNamed(Routes.home);
            },
          ),
        );
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal memperbarui posisi terakhir");
    }
  }
}
