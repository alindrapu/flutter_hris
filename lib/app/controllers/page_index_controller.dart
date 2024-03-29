// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/controllers/location_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:hris/app/widgets/confirmation_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  var loadingDialog;

  Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString('nama'),
      'kd_akses': prefs.getString('kd_akses'),
      'token': prefs.getString('token')
    };
  }

  Future<void> updatePosition(Position position) async {
    Map<String, dynamic> userData = await getUserDetails();
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
              Get.back();
            },
          ),
        );
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal memperbarui posisi terakhir");
    }
  }

  void changePage(int i) async {
    switch (i) {
      case 1:
        loadingDialog = Get.dialog(
          const Center(
              child: CircularProgressIndicator(
            color: Styles.themeLight,
            backgroundColor: Styles.themeDark,
          )),
          barrierDismissible: false,
        );
        Map<String, dynamic> response = await LocationController.determinePosition();
        Get.back();
        if (response["error"] != true) {
          Position position = response["position"];
          Get.dialog(ConfirmationDialog(
            title: "Konfirmasi",
            message: "Lakukan absensi?",
            confirmButtonText: "Ya",
            cancelButtonText: "Kembali",
            onConfirm: () async {
              loadingDialog = Get.dialog(
                const Center(
                  child: CircularProgressIndicator(),
                ),
                barrierDismissible: false,
              );
              await updatePosition(position);
            },
          ));
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
