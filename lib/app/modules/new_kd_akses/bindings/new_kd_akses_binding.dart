import 'package:get/get.dart';

import '../controllers/new_kd_akses_controller.dart';

class NewKdAksesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewKdAksesController>(
      () => NewKdAksesController(),
    );
  }
}
