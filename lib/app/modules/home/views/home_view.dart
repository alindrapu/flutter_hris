// ignore_for_file: use_super_parameters

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:intl/intl.dart';
import '../../../controllers/page_index_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final pageC = Get.find<PageIndexController>();
  final homeC = Get.find<HomeController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            decelerationRate: ScrollDecelerationRate.normal),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: h * 0.07),
              constraints: BoxConstraints(minHeight: h * 0.1),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 8,
                    blurRadius: 4,
                    offset: const Offset(-2, 2),
                  ),
                ],
                color: Styles.themeDark,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
              ),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  FutureBuilder<Map<String, dynamic>>(
                    future: homeC.getUserDetails(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Styles.themeLight,
                          backgroundColor: Styles.themeDark,
                        ));
                      } else if (snap.hasError) {
                        return Text('Error: ${snap.error}');
                      } else {
                        final userDetails = snap.data;
                        final jarakLokasi =
                            double.parse(userDetails!['jarakM']);
                        final statusLokasi = jarakLokasi <= 200
                            ? 'Di dalam area'
                            : 'Di luar area';

                        final fullName = userDetails['nama'];
                        final List<String> nameParts = fullName.split(' ');
                        final firstName =
                            nameParts.isNotEmpty ? nameParts[0] : '';

                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 30),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, $firstName!',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Styles.themeLight,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${userDetails['jabatan']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${userDetails['address']}'
                                'Jarak dari kantor : ${userDetails['jarakM']}M (${userDetails['jarak']} KM)'
                                '\n$statusLokasi',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          trailing: Image.asset(
                            'assets/img/bg_logo.png',
                            isAntiAlias: true,
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jam Masuk",
                            style: TextStyle(
                                color: Styles.themeDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "06 : 50",
                                style: TextStyle(
                                    color: Styles.themeDark,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Icon(
                                Icons.timer_outlined,
                                size: 40,
                                color: Styles.themeDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: CupertinoColors.systemGrey5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jam Keluar",
                            style: TextStyle(
                                color: Styles.themeCancel,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "06 : 50",
                                style: TextStyle(
                                    color: Styles.themeCancel,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Icon(
                                Icons.timer_off_outlined,
                                size: 40,
                                color: Styles.themeCancel,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(
              thickness: 2,
              color: Styles.themeLight,
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
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      color: Styles.themeTeal,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.detailPresensi);
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            // color: Color.fromARGB(255, 96, 154, 179)
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Masuk",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      DateFormat.yMMMEd()
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
                        ),
                      ),
                    ),
                  ),
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
