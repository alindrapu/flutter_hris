// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/controllers/absen_controller.dart';
import 'package:hris/app/controllers/location_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:hris/app/widgets/confirmation_dialog.dart';
import 'package:hris/app/widgets/text_dialog.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  late int kdAbsen;
  late String statusLokasi;

  get absenController => null;

  void changePage(int i) async {
    switch (i) {
      case 1:
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(
              color: Styles.themeLight,
              backgroundColor: Styles.themeDark,
            ),
          ),
          barrierDismissible: false,
        );
        // Cek dulu statusnya dalam area atau tidak dengan function haversine,
        // Kalau dalam area pilihan absen adalah absen seperti biasa
        // kalau di luar area berikan 2 jenis, WFH dan Perjalanan Dinas.
        Map<String, dynamic> response =
            await LocationController.determinePosition();
        Get.back();
        final cekAbsenMasuk = await AbsenController.checkAbsen();
        print(cekAbsenMasuk?['jamMasuk']);

        if (response["error"] != true) {
          Position position = response["position"];
          // Absen dalam area
          if (double.parse(response['distance']['jarakM']) <= 200) {
            print(position);
            statusLokasi = "Di dalam area";

            if (cekAbsenMasuk?['jamMasuk'] == null) {
              // Absen Masuk
              Get.dialog(
                ConfirmationDialog(
                  title: "ABSEN MASUK",
                  message: "Anda berada di dalam area, lakukan absensi WFO?",
                  confirmButtonText: "Ya",
                  cancelButtonText: "Kembali",
                  onConfirm: () async {
                    int kdAbsen = 1;
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );
                    await AbsenController()
                        .absenPegawai(position, kdAbsen, statusLokasi);
                  },
                  onCancel: () {
                    Get.back();
                    Get.back();
                  },
                ),
              );
            } else if (cekAbsenMasuk?['jamMasuk'] != null &&
                cekAbsenMasuk?['jamKeluar'] == null) {
              //   Absen Keluar
              Get.dialog(
                ConfirmationDialog(
                  title: "ABSEN KELUAR",
                  message: "Anda berada di dalam area, lakukan absen keluar?",
                  confirmButtonText: "Ya",
                  cancelButtonText: "Kembali",
                  onConfirm: () async {
                    int kdAbsen = 1;
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );
                    await AbsenController()
                        .absenPegawai(position, kdAbsen, statusLokasi);
                  },
                  onCancel: () {},
                ),
              );
            } else {
              Get.snackbar("Terjadi Kesalahan",
                  "Absen masuk dan absen keluar Anda hari ini sudah tercatat! Tidak bisa melakukan absen lagi");
            }
          } else if (double.parse(response['distance']['jarakM']) > 200) {
            // Absen luar area
            statusLokasi = "Di luar area";
            if (cekAbsenMasuk?['jamMasuk'] == null) {
              Get.dialog(
                ConfirmationDialog(
                  title: "ABSEN MASUK",
                  message: "Anda berada di luar area, pilih jenis absensi",
                  confirmButtonText: "WFH",
                  cancelButtonText: "Perjalanan Dinas",
                  onConfirm: () async {
                    kdAbsen = 2;
                    Get.dialog(
                      TextDialog(
                        title: "Alasan",
                        message: "Masukkan alasan WFH/Perjalanan Dinas",
                        confirmButtonText: "Absen",
                        cancelButtonText: "Batal",
                        onConfirm: (text) async {
                          await AbsenController()
                              .absenPegawai(position, kdAbsen, statusLokasi, text);
                        },
                        onCancel: () {},
                        controller: AbsenController().alasanC,
                      ),
                    );
                  },
                  onCancel: () async {
                    kdAbsen = 3;
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );
                    Get.dialog(
                      TextDialog(
                        title: "Alasan",
                        message: "Masukkan alasan WFH/Perjalanan Dinas",
                        confirmButtonText: "Absen",
                        cancelButtonText: "Batal",
                        onConfirm: (text) async {
                          await AbsenController()
                              .absenPegawai(position, kdAbsen, statusLokasi, text);
                        },
                        onCancel: () {
                          Get.back();
                        },
                        controller: AbsenController().alasanC,
                      ),
                    );
                  },
                ),
              );
            } else if (cekAbsenMasuk?['jamMasuk'] != null &&
                cekAbsenMasuk?['jamKeluar'] == null) {
              Get.dialog(
                ConfirmationDialog(
                  title: "ABSEN KELUAR",
                  message: "Anda berada di luar area, lakukan absen keluar?",
                  confirmButtonText: "Ya",
                  cancelButtonText: "Kembali",
                  onConfirm: () async {
                    int kdAbsen = 1;
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false,
                    );
                    await AbsenController()
                        .absenPegawai(position, kdAbsen, statusLokasi);
                  },
                  onCancel: () {},
                ),
              );
            } else {
              Get.snackbar("Terjadi Kesalahan",
                  "Absen masuk dan absen keluar Anda hari ini sudah tercatat! Tidak bisa melakukan absen lagi");
            }
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
