import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/controllers/user_details_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:http/http.dart' as http;

class DetailApprovalCutiController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> approveCuti(
      String kdAkses, int id, int kdStatusPermohonan) async {
    // 1	Permohonan Disetujui
    // 2	Menunggu Persetujuan Sekretaris
    // 3	Menunggu Persetujuan Kepala Desa
    // 4	Permohonan Ditolak
    // 5	Permohonan Dibatalkan

    Map<String, dynamic> userData =
        await userDetailsController.getUserDetails();
    final userDetails = userData;

    final Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer ${userDetails["token"]}",
      "Content-Type": "application/json",
    };

    print(userDetails);

    final Map<String, dynamic> body = {
      "kd_akses_approver": '${userDetails['kd_akses']}',
      "kd_akses_pemohon": kdAkses,
      "id_permohonan": id,
      "kd_status_permohonan": kdStatusPermohonan
    };

    String jsonBody = jsonEncode(body);
    String url = Api.approveCuti;

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: jsonBody);

      if (kDebugMode) {
        print(jsonBody);
      }

      if (response.statusCode == 200) {
        Get.snackbar("Berhasil", "Status cuti berhasil diperbarui",
            backgroundColor: Styles.themeTeal);
        Get.offAllNamed(Routes.approvalCuti);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan",
          "Gagal memperbarui data, silahkan coba lagi nanti");
    }
  }
}
