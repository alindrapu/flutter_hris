import 'package:flutter/material.dart';
import 'package:hris/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            autocorrect: false,
            controller: controller.passC,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: "Password", border: OutlineInputBorder()),
          ),
          const SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.login();
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "Masuk" : "Sedang Proses.."),
            ),
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.forgotPassword);
              },
              child: const Text("Lupa password? Klik di sini")),
        ],
      ),
    );
  }
}
