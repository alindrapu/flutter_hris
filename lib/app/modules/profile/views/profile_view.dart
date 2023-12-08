import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pegawai'),
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: controller.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userDetails = snapshot.data;

            return ListView(
              padding: const EdgeInsets.all(30),
              children: [
                const CircleAvatar(
                  radius: 70,
                ),
                const SizedBox(height: 20),
                Text(
                  userDetails!['nama'].toString().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  userDetails['jabatan'].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () => Get.toNamed(Routes.updateProfile),
                  leading: const Icon(Icons.person),
                  title: const Text("Ubah Profil Pegawai"),
                ),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () => Get.toNamed(Routes.updatePassword),
                  leading: const Icon(Icons.vpn_key),
                  title: const Text("Ubah Password"),
                ),
                if (userDetails['is_admin'] == 1)
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.person_add),
                    title: const Text("Tambah Pegawai"),
                  ),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.person_add),
                  title: const Text("Rekap Absensi Pegawai"),
                ),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.person_add),
                  title: const Text("Approval Cuti Pegawai"),
                ),
                const SizedBox(height: 10),
                ListTile(
                  onTap: () => controller.logout(),
                  leading: const Icon(Icons.logout),
                  title: const Text("Keluar"),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
