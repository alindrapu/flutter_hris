import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  const DetailPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailPresensiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailPresensiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
