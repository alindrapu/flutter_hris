import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pegawai'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.nipC,
            decoration: const InputDecoration(
              labelText: "NIP",
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
              labelText: "Alamat Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: () => {controller.addPegawai()},
              child: const Text("Tambah Pegawai")),
        ],
      ),
    );
  }
}
