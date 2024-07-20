import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:hris/app/widgets/confirmation_dialog.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../controllers/detail_approval_cuti_controller.dart';

class DetailApprovalCutiView extends GetView<DetailApprovalCutiController> {
  final Map<String, dynamic> data = Get.arguments;

  @override
  final DetailApprovalCutiController controller =
      Get.put(DetailApprovalCutiController());

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final tanggalPengajuan = DateFormat.yMMMMEEEEd('id_ID')
        .format(DateTime.parse(data['tanggal_pengajuan']));
    final tanggalMulai = DateFormat.yMMMMEEEEd('id_ID')
        .format(DateTime.parse(data['tanggal_mulai']));
    final tanggalSelesai = DateFormat.yMMMMEEEEd('id_ID')
        .format(DateTime.parse(data['tanggal_selesai']));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Detail Pengajuan Cuti'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['nama'].toString().toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['nm_jabatan'].toString().toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 17),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                  color: Styles.themeDark,
                  indent: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Tanggal Pengajuan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text(
                          " : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(tanggalPengajuan),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Tanggal Mulai",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text(
                          " : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(tanggalMulai),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Tanggal Selesai",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text(
                          " : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(tanggalSelesai),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Lama Cuti",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text(
                          " : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("${data['lama_cuti']} Hari"),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Alasan Cuti",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Column(
                      children: [
                        Text(
                          " : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("${data['alasan_cuti']}"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                  color: Styles.themeDark,
                  indent: 80,
                  endIndent: 80,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 45),
                          backgroundColor: Styles.themeDark,
                          foregroundColor: const Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          Get.dialog(
                            ConfirmationDialog(
                              title: "KONFIRMASI APPROVAL CUTI",
                              message:
                                  "Apakah Anda yakin untuk approve pengajuan cuti ini?",
                              confirmButtonText: "Ya",
                              cancelButtonText: "Kembali",
                              onConfirm: () async {
                                bool statusPersetujuan = true;

                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  barrierDismissible: false,
                                );
                                await DetailApprovalCutiController()
                                    .approveCuti(data['kd_akses'], data['id'],
                                        statusPersetujuan);
                              },
                              onCancel: () {
                                Get.back();
                                Get.back();
                              },
                            ),
                          );
                        },
                        child: Text(controller.isLoading.isFalse
                            ? "Approve Cuti"
                            : "Sedang Proses.."),
                      ),
                    ),
                    Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 45),
                          backgroundColor: Styles.themeCancel,
                          foregroundColor: const Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          bool statusPersetujuan = false;
                          Get.dialog(
                            ConfirmationDialog(
                              title: "KONFIRMASI TOLAK CUTI",
                              message:
                                  "Apakah Anda yakin untuk menolak pengajuan cuti ini?",
                              confirmButtonText: "Ya",
                              cancelButtonText: "Kembali",
                              onConfirm: () async {
                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  barrierDismissible: false,
                                );
                                await DetailApprovalCutiController()
                                    .approveCuti(data['kd_akses'], data['id'],
                                        statusPersetujuan);
                              },
                              onCancel: () {
                                Get.back();
                                Get.back();
                              },
                            ),
                          );
                        },
                        child: Text(controller.isLoading.isFalse
                            ? "Tolak Cuti"
                            : "Sedang Proses.."),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
