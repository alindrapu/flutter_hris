import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/data/models/user_details.dart';
import 'package:http/http.dart' as http;
import 'package:hris/app/config/api.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  final nikC = TextEditingController();
  final kdAksesC = TextEditingController();
  final namaPegawaiC = TextEditingController();
  final alamatC = TextEditingController();
  final emailC = TextEditingController();
  final noTelpC = TextEditingController();
  final tempatLahirC = TextEditingController();
  final tanggalLahirC = TextEditingController();
  final agamaC = TextEditingController();
  final jabatanC = TextEditingController();
  final roleC = TextEditingController();
  final jenisKelaminC = TextEditingController();
  final stsKepegC = TextEditingController();

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

  Future<void> addPegawai() async {
    UserDetails? userDetails = await getUserDetails();

    if (nikC.text.isNotEmpty &&
        namaPegawaiC.text.isNotEmpty &&
        alamatC.text.isNotEmpty &&
        alamatC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        noTelpC.text.isNotEmpty &&
        tempatLahirC.text.isNotEmpty &&
        tanggalLahirC.text.isNotEmpty &&
        agamaC.text.isNotEmpty &&
        jabatanC.text.isNotEmpty &&
        roleC.text.isNotEmpty &&
        jenisKelaminC.text.isNotEmpty &&
        jenisKelaminC.text.isNotEmpty &&
        kdAksesC.text.isNotEmpty &&
        stsKepegC.text.isNotEmpty) {

      isLoading.value = true;
      final Map<String, dynamic> body = {
        "user_id": nikC.text,
        "kd_akses": kdAksesC.text,
        "nama": namaPegawaiC.text,
        "email": emailC.text,
        "nik": nikC.text,
        "telp": noTelpC.text,
        "tempat_lahir": tempatLahirC.text,
        "tanggal_lahir": tanggalLahirC.text,
        "jenis_kelamin": jenisKelaminC.text,
        "alamat": alamatC.text,
        "is_admin": int.tryParse(roleC.text),
        "kd_agama": int.tryParse(agamaC.text),
        "kd_jabatan": jabatanC.text,
        "sts_kepeg": int.tryParse(stsKepegC.text)
      };

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${userDetails?.token ?? ''}',
        'Content-Type': 'application/json',
      };

      String jsonBody = jsonEncode(body);
      String url = Api.addPegawaiCurrent;

      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: jsonBody);

        if (response.statusCode == 200) {
          Get.snackbar("Berhasil", "Pegawai baru berhasil ditambahkan");
          Get.offAllNamed(Routes.addPegawai);
        }
      } catch (e) {
        isLoading.value = false;

        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai");
      }
    } else {
      isLoading.value = false;

      Get.snackbar("Terjadi Kesalahan", "NIP, Nama dan Email wajib diisi");
    }
  }
}
