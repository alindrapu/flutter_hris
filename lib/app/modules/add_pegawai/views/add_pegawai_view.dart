// ignore_for_file: library_private_types_in_public_api, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_pegawai_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class AddPegawaiView extends StatefulWidget {
  const AddPegawaiView({super.key});

  @override
  _AddPegawaiViewState createState() => _AddPegawaiViewState();
}

class _AddPegawaiViewState extends State<AddPegawaiView> {
  final AddPegawaiController controller = Get.put(AddPegawaiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pegawai'),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {
                Get.offAllNamed(Routes.home),
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
            controller: controller.nikC,
            decoration: const InputDecoration(
              labelText: "NIK",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.namaC,
            decoration: const InputDecoration(
              labelText: "Nama Pegawai",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "Alamat Email Pegawai",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            controller: controller.noTelpC,
            decoration: const InputDecoration(
              labelText: "No. Telp/WA Pegawai",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.tempatLahirC,
            decoration: const InputDecoration(
              labelText: "Tempat Lahir Pegawai",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.tanggalLahirC,
            decoration: const InputDecoration(
              labelText: "Tanggal Lahir Pegawai",
              border: OutlineInputBorder(),
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
          TextField(
            autocorrect: false,
            controller: controller.agamaC,
            decoration: const InputDecoration(
              labelText: "Agama Pegawai",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.roleC,
            decoration: const InputDecoration(
              labelText: "Role User",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          DropdownSearch<String>(
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration:
                  InputDecoration(labelText: "Jabatan"),
            ),
            asyncItems: (String filter) async {
              var response = await http.get(Uri.parse(
                  "https://eed0-2400-9800-11-9ea5-d5e7-d37e-acd3-5ce2.ngrok-free.app/api/list-jabatan"));
              List allJabatan =
                  (json.decode(response.body) as Map<String, dynamic>)['value'];
              List<String> allNamaJabatan = [];

              allJabatan.forEach((element) {
                allNamaJabatan.add(element['nm_jabatan']);
              });

              return allNamaJabatan;
            },
            // ignore: avoid_print
            onChanged: (value) => print(value),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            onChanged: (String? newValue) {
              controller.jenisKelamin.value = newValue!;
            },
            items: const [
              DropdownMenuItem(value: "P", child: Text("Pria")),
              DropdownMenuItem(value: "W", child: Text("Wanita")),
            ],
            decoration: const InputDecoration(
              labelText: 'Jenis Kelamin',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
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
