// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController kdAksesC = TextEditingController();
  TextEditingController passC = TextEditingController();

  Future<void> login() async {
    if (kdAksesC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      String url = Api.login;

      Map<String, String> loginData = {
        'kd_akses': kdAksesC.text,
        'password': passC.text,
      };

      String jsonData = jsonEncode(loginData);

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonData,
        );

        if (response.statusCode == 200) {
          isLoading.value = false;

          final Map<String, dynamic> responseData = json.decode(response.body);
          final String token = responseData['token'];
          final int isAdmin = responseData['user']['is_admin'];
          final String nama = responseData['user']['nama'];
          final String email = responseData['user']['email'];
          final int userId = responseData['user']['id'];
          final String kdAkses = responseData['user']['kd_akses'];
          final String jabatan = responseData['jabatan'];
          final String agama = responseData['agama'];
          final int stsKepeg = responseData['sts_kepeg'];

          await storeUserData(
            token: token,
            isAdmin: isAdmin,
            nama: nama,
            email: email,
            userId: userId,
            kdAkses: kdAkses,
            jabatan: jabatan,
            agama: agama,
            stsKepeg: stsKepeg,
          );

          print(response.body);
          if (passC.text == "password" &&
              responseData['user']['added_kd_akses'] == 0) {
            Get.offAllNamed(Routes.newKdPass);
          } else {
            Get.offAllNamed(Routes.home);
          }
        } else {
          isLoading.value = false;
          final Map<String, dynamic> responseData = json.decode(response.body);
          final String responseMessage = responseData['message'];
          throw Exception(responseMessage);
        }
      } catch (e) {
        String errorMessage = 'Error occurred';
        try {
          Map<String, dynamic> errorMap = json.decode(e.toString());
          errorMessage = errorMap['message'] ?? 'Terjadi Kesalahan';
        } catch (error) {
          print('Error JSON: $error');
        }
        print(errorMessage);
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Gagal melakukan login. $e");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password harus diisi!");
      isLoading.value = false;
    }
  }

  Future<void> storeUserData({
    required String token,
    required int isAdmin,
    required String nama,
    required String email,
    required int userId,
    required String kdAkses,
    required String jabatan,
    required String agama,
    required int stsKepeg,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setInt('is_admin', isAdmin);
    prefs.setString('nama', nama);
    prefs.setString('email', email);
    prefs.setInt('id', userId);
    prefs.setString('kd_akses', kdAkses);
    prefs.setString('nm_jabatan', jabatan);
    prefs.setString('nm_agama', agama);
    prefs.setInt('sts_kepeg', stsKepeg);
  }
}
