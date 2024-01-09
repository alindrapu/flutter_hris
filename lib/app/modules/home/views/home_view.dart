// ignore_for_file: use_super_parameters

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:intl/intl.dart';
import '../../../controllers/page_index_controller.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.23,
              decoration: const BoxDecoration(
                color: Styles.themeDark,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(80)),
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
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
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
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    )
                  ],
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(80)),
                  color: const Color.fromARGB(255, 194, 110, 110)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'MASUK\n',
                        style: TextStyle(
                          color: Styles.themeDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        DateFormat.Hm().format(DateTime.now()),
                        style: const TextStyle(
                          color: Styles.themeDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 5,
                    height: 50,
                    color: Styles.themeDark,
                  ),
                  Column(
                    children: [
                      const Text(
                        'KELUAR\n',
                        style: TextStyle(
                            color: Styles.themeDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        DateFormat.Hm().format(DateTime.now()),
                        style: const TextStyle(
                          color: Styles.themeDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
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
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(255, 96, 154, 179)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Masuk",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat.yMMMEd().format(DateTime.now()),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(DateFormat.Hm().format(DateTime.now())),
                        const SizedBox(height: 10),
                        const Text(
                          "Keluar",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat.Hm().format(DateTime.now())),
                      ]),
                );
              },
            ),
          ],
        ),
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
