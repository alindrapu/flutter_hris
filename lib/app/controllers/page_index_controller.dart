// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/controllers/absen_controller.dart';
import 'package:hris/app/controllers/location_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:hris/app/widgets/confirmation_dialog.dart';


class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int i) async {
    switch (i) {
      case 1:
        Get.dialog(
          const Center(
              child: CircularProgressIndicator(
            color: Styles.themeLight,
            backgroundColor: Styles.themeDark,
          )),
          barrierDismissible: false,
        );
        // Cek dulu statusnya dalam area atau tidak dengan function haversine,
        // Kalau dalam area pilihan absen adalah absen seperti biasa
        // kalau di luar area berikan 2 jenis, WFH dan Perjalanan Dinas.
        Map<String, dynamic> response =
            await LocationController.determinePosition();
        Get.back();
        if (response["error"] != true) {
          Position position = response["position"];
          if (double.parse(response['distance']['jarakM']) <= 200) {
            Get.dialog(
              ConfirmationDialog(
                title: "Absen di dalam area!",
                message: "Lakukan absensi WFO?",
                confirmButtonText: "Ya",
                cancelButtonText: "Kembali",
                onConfirm: () async {
                  Get.dialog(
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    barrierDismissible: false,
                  );
                  await absenController.absenPegawai(position);
                },
              ),
            );
          } else {
            Get.dialog(
              ConfirmationDialog(
                title: "Absen di luar area!",
                message: "Pilih jenis absensi",
                confirmButtonText: "WFH",
                cancelButtonText: "Perjalanan Dinas",
                onConfirm: () async {
                  Get.dialog(
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    barrierDismissible: false,
                  );
                  await absenController.absenPegawai(position);
                },
              ),
            );
          }
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
