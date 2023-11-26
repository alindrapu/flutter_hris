import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmNewPassC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty && confirmNewPassC.text.isNotEmpty) {
      if (newPassC.text == confirmNewPassC.text) {
        try {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(newPassC.text);
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: newPassC.text);
          Get.snackbar("Berhasil", "Password berhasil diubah");
          Get.offAllNamed(Routes.home);
        } on FirebaseAuthException catch (e) {
          if (e.code == "weak_password") {
            Get.snackbar("Terjadi Kesalahan",
                "Password lemah, Password wajib mengandung angka atau simbol");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat mengubah password, silahkan coba lagi nanti");
        }
      } else if (newPassC.text == "r4h4s14") {
        Get.snackbar("Terjadi Kesalahan", "Password harus diubah!");
      } else {
        Get.snackbar("Terjadi Kesalahan", "Password tidak cocok!");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan",
          "Password Baru dan Konfirmasi Password Baru wajib diisi!");
    }
  }
}
