import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Profile Pegawai'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
         const TextField(
            autocorrect: false,
            // controller: controller.nipC,
            decoration:  InputDecoration(
              labelText: "NIP",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.namaPegawaiC,
            decoration: const InputDecoration(
              labelText: "Nama Pegawai",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.alamatC,
            decoration: const InputDecoration(
              labelText: "Alamat Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              onPressed: () {},
              child: Text(controller.isLoading.isFalse
                  ? "Ubah Profile"
                  : "Sedang Proses.."),
            ),
          )
        ],
      ),
    );
  }
}
