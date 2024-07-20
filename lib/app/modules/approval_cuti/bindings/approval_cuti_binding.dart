import 'package:get/get.dart';

import '../controllers/approval_cuti_controller.dart';

class ApprovalCutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApprovalCutiController>(
      () => ApprovalCutiController(),
    );
  }
}
