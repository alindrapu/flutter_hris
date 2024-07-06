import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Detail Presensi'),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {
                Get.back(),
              },
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Styles.themeDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateFormat.yMMMMEEEEd('id_ID')
                        .format(DateTime.parse(data['tanggal_presensi'])),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Masuk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                data['jam_masuk'] == null
                    ? const Text("Jam : -")
                    : Text("Jam : ${data['jam_masuk']}"),
                data['latitude_masuk'] == null
                    ? const Text("Posisi : -")
                    : Text(
                        "Posisi : ${data['latitude_masuk']}, ${data['longitude_keluar']}"),
                data['status_lokasi_masuk'] == null
                    ? const Text("Status : -")
                    : Text("Status : ${data['status_lokasi_masuk']}"),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Keluar",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                data['jam_keluar'] == null
                    ? const Text("Jam : -")
                    : Text("Jam : ${data['jam_keluar']}"),
                data['latitude_keluar'] == null
                    ? const Text("Posisi : -")
                    : Text(
                        "Posisi : ${data['latitude_keluar']}, ${data['longitude_keluar']}"),
                data['status_lokasi_keluar'] == null
                    ? const Text("Status : -")
                    : Text("Status : ${data['status_lokasi_keluar']}"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
