// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  late RxMap<String, dynamic> userDetails;

  @override
  void onInit() {
    super.onInit();
    userDetails = <String, dynamic>{}.obs;
    // Fetch user details when the controller is initialized
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final details = await getUserDetails();
    userDetails.assignAll(details);
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString('nama'),
      'jabatan': prefs.getString('nm_jabatan'),
      'agama': prefs.getString('nm_agama'),
      'is_admin': prefs.getInt('is_admin'),
      'token': prefs.getString('token')
    };
  }

  void logout() async {
    String url = Api.logout;

    try {
      final response = await http.get(Uri.parse(url),
          headers: {'Authorization': 'Bearer ${userDetails['token']}'});

      if (response.statusCode == 200) {
        Get.toNamed(Routes.login);
        print(response.body);
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "gagal melakukan logout = $e");
    }
  }
}
