// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:hris/app/widgets/confirmation_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  late RxMap<String, dynamic> userDetails;

  @override
  void onInit() {
    super.onInit();
    userDetails = <String, dynamic>{}.obs;
    // Fetch user details when the controller is initialized
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final details = await getUserDetails();
    userDetails.assignAll(details);
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString('nama'),
      'jabatan': prefs.getString('nm_jabatan'),
      'agama': prefs.getString('nm_agama'),
      'is_admin': prefs.getInt('is_admin'),
      'token': prefs.getString('token')
    };
  }

  void logout() async {
    String url = Api.logout;

    try {
      final response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${userDetails['token']}'});

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil",
          "Anda berhasil keluar! Silahkan masuk kembali",
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

  Future<void> downloadPresensiExcel() async {
    // Ensure the required permissions are granted
    if (await Permission.photos.request().isGranted) {
      // Define the API endpoint
      String url = Api.downloadLogPresensi;

      // Define the headers
      final Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer ${userDetails['token']}",
        "Content-Type": "application/json",
      };

      // Make the HTTP GET request
      const tanggalPresensi = '2024-01';
      final response = await http.get(
          Uri.parse('$url?tanggal_presensi=$tanggalPresensi'),
          headers: headers);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Get the external storage directory
        Directory? directory = await getDownloadsDirectory();
        directory ??= await getApplicationDocumentsDirectory();

        // Create a custom directory if necessary
        final String customDir = '${directory.path}/DownloadedExcels';
        await Directory(customDir).create(recursive: true);

        final filePath =
            '$customDir/log_presensi_${tanggalPresensi.replaceAll("-", "_")}.xlsx';

        // Create the file and write the response bytes
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        Get.dialog(
          ConfirmationDialog(
            title: "UNDUHAN BERHASIL",
            message: "File telah berhasil diunduh",
            confirmButtonText: "Buka",
            cancelButtonText: "Kembali",
            onConfirm: () {
              OpenFilex.open(filePath);
            },
            onCancel: () {
              Get.back();
            },
          ),
        );

        print('File downloaded: $filePath');
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } else {
      openAppSettings();
      print('Storage permission not granted');
    }
  }
}
