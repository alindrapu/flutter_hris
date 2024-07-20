import 'package:get/get.dart';

import '../controllers/pengajuan_cuti_controller.dart';

class PengajuanCutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengajuanCutiController>(
      () => PengajuanCutiController(),
    );
  }
}
