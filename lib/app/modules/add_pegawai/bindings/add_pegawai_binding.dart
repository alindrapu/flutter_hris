import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPegawaiController>(
      () => AddPegawaiController(),
    );
  }
}
