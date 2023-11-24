import 'package:get/get.dart';

class HomeController extends GetxController {

  final count = 0.obs;

  @override
  void onInit() {
    // Add behavior if needed
    super.onInit();
  }

  @override
  void onReady() {
    // Add behavior if needed
    super.onReady();
  }

  @override
  void onClose() {
    // Add behavior if needed
    super.onClose();
  }

  void increment() => count.value++;
}
