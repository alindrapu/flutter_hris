import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/data/models/user_details.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewKdPassController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmNewPassC = TextEditingController();
  TextEditingController newKdAksesC = TextEditingController();
  TextEditingController confirmKdAksesC = TextEditingController();

  Future<UserDetails?> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? nama = prefs.getString('nama');
    final String? token = prefs.getString('token');

    if (email != null && nama != null && token != null) {
      return UserDetails(email: email, nama: nama, token: token);
    } else {
      return null;
    }
  }

  Future<void> newKdPass() async {
    RegExp alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    UserDetails? userDetails = await getUserDetails();

    if (newPassC.text.isNotEmpty &&
        confirmNewPassC.text.isNotEmpty &&
        newKdAksesC.text.isNotEmpty &&
        confirmKdAksesC.text.isNotEmpty) {
      isLoading.value = true;

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${userDetails?.token ?? ''}',
        'Content-Type': 'application/json',
      };

      final Map<String, String> body = {
        'email': userDetails?.email ?? '',
        'kd_akses': newKdAksesC.text,
        'password': newPassC.text
      };

      String jsonData = jsonEncode(body);
      String url = Api.newKdPass;

      if (newPassC.text == confirmNewPassC.text &&
          newKdAksesC.text == confirmKdAksesC.text) {
        try {
          final response =
              await http.put(Uri.parse(url), headers: headers, body: jsonData);

          if (response.statusCode == 200) {
            Get.snackbar("Berhasil", "Password berhasil diubah");
            Get.offAllNamed(Routes.home);
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat mengubah password, silahkan coba lagi nanti");
        }
      } else if (!alphanumeric.hasMatch(newKdAksesC.text)) {
        Get.snackbar(
            "Terjadi Kesalahan", "Kode Akses harus mengandung Huruf dan Angka");
      } else if (newPassC.text.length <= 6) {
        Get.snackbar(
            "Terjadi Kesalahan", "Password tidak boleh kurang dari 6 karakter");
      } else if (newKdAksesC.text.length <= 6) {
        Get.snackbar("Terjadi Kesalahan",
            "Kode Akses tidak boleh kurang dari 6 karakter");
      } else if (newPassC.text == "rahasia" &&
          confirmNewPassC.text == 'rahasia') {
        Get.snackbar("Terjadi Kesalahan", "Password harus diubah!");
      } else if (confirmNewPassC.text != newPassC.text) {
        Get.snackbar("Terjadi Kesalahan", "Password tidak cocok!");
      } else if (confirmKdAksesC.text != newKdAksesC.text) {
        Get.snackbar("Terjadi Kesalahan", "Kode Akses tidak cocok!");
      } else {
        Get.snackbar("Terjadi Kesalahan",
            "Gagal mengubah password dan kode akses, silahkan coba lagi nanti");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan",
          "Password Baru dan Konfirmasi Password Baru wajib diisi!");
    }
  }
}
