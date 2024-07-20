import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/styles.dart';
import '../controllers/update_profile_controller.dart';

mixin userDetailsController {
  static Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('id'),
      'nama': prefs.getString('nama') ?? '',
      'kd_akses': prefs.getString('kd_akses') ?? '',
      'token': prefs.getString('token') ?? '',
      'is_admin': prefs.getInt('is_admin') ?? 0,
      'email': prefs.getString('email') ?? '',
      'nm_jabatan': prefs.getString('nm_jabatan') ?? '',
      'nm_agama': prefs.getString('nm_agama') ?? '',
      'sts_kepeg': prefs.getInt('sts_kepeg') ?? 0,
      'telp': prefs.getString('telp') ?? '',
      'alamat': prefs.getString('alamat') ?? ''
    };
  }
}

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> userData = userDetailsController.getUserDetails();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Perubahan Profil Pegawai'),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            controller.kdAksesC.text = data['kd_akses'] ?? '';
            controller.namaPegawaiC.text = data['nama'] ?? '';
            controller.alamatC.text = data['alamat'] ?? '';
            controller.emailC.text = data['email'] ?? '';
            controller.noTelpC.text = data['telp'] ?? '';

            return ListView(
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
                    labelText: "Email",
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
                  controller: controller.noTelpC,
                  decoration: InputDecoration(
                    labelText: "No Telp",
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
                const SizedBox(height: 30),
                Obx(
                      () => ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Styles.themeDark),
                      foregroundColor: WidgetStateProperty.all<Color>(Styles.themeLight),
                    ),
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        await controller.updatePegawai();
                      }
                    },
                    child: Text(controller.isLoading.isFalse
                        ? "Ubah Profil"
                        : "Sedang Proses.."),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
