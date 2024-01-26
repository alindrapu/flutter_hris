import 'dart:convert';

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
  static Future<void> absenPegawai(Position position, int kdAbsen,
      String statusLokasi, bool statusAbsen) async {
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

    // Body update current position
    final Map<String, dynamic> positionBody = {
      "kd_akses": userDetails['kd_akses'],
      "latitude": "${position.latitude}",
      "longitude": "${position.longitude}",
    };

    // API Request Update Position
    String jsonPosition = jsonEncode(positionBody);
    String urlUpdate = Api.updateCurrentPosition;

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

      final responsePosition = await http.post(Uri.parse(urlUpdate),
          headers: headers, body: jsonPosition);
      print(responsePosition.statusCode);
      if (responsePosition.statusCode == 200) {
        try {
          // Body absen pegawai
          final Map<String, dynamic> absenBody = {
            "kd_akses": userDetails['kd_akses'],
            "latitude": "${position.latitude}",
            "longitude": "${position.longitude}",
            "status_lokasi_masuk": statusLokasi,
            "kd_jenis_absensi": kdAbsen,
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
                message: "Berhasil melakukan absensi",
                confirmButtonText: "Kembali",
                onConfirm: () {
                  Get.toNamed(Routes.home);
                },
                onCancel: () {},
              ),
            );
          }
        } catch (e) {
          Get.dialog(
            ConfirmationDialog(
              title: "Terjadi Kesalahan",
              message: "Gagal melakukan absensi, silahkan coba lagi!",
              confirmButtonText: "Kembali",
              onConfirm: () {
                Get.toNamed(Routes.home);
              },
              onCancel: () {},
            ),
          );
        }
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Gagal memperbarui posisi terakhir");
    }
  }
}
