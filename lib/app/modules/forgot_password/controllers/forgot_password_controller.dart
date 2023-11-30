import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> forgotPassword() async {
    try {
      if (emailC.text.isNotEmpty) {
        isLoading.value = true;
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.defaultDialog(
          title: "Email terkirim!",
          middleText:
              "Email reset password berhasil dikirim, silahkan cek email Anda untuk melakukan reset password.",
          actions: [
            OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.offAllNamed(Routes.login);
              },
              child: const Text("Kembali ke halaman Login"),
            ),
          ],
        );
      } else if (emailC.text.isEmpty) {
        Get.snackbar("Terjadi Kesalahan", "Email harus diisi");
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code.isNotEmpty) {
        Get.snackbar("Terjadi Kesalahan",
            "Gagal mengirim email reset password, email tidak terdaftar");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan",
          "Gagal mengirim email reset password, silahkan coba lagi nanti.");
    }
  }
}
