// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class AbsenController extends GetxController {
  TextEditingController alasanC = TextEditingController();
  RxList<Map<String, dynamic>> historyList = <Map<String, dynamic>>[].obs;

  get absenController => null;

  Future<void> last5Days() async {
    Map<String, dynamic> userData =
        await userDetailsController.getUserDetails();
    final userDetails = userData;

    // Headers
    final Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${userDetails["token"]}",
      "Content-Type": "application/json",
    };
    final String kdAkses = userDetails['kd_akses'];

    final Map<String, String> body = {
      "kd_akses": kdAkses,
    };

    // API Request
    String url = Api.last5Days;
    final jsonBody = jsonEncode(body);
    // print(jsonBody);
    final response =
        await http.post(Uri.parse(url), headers: headers, body: jsonBody);
    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> data = responseData['data'];
        historyList.value = List<Map<String, dynamic>>.from(data);
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future untuk absen masuk dan keluar pegawai
  Future<void> absenPegawai(Position position, int kdAbsen, String statusLokasi,
      [String? alasanC]) async {
    Map<String, dynamic> userData =
        await userDetailsController.getUserDetails();
    final userDetails = userData;
    final localAuth = LocalAuthentication();

    // Headers update position & absen pegawai
    final Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${userDetails["token"]}",
      "Content-Type": "application/json",
    };

    // // Body update current position
    // final Map<String, dynamic> positionBody = {
    //   "kd_akses": userDetails['kd_akses'],
    //   "latitude": "${position.latitude}",
    //   "longitude": "${position.longitude}",
    // };

    // // API Request Update Position
    // String jsonPosition = jsonEncode(positionBody);
    // String urlUpdate = Api.updateCurrentPosition;

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      if (canCheckBiometrics) {
        final bool didAuthenticate = await localAuth.authenticate(
          localizedReason: 'Lakukan otentikasi untuk melakukan presensi',
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Otentikasi diperlukan untuk melakukan presensi!',
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

      // final responsePosition = await http.post(Uri.parse(urlUpdate),
      //     headers: headers, body: jsonPosition);
      // print(responsePosition.statusCode);

      // if (responsePosition.statusCode == 200) {
      try {
        // Body absen pegawai
        final Map<String, dynamic> absenBody = {
          "kd_akses": userDetails['kd_akses'],
          "latitude": "${position.latitude}",
          "longitude": "${position.longitude}",
          "status_lokasi_masuk": statusLokasi,
          "kd_jenis_absensi": kdAbsen,
          "alasan": alasanC
        };

        // Api Request Absen Pegawai
        String jsonAbsen = jsonEncode(absenBody);
        String urlAbsen = Api.absenPegawai;

        print(absenBody);
        print(headers);

        final responseAbsen = await http.post(Uri.parse(urlAbsen),
            headers: headers, body: jsonAbsen);

        print(responseAbsen.statusCode);

        if (responseAbsen.statusCode == 200) {
          Get.dialog(
            ConfirmationDialog(
              title: "Berhasil",
              message: "Berhasil melakukan presensi",
              confirmButtonText: "Kembali",
              onConfirm: () {
                Get.offAndToNamed(Routes.home);
              },
              onCancel: () {},
            ),
          );
        }
      } catch (e) {
        print("Error: $e");
        Get.dialog(
          ConfirmationDialog(
            title: "Terjadi Kesalahan",
            message: "Gagal melakukan presensi, silahkan coba lagi!",
            confirmButtonText: "Kembali",
            onConfirm: () {
              Get.toNamed(Routes.home);
            },
            onCancel: () {},
          ),
        );
      }
      // }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal memperbarui posisi terakhir");
    }
  }

  @override
  void dispose() {
    absenController.dispose();
    super.dispose();
  }

  // Stream untuk cek absen pegawai saat ini untuk update widget
  static Future<Map<String, dynamic>?> checkAbsen() async {
    Map<String, dynamic> userData =
        await userDetailsController.getUserDetails();
    final userDetails = userData;

    // Headers
    final Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${userDetails["token"]}",
      "Content-Type": "application/json",
    };

    // Body update current position
    final Map<String, dynamic> body = {
      "kd_akses": userDetails['kd_akses'],
    };

    // API Request
    String jsonBody = jsonEncode(body);
    String url = Api.checkAbsen;
    final response =
        await http.post(Uri.parse(url), headers: headers, body: jsonBody);
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final jamMasuk = responseData['message'][0]['jam_masuk'];
        final jamKeluar = responseData['message'][0]['jam_keluar'];

        return {
          'jamMasuk': jamMasuk,
          'jamKeluar': jamKeluar,
        };
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
