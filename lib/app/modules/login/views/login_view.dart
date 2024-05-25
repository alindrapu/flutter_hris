import 'package:flutter/material.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:hris/app/styles/styles.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.themeDark,
        foregroundColor: Styles.themeLight,
        title: const Text('Pedurenan PresensiNET'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.kdAksesC,
            decoration: InputDecoration(
              labelText: "Kode Akses",
              prefixIcon: const Icon(Icons.keyboard_double_arrow_right),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeDark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeLight),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            autocorrect: false,
            controller: controller.passC,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              labelText: "Kata Sandi",
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeDark),
                borderRadius: BorderRadius.circular(20),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Styles.themeLight),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Styles.themeDark),
                foregroundColor:
                    MaterialStateProperty.all<Color>(Styles.themeLight),
              ),
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.login();
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "Masuk" : "Sedang Proses.."),
            ),
          ),
        ],
      ),
    );
  }
}
