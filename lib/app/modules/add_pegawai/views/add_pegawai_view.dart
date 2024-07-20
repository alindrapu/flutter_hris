// ignore_for_file: library_private_types_in_public_api, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/data/models/agama.dart';
import 'package:hris/app/data/models/jabatan.dart';
import 'package:hris/app/styles/styles.dart';
import '../controllers/add_pegawai_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/config/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AddPegawaiView extends StatefulWidget {
  const AddPegawaiView({super.key});

  @override
  State<AddPegawaiView> createState() => _AddPegawaiViewState();
}

class _AddPegawaiViewState extends State<AddPegawaiView> {
  final AddPegawaiController controller = Get.put(AddPegawaiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Tambah Pegawai'),
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
          TextField(
            autocorrect: false,
            controller: controller.kdAksesC,
            decoration: InputDecoration(
              labelText: "Kode Akses",
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
            controller: controller.namaPegawaiC,
            decoration: InputDecoration(
              labelText: "Nama Pegawai",
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
            controller: controller.nikC,
            decoration: InputDecoration(
              labelText: "NIK",
              labelStyle: const TextStyle(color: Styles.themeDark),
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
            controller: controller.alamatC,
            decoration: InputDecoration(
              labelText: "Alamat",
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
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email Pegawai",
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
            keyboardType: TextInputType.number,
            controller: controller.noTelpC,
            decoration: InputDecoration(
              labelText: "No. Telp/WA Pegawai",
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
            controller: controller.tempatLahirC,
            decoration: InputDecoration(
              labelText: "Tempat Lahir Pegawai",
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
            controller: controller.tanggalLahirC,
            decoration: InputDecoration(
              labelText: "Tanggal Lahir Pegawai",
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
                  controller.tanggalLahirC.text =
                      DateFormat('dd-MM-yyyy').format(picked);
                });
              }
            },
          ),
          const SizedBox(height: 20),
          DropdownSearch<Agama>(
            popupProps: const PopupProps.dialog(),
            onChanged: (value) => {controller.agamaC.text = value!.nmAgama},
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Agama",
              ),
            ),
            asyncItems: (String filter) async {
              String url = Api.listAgama;

              var response = await http.get(Uri.parse(url));
              List allAgama =
                  (json.decode(response.body) as Map<String, dynamic>)['value'];
              List<Agama> agama = [];

              allAgama.forEach((element) {
                agama.add(Agama(
                    nmAgama: element['nm_agama'],
                    kdAgama: element['kd_agama']));
              });

              return agama;
            },
            itemAsString: (Agama agama) => agama.nmAgama,
          ),
          const SizedBox(height: 20),
          DropdownSearch<Jabatan>(
            popupProps: const PopupProps.dialog(),
            onChanged: (value) => {controller.jabatanC.text = value!.nmJabatan},
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Jabatan",
              ),
            ),
            asyncItems: (String filter) async {
              String url = Api.listJabatan;

              var response = await http.get(Uri.parse(url));
              List allJabatan =
                  (json.decode(response.body) as Map<String, dynamic>)['value'];
              List<Jabatan> jabatan = [];

              allJabatan.forEach((element) {
                jabatan.add(Jabatan(
                    nmJabatan: element['nm_jabatan'],
                    kdJabatan: element['kd_jabatan']));
              });

              return jabatan;
            },
            itemAsString: (Jabatan jabatan) => jabatan.nmJabatan,
          ),
          const SizedBox(height: 20),
          DropdownSearch<String>(
            popupProps: const PopupProps.dialog(),
            items: const ["Pria", "Wanita"],
            onChanged: (value) => {controller.jenisKelaminC.text = value!},
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Jenis Kelamin",
              ),
            ),
          ),
          const SizedBox(height: 20),
          DropdownSearch<String>(
            items: const ["Admin", "Perangkat Desa"],
            popupProps: const PopupProps.dialog(),
            onChanged: (value) => {controller.roleC.text = value!},
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Role User",
              ),
            ),
          ),
          const SizedBox(height: 20),
          DropdownSearch<String>(
            items: const ["Aktif", "Tidak Aktif"],
            popupProps: const PopupProps.dialog(),
            onChanged: (value) => {controller.stsKepegC.text = value!},
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Status Kepegawaian",
              ),
            ),
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Styles.themeDark),
                foregroundColor:
                    WidgetStateProperty.all<Color>(Styles.themeLight),
              ),
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.addPegawai();
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "Tambah Pegawai"
                  : "Sedang Proses.."),
            ),
          )
        ],
      ),
    );
  }
}
