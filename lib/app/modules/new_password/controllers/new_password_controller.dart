import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmNewPassC = TextEditingController();
  TextEditingController newKdAksesC = TextEditingController();
  TextEditingController confirmKdAksesC = TextEditingController();

  Future<void> newPassword() async {
    if (newPassC.text.isNotEmpty && confirmNewPassC.text.isNotEmpty) {
      if (newPassC.text == confirmNewPassC.text) {
        try {
          Get.snackbar("Berhasil", "Password berhasil diubah");
          Get.offAllNamed(Routes.home);
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan",
              "Tidak dapat mengubah password, silahkan coba lagi nanti");
        }
      } else if (newPassC.text == "rahasia") {
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
