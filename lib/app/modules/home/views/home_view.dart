// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  Future<String?> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nama');
  }

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.themeDark,
          title: const Text(
            'Pedurenan AbsensiNET',
            style: TextStyle(
              color: Styles.themeLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Styles.themeDark),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Styles.themeLight),
                ),
                onPressed: () => Get.toNamed(Routes.profile),
                icon: const Icon(Icons.person)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(40),
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: FutureBuilder<String?>(
                future: getUserDetails(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snap.hasData) {
                    return Text.rich(TextSpan(
                        text: 'Selamat datang, ',
                        style: const TextStyle(
                            fontSize: 20, color: Styles.themeDark),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${snap.data}!',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]));
                  } else {
                    return const Text('Selamat datang!');
                  }
                },
              ),
            )
          ],
        ));
  }
}
