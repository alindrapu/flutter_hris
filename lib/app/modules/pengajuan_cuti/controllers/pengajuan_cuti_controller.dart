import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/controllers/user_details_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:http/http.dart' as http;

class PengajuanCutiController extends GetxController {
  RxBool isLoading = false.obs;
  final tanggalMulaiC = TextEditingController();
  final tanggalSelesaiC = TextEditingController();
  final alasanC = TextEditingController();
  final jenisCutiC = TextEditingController();

  Future<void> requestCuti() async {
    Map<String, dynamic> userData =
        await userDetailsController.getUserDetails();

    if (tanggalMulaiC.text.isNotEmpty &&
        tanggalSelesaiC.text.isNotEmpty &&
        alasanC.text.isNotEmpty &&
        jenisCutiC.text.isNotEmpty) {
      isLoading.value = true;

      final Map<String, dynamic> body = {
        "kd_akses": userData['kd_akses'],
        "alasan_cuti": alasanC.text,
        "nm_jenis_cuti": jenisCutiC.text,
        "tanggal_mulai": tanggalMulaiC.text,
        "tanggal_selesai": tanggalSelesaiC.text,
      };

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${userData['token'] ?? ''}',
        'Content-Type': 'application/json',
      };

      String jsonBody = jsonEncode(body);
      String url = Api.requestCuti;

      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: jsonBody);

        if (kDebugMode) {
          print(jsonBody);
        }

        if (response.statusCode == 200) {
          Get.snackbar("Berhasil",
              "Pengajuan cuti Anda berhasil, menunggu approval atasan",
              backgroundColor: Styles.themeTeal);
          Get.offAllNamed(Routes.pengajuanCuti);
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan",
            "Pengajuan cuti gagal, silahkan coba lagi nanti");
      }
    } else {
      isLoading.value = false;

      Get.snackbar(
          "Terjadi Kesalahan", "Pastikan data yang Anda input sudah sesuai");
    }
  }
}
