import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hris/app/styles/styles.dart';

import '../controllers/new_kd_pass_controller.dart';

class NewKdPassView extends GetView<NewKdPassController> {
  const NewKdPassView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Styles.themeDark,
          foregroundColor: Styles.themeLight,
          title: const Text('Ubah Kode Akses & Password'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(40),
          children: [
            TextField(
              controller: controller.newPassC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password Baru",
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
              controller: controller.confirmNewPassC,
              autocorrect: false,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Konfirmasi Password Baru",
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
              controller: controller.newKdAksesC,
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
              controller: controller.confirmKdAksesC,
              decoration: InputDecoration(
                labelText: "Konfirmasi Kode Akses",
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
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Styles.themeDark),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Styles.themeLight),
                ),
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.newKdPass();
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "Ubah" : "Sedang Proses.."),
              ),
            ),
          ],
        ));
  }
}
