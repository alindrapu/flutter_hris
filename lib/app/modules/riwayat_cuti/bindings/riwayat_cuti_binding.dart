import 'package:get/get.dart';

import '../controllers/riwayat_cuti_controller.dart';

class RiwayatCutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatCutiController>(
      () => RiwayatCutiController(),
    );
  }
}
