import 'package:get/get.dart';
import 'package:hris/app/data/models/user_details.dart';
import 'package:hris/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  Future<UserDetails?> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? nama = prefs.getString('nama');
    final String? token = prefs.getString('token');

    if (email != null && nama != null && token != null) {
      return UserDetails(email: email, nama: nama, token: token);
    } else {
      return null;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {

    yield* firestore.collection("pegawai").doc(uid).snapshots();
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed(Routes.login);
  }
}
