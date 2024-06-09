import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:intl/intl.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({super.key});

  @override
  Widget build(BuildContext context) {
    final absenC = Get.put(AllPresensiController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Presensi Pegawai'),
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
          FutureBuilder(
            future: absenC.histories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Styles.themeLight,
                    backgroundColor: Colors.transparent,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error $snapshot");
              } else {
                return Obx(
                  () {
                    if (absenC.historyList.isEmpty) {
                      return const Center(child: Text('Tidak ada data'));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: absenC.historyList.length,
                      itemBuilder: (context, index) {
                        if (index >= absenC.historyList.length) {
                          // Safeguard against invalid index access
                          return const SizedBox.shrink();
                        }
                        Map<String, dynamic> history =
                            absenC.historyList[index];

                        final historyDate =
                            DateTime.parse(history['tanggal_presensi']);

                        final historyIn = history['jam_masuk'] ?? "--:--:--";
                        final historyOut = history['jam_keluar'] ?? "--:--:--";

                        return Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Material(
                              color: Styles.themeTeal,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.detailPresensi);
                                },
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    // color: Color.fromARGB(255, 96, 154, 179)
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Masuk",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              DateFormat.yMMMMd('id_ID')
                                                  .format(historyDate),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Text(historyIn),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Keluar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(historyOut),
                                      ]),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }
}
