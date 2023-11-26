import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ubah Password'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(40),
          children: [
            TextField(
              controller: controller.newPassC,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password Baru",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controller.confirmNewPassC,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Konfirmasi Password Baru",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () => {
                      controller.newPassword(),
                    },
                child: const Text("Lanjutkan")),
          ],
        ));
  }
}
