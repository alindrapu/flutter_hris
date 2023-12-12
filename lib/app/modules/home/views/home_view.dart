// ignore_for_file: use_super_parameters

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/styles/styles.dart';
import '../../../controllers/page_index_controller.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Styles.themeDark,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
            ),
            alignment: Alignment.topLeft,
            child: Column(
              children: [
                const SizedBox(height: 100),
                FutureBuilder<Map<String, dynamic>>(
                  future: controller.getUserDetails(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snap.hasError) {
                      return Text('Error: ${snap.error}');
                    } else {
                      final userDetails = snap.data;
                      final String role;
                      if (userDetails!['is_admin'] == 1) {
                        role = 'Admin';
                      } else {
                        role = 'Pegawai';
                      }
                      return ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30),
                        title: Text(
                          'Halo, ${userDetails['nama']}!',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Styles.themeLight,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: Text(
                          '${userDetails['jabatan']}\n${role.toUpperCase()}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        trailing: ClipOval(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset('assets/img/bg_logo.png'),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
                color: Styles.themeDark),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Column(
                  children: [
                    Text(
                      'MASUK',
                      style: TextStyle(
                        color: Styles.themeLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text('-'),
                  ],
                ),
                Container(
                  width: 5,
                  height: 50,
                  color: Styles.themeLight,
                ),
                const Column(
                  children: [
                    Text(
                      'KELUAR',
                      style: TextStyle(
                          color: Styles.themeLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text('-'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(
            thickness: 2,
            color: Styles.themeDark,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '5 Hari Terakhir',
                  style: TextStyle(
                      color: Styles.themeDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Lebih Lengkap..',
                    style: TextStyle(
                        color: Styles.themeLightDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Styles.themeDark),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: const [
          TabItem(icon: Icons.home_rounded, title: 'Beranda'),
          TabItem(icon: Icons.fingerprint_rounded, title: 'Absen'),
          TabItem(icon: Icons.people_rounded, title: 'Profil'),
        ],
        backgroundColor: Styles.themeDark,
        color: Styles.themeLight,
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
