import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async {
    if (kDebugMode) {
      print("testing error");
    }
    if (nipC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: 'r4h4s14',
        );
        if (credential.user != null) {
          String uid = credential.user!.uid;

          firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "namaPegawai": namaC.text,
            "emailPegawai": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });

          Get.snackbar('Berhasil', 'Berhasil menambahkan pegawai');
        }

        if (kDebugMode) {
          print(credential);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar(
              'Terjadi kesalahan', 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan',
              'The account already exists for that email.');
        }
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "NIP, Nama dan Email wajib diisi");
    }
  }
}
