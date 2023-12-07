import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_kd_akses_controller.dart';

class NewKdAksesView extends GetView<NewKdAksesController> {
  const NewKdAksesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NewKdAksesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NewKdAksesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
