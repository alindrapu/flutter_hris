import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:hris/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (kDebugMode) {
      print("login berhasil");
    }

    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        // ignore: unused_local_variable
        final credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        if (credential.user!.emailVerified == true) {
          Get.offAllNamed(Routes.home);
        } else {
          Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText: "Anda belum melakukan verifikasi email",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                    onPressed: () => {
                          credential.user!.sendEmailVerification(),
                        },
                    child: const Text('Kirim email verifikasi'))
              ]);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Email atau Password salah');
        } else {
          Get.snackbar("Terjadi Kesalahan", "Pegawai tidak ditemukan");
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login, coba lagi nanti");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password harus diisi!");
    }
  }
}
