import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/data/models/user_details.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  Future<UserDetails?> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? nama = prefs.getString('nama');
    final String? token = prefs.getString('token');

    if (email != null && nama != null && token != null) {
      return UserDetails(email: email, nama: nama, token: token);
    } else {
      return null;
    }
  }

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
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              const Center(child: CircularProgressIndicator());
            }
            if (snap.hasData) {
              Map<String, dynamic> user = snap.data!.data()!;
              return ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  const CircleAvatar(
                    radius: 70,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user['namaPegawai'].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user['jabatan'],
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
                  if (user['role'] == 'admin')
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
            } else {
              return const Center(child: Text("Tidak dapat memuat data"));
            }
          },
        ));
  }
}
