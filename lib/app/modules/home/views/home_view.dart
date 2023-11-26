// ignore_for_file: use_super_parameters, avoid_print
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

    // Function to fetch user data from Firestore
    Future<String?> getNamaPegawai(String userId) async {
      try {
        // Assuming you have a 'users' collection in Firestore
        var snapshot = await FirebaseFirestore.instance
            .collection('pegawai')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          // If the document exists, return the display name
          return snapshot.data()?['namaPegawai'];
        } else {
          return null; // Document doesn't exist
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
              onPressed: () => Get.toNamed(Routes.addPegawai),
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(Routes.login);
              },
              icon: const Icon(Icons.logout)),
        ],
        backgroundColor: Colors.white70,
      ),
      body: Center(
        child: FutureBuilder<String?>(
            future: getNamaPegawai(currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // or some loading indicator
              } else if (snapshot.hasError || snapshot.data == null) {
                return const Text('Error fetching nama pegawai');
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
            }),
      ),
    );
  }
}
