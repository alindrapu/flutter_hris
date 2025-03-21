import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/widgets/no_data.dart';
import 'package:intl/intl.dart';

import '../controllers/riwayat_cuti_controller.dart';

class RiwayatCutiView extends StatefulWidget {
  const RiwayatCutiView({super.key});

  @override
  State<RiwayatCutiView> createState() => _RiwayatCutiViewState();
}

class _RiwayatCutiViewState extends State<RiwayatCutiView> {
  final riwayatC = Get.put(RiwayatCutiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Riwayat Cuti Pegawai'),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {
                Get.offAllNamed(Routes.profile),
              },
            ),
          ),
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        FutureBuilder(
            future: riwayatC.listRiwayatCuti(),
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
              } else if (!snapshot.hasError && riwayatC.approveList.isEmpty) {
                debugPrint('approveList Data: ${riwayatC.approveList}');
                return const NoDataWidget();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: riwayatC.approveList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> list = riwayatC.approveList[index];

                    // final tanggalMulai = DateTime.parse(list['tanggal_mulai']);
                    // final tanggalSelesai =
                    //     DateTime.parse(list['tanggal_selesai']);
                    final tanggalPengajuan =
                        DateTime.parse(list['tanggal_pengajuan']);
                    return Container(
                      margin: const EdgeInsets.only(left: 1, right: 1),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Material(
                          color: Styles.themeTeal,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.detailApprovalCuti,
                                  arguments: list);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        list['nama'].toString().toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        list['nm_jabatan']
                                            .toString()
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: Styles.themeDark,
                                    indent: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Tanggal Pengajuan Cuti",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        list['nm_jenis_cuti']
                                            .toString()
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Styles.themeCancel),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat.yMMMMd('id_ID')
                                        .format(tanggalPengajuan),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            })
      ]),
    );
  }
}
