import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/data/models/jenis_cuti.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../controllers/pengajuan_cuti_controller.dart';

class PengajuanCutiView extends StatefulWidget {
  const PengajuanCutiView({super.key});

  @override
  State<PengajuanCutiView> createState() => _PengajuanCutiViewState();
}

class _PengajuanCutiViewState extends State<PengajuanCutiView> {
  final PengajuanCutiController controller = Get.put(PengajuanCutiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Pengajuan Cuti'),
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
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          const SizedBox(height: 20),
          DropdownSearch<JenisCuti>(
            popupProps: const PopupProps.dialog(),
            onChanged: (value) =>
                {controller.jenisCutiC.text = value!.nmJenisCuti},
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Jenis Cuti",
              ),
            ),
            asyncItems: (String filter) async {
              String url = Api.listJenisCuti;

              var response = await http.get(Uri.parse(url));
              List allJenisCuti =
                  (json.decode(response.body) as Map<String, dynamic>)['value'];
              List<JenisCuti> jenisCuti = [];

              allJenisCuti.forEach((element) {
                jenisCuti.add(JenisCuti(
                    nmJenisCuti: element['nm_jenis_cuti'],
                    kdJenisCuti: element['kd_jenis_cuti']));
              });

              return jenisCuti;
            },
            itemAsString: (JenisCuti jenisCuti) => jenisCuti.nmJenisCuti,
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.alasanC,
            decoration: InputDecoration(
              labelText: "Alasan Cuti",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeDark),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeLight),
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.tanggalMulaiC,
            decoration: InputDecoration(
              labelText: "Tanggal Mulai Cuti",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeDark),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeLight),
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                setState(() {
                  controller.tanggalMulaiC.text =
                      DateFormat('dd-MM-yyyy').format(picked);
                });
              }
            },
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.tanggalSelesaiC,
            decoration: InputDecoration(
              labelText: "Tanggal Selesai Cuti",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeDark),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeLight),
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

              if (picked != null) {
                setState(() {
                  controller.tanggalSelesaiC.text =
                      DateFormat('dd-MM-yyyy').format(picked);
                });
              }
            },
          ),
          const SizedBox(height: 20),
          Obx(
            () => ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Styles.themeDark),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Styles.themeLight),
              ),
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.requestCuti();
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "Ajukan Cuti"
                  : "Sedang Proses.."),
            ),
          )
        ],
      ),
    );
  }
}
