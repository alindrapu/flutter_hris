// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HRIS DEV'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.addPegawai),
              icon: const Icon(Icons.person)),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Human Resources Information System, ',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
