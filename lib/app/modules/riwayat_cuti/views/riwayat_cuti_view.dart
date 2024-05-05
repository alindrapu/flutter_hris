import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_cuti_controller.dart';

class RiwayatCutiView extends GetView<RiwayatCutiController> {
  const RiwayatCutiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RiwayatCutiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RiwayatCutiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
