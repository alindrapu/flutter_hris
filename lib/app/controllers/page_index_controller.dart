import 'package:get/get.dart';
import 'package:hris/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int i) async {
    print('click index = $i');
    switch (i) {
      case 1:
        print("absensi");
        break;
      case 2:
        pageIndex.value = i;
        Get.toNamed(Routes.profile);
        break;
      default:
        pageIndex.value = i;
        Get.toNamed(Routes.home);
    }
  }
}
