import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/data/models/user_details.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../styles/styles.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmNewPassC = TextEditingController();
  TextEditingController oldPassC = TextEditingController();
  late RxMap<String, dynamic> userDetails;

  @override
  void onInit() {
    super.onInit();
    userDetails = <String, dynamic>{}.obs;
    // Fetch user details when the controller is initialized
    loadUserDetails();
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString('nama'),
      'jabatan': prefs.getString('nm_jabatan'),
      'agama': prefs.getString('nm_agama'),
      'is_admin': prefs.getInt('is_admin'),
      'token': prefs.getString('token'),
      'kd_akses': prefs.getString('kd_akses')
    };
  }

  Future<void> loadUserDetails() async {
    final details = await getUserDetails();
    userDetails.assignAll(details);
  }

  Future<void> updatePass() async {
    RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

    if (newPassC.text.isNotEmpty &&
        confirmNewPassC.text.isNotEmpty &&
        oldPassC.text.isNotEmpty) {
      isLoading.value = true;

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${userDetails['token']}',
        'Content-Type': 'application/json',
      };

      final Map<String, String> body = {
        'kd_akses': userDetails['kd_akses'],
        'old_pass': oldPassC.text,
        'new_pass': newPassC.text
      };

      String jsonData = jsonEncode(body);
      String url = Api.updatePass;

      print(jsonData);

      if (newPassC.text == confirmNewPassC.text) {
        try {
          final response =
              await http.put(Uri.parse(url), headers: headers, body: jsonData);

          if (response.statusCode == 200) {
            Get.snackbar("Berhasil",
                "Password berhasil diubah silahkan login kembali menggunakan password baru");
            relog();
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan",
              "Gagal mengubah data, silahkan coba lagi nanti");
          print('gagal ubah password $e');
        }
      } else if (newPassC.text.length <= 6) {
        Get.snackbar(
            "Terjadi Kesalahan", "Password tidak boleh kurang dari 6 karakter");
      } else if (confirmNewPassC.text != newPassC.text) {
        Get.snackbar("Terjadi Kesalahan", "Password tidak cocok!");
      } else {
        Get.snackbar("Terjadi Kesalahan",
            "Gagal mengubah password, silahkan coba lagi nanti");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan",
          "Password Baru dan Konfirmasi Password Baru wajib diisi!");
    }
  }

  void relog() async {
    String url = Api.logout;

    try {
      final response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${userDetails['token']}'});

      print('response ubah password ${response.body}');

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil",
          "Silahkan melakukan login ulang menggunakan password baru Anda",
          backgroundColor: Styles.themeTeal,
        );

        // Use Future.microtask to ensure that this runs in the main isolate
        Future.microtask(() {
          Navigator.of(Get.context!).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        });
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "gagal melakukan logout = $e");
    }
  }
}
