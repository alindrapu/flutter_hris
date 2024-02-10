// ignore_for_file: use_super_parameters

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/controllers/absen_controller.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:intl/intl.dart';
import '../../../controllers/page_index_controller.dart';
import '../controllers/home_controller.dart';

class AnimatedHero extends StatefulWidget {
  const AnimatedHero({super.key});

  @override
  State<AnimatedHero> createState() => _AnimatedHeroState();
}

class _AnimatedHeroState extends State<AnimatedHero> {
  final homeC = Get.find<HomeController>();
  double padValueTop = 0.03;
  double padValueBot = 0.0;

  void _updatePadding(double top, double bot) async {
    setState(() {
      padValueTop = top;
      padValueBot = bot;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.wait([homeC.getUserDetails()])
        .then((_) => _updatePadding(0.07, 0.02));
  }

  @override
  Widget build(BuildContext context) {
    final homeC = Get.find<HomeController>();
    double h = MediaQuery.of(context).size.height;

    String statusLokasi;
    Color statusColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
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
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 1250),
            curve: Curves.fastLinearToSlowEaseIn,
            padding:
                EdgeInsets.only(top: h * padValueTop, bottom: h * padValueBot),
            child: FutureBuilder<Map<String, dynamic>>(
              future: homeC.getUserDetails(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Styles.themeLight,
                      backgroundColor: Styles.themeDark,
                    ),
                  );
                } else if (snap.hasError) {
                  return Text('Error: ${snap.error}');
                } else {
                  final userDetails = snap.data;
                  final jarakLokasi = double.parse(userDetails!['jarakM']);

                  if (jarakLokasi <= 200) {
                    statusLokasi = 'Di dalam area';
                    statusColor = Styles.themeLight;
                  } else {
                    statusLokasi = 'Di luar area';
                    statusColor = Colors.amberAccent;
                  }
                  final fullName = userDetails['nama'];
                  final List<String> nameParts = fullName.split(' ');
                  final firstName = nameParts.isNotEmpty ? nameParts[0] : '';

                  return ListTile(
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
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Divider(
                          thickness: 2,
                          color: Styles.themeLight,
                          indent: 2,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userDetails['address']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              'Jarak dari kantor : ${userDetails['jarakM']}M (${userDetails['jarak']} KM)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              statusLokasi,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: statusColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Image.asset(
                      'assets/img/bg_logo.png',
                      isAntiAlias: true,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class HomeView extends StatelessWidget {
  final pageC = Get.find<PageIndexController>();
  final homeC = Get.find<HomeController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.normal,
        ),
        child: Column(
          children: [
            const AnimatedHero(),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>?>(
                future: absenController.checkAbsen(),
                builder: (context, snapToday) {
                  if (snapToday.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Styles.themeLight,
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  } else if (snapToday.hasError) {
                    return Text('Error: ${snapToday.error}');
                  } else {
                    final data = snapToday.data;
                    final jamMasuk = data?['jamMasuk'] == null
                        ? "--:--:--"
                        : data!['jamMasuk'];
                    final jamKeluar = data?['jamKeluar'] == null
                        ? "--:--:--"
                        : data!['jamKeluar'];

                    String timeFromData = jamMasuk;
                    late bool isLate = false;

                    if (jamMasuk != "--:--:--") {
                      List<String> timeParts = timeFromData.split(':');
                      int jam = int.parse(timeParts[0]);
                      int menit = int.parse(timeParts[1]);

                      // Waktu terlambat
                      int targetJam = 8;
                      int targetMenit = 15;

                      // Cek apakah terlambat
                      if (jam > targetJam ||
                          (jam == targetJam && menit > targetMenit)) {
                        isLate = true;
                      }
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(w * 0.05),
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: CupertinoColors.systemGrey5,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "JAM MASUK",
                                    style: TextStyle(
                                        color: Styles.themeDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  if (isLate == true)
                                    const Text(
                                      "Terlambat!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Styles.themeCancel),
                                    ),
                                  if (jamMasuk == "--:--:--")
                                    const Text(
                                      "Belum Absen!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Styles.themeDark),
                                    ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "$jamMasuk",
                                        style: const TextStyle(
                                            color: Styles.themeDark,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25),
                                      ),
                                      SizedBox(
                                        width: w * 0.05,
                                      ),
                                      const Icon(
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
                        ),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(w * 0.05),
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: CupertinoColors.systemGrey5,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    "JAM KELUAR",
                                    style: TextStyle(
                                      color: Styles.themeDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  if (jamKeluar == "--:--:--")
                                    const Text(
                                      "Belum Absen!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Styles.themeDark),
                                    ),
                                  if (jamKeluar != "--:--:--")
                                    const Text(
                                      "Sudah Absen!",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Styles.themeDark),
                                    ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.timer_off_outlined,
                                        size: 40,
                                        color: Styles.themeDark,
                                      ),
                                      SizedBox(
                                        width: w * 0.05,
                                      ),
                                      Text(
                                        "$jamKeluar",
                                        style: const TextStyle(
                                            color: Styles.themeDark,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }),
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
