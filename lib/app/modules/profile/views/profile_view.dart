// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:hris/app/widgets/confirmation_dialog.dart';

import '../controllers/profile_controller.dart';
import '../../../controllers/page_index_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Profil Pegawai'),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder<Map<String, dynamic>>(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          width: 150,
                          height: 150,
                          child: Image.asset('assets/img/def_ava.jpg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userDetails!['nama'].toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25,
                        color: Styles.themeDark,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userDetails['jabatan'].toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Styles.themeDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    iconColor: Styles.themeDark,
                    textColor: Styles.themeDark,
                    onTap: () => Get.toNamed(Routes.updateProfile),
                    leading: const Icon(Icons.person),
                    title: const Text("Ubah Profil Pegawai"),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    iconColor: Styles.themeDark,
                    textColor: Styles.themeDark,
                    onTap: () => Get.toNamed(Routes.updatePassword),
                    leading: const Icon(Icons.vpn_key),
                    title: const Text("Ubah Password"),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    iconColor: Styles.themeDark,
                    textColor: Styles.themeDark,
                    onTap: () => Get.toNamed(Routes.pengajuanCuti),
                    leading: const Icon(Icons.grass_outlined),
                    title: const Text("Pengajuan Cuti"),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    iconColor: Styles.themeDark,
                    textColor: Styles.themeDark,
                    onTap: () => Get.toNamed(Routes.riwayatCuti),
                    leading: const Icon(Icons.history),
                    title: const Text("Riwayat Cuti"),
                  ),
                  const SizedBox(height: 10),
                  if (userDetails['is_admin'].toString() == '1')
                    ListTile(
                      iconColor: Styles.themeDark,
                      textColor: Styles.themeDark,
                      onTap: () => {Get.toNamed(Routes.addPegawai)},
                      leading: const Icon(Icons.person_add),
                      title: const Text("Tambah Pegawai"),
                    ),
                  if (userDetails['is_admin'].toString() == '1')
                    const SizedBox(height: 10),
                  if (userDetails['is_admin'].toString() == '1')
                    ListTile(
                      iconColor: Styles.themeDark,
                      textColor: Styles.themeDark,
                      onTap: () {},
                      leading: const Icon(Icons.note_add_rounded),
                      title: const Text("Rekap Presensi Pegawai"),
                    ),
                  if (userDetails['is_admin'].toString() == '1')
                    const SizedBox(height: 10),
                  if (userDetails['is_admin'].toString() == '1')
                    ListTile(
                      iconColor: Styles.themeDark,
                      textColor: Styles.themeDark,
                      onTap: () => Get.toNamed(Routes.approvalCuti),
                      leading: const Icon(Icons.approval_rounded),
                      title: const Text("Approval Cuti Pegawai"),
                    ),
                  if (userDetails['is_admin'].toString() == '1')
                    const SizedBox(height: 10),
                  ListTile(
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    onTap: () => {
                      Get.dialog(
                        ConfirmationDialog(
                          title: "Konfirmasi",
                          message:
                              "Apakah anda yakin untuk keluar dari aplikasi?",
                          confirmButtonText: "Keluar",
                          onConfirm: () {
                            controller.logout();
                          },
                          cancelButtonText: "Batal",
                          onCancel: () {},
                        ),
                      )
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text("Keluar"),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.home, title: 'Beranda'),
          TabItem(icon: Icons.fingerprint_rounded, title: 'Absen'),
          TabItem(icon: Icons.people, title: 'Profil'),
        ],
        backgroundColor: Styles.themeDark,
        color: Styles.themeLight,
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
