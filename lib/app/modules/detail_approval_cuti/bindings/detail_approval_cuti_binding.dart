import 'package:get/get.dart';

import '../controllers/detail_approval_cuti_controller.dart';

class DetailApprovalCutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailApprovalCutiController>(
      () => DetailApprovalCutiController(),
    );
  }
}
