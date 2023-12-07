import 'package:get/get.dart';

import '../controllers/new_kd_pass_controller.dart';

class NewKdPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewKdPassController>(
      () => NewKdPassController(),
    );
  }
}
