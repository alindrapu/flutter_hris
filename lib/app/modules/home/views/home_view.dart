// ignore_for_file: use_super_parameters, avoid_print, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Function untuk fetch data dari firestore
    Future<String?> getNamaPegawai(String userId) async {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('pegawai')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          return snapshot.data()?['namaPegawai'];
        } else {
          return null;
        }
      } catch (e) {
        print('Error fetching user data: $e');
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Aplikasi Absensi Karyawan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                try {
                  controller.isLoading.value = true;
                  await FirebaseAuth.instance.signOut();
                  controller.isLoading.value = false;
                  Get.offAllNamed(Routes.login);
                } catch (e) {
                  print('Error signing out: $e');
                  controller.isLoading.value = false;
                }
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Colors.white70,
      ),
      body: Center(
        child: FutureBuilder<String?>(
          future: getNamaPegawai(currentUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError || snapshot.data == null) {
              return const Text('Selamat datang, ');
            } else {
              final namaPegawai = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selamat datang, $namaPegawai',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton:
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }
          String role = snapshot.data!.data()!["role"];
          return Obx(() {
            if (role == "admin") {
              return Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 20), 
                    FloatingActionButton(
                      onPressed: () => Get.offAllNamed(Routes.addPegawai),
                      child: controller.isLoading.isFalse
                          ? const Icon(Icons.person_add_rounded)
                          : const CircularProgressIndicator(),
                    ),
                    SizedBox(width: 20), 
                    FloatingActionButton(
                      onPressed: () => Get.offAllNamed(Routes.profile),
                      child: controller.isLoading.isFalse
                          ? const Icon(Icons.person)
                          : const CircularProgressIndicator(),
                    ),
                  ],
                ),
              );
            } else {
              return Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () => Get.offAllNamed(Routes.profile),
                  child: controller.isLoading.isFalse
                      ? const Icon(Icons.person)
                      : const CircularProgressIndicator(),
                  
                ),
              );
            }
          });
        },
      ),
    );
  }
}
