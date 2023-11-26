import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:hris/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (kDebugMode) {
      print("login berhasil");
    }

    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        // ignore: unused_local_variable
        final credential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passC.text);

        if (credential.user!.emailVerified == true) {
          isLoading.value = false;
          if (passC.text == "r4h4s14") {
            Get.offAllNamed(Routes.newPassword);
          } else {
            Get.offAllNamed(Routes.home);
          }
        } else {
          Get.defaultDialog(
              title: "Belum Verifikasi",
              middleText: "Anda belum melakukan verifikasi email",
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await credential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar("Berhasil",
                          "Berhasil mengirim ulang Email Verifikasi, silahkan cek Email Anda yang terdaftar");
                      isLoading.value = false;
                    } catch (e) {
                      isLoading.value = false;
                      Get.snackbar("Terjadi Kesalahan",
                          "Hubungi Admin untuk info lebih lanjut");
                    }
                  },
                  child: const Text('Kirim email verifikasi'),
                )
              ]);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code.isNotEmpty) {
          Get.snackbar('Terjadi Kesalahan', 'Email atau Password salah');
          isLoading.value = false;
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login, coba lagi nanti");
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password harus diisi!");
      isLoading.value = false;
    }
  }
}
