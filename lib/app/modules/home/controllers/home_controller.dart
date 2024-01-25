
import 'package:get/get.dart';
import 'package:hris/app/controllers/location_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
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
    final Map<String, dynamic> location = await LocationController.determinePosition();
    final String jalan = location['address'][0].street;
    final String kelurahan = location['address'][0].subLocality;
    final String kecamatan = location['address'][0].locality;
    final String kota = location['address'][0].subAdministrativeArea;
    final String provinsi = location['address'][0].administrativeArea;
    final jarak = location['distance']['pembulatan'];
    final jarakM = location['distance']['jarakM'];


    return {
      'nama': prefs.getString('nama'),
      'jabatan': prefs.getString('nm_jabatan'),
      'agama': prefs.getString('nm_agama'),
      'is_admin': prefs.getInt('is_admin'),
      'token': prefs.getString('token'),
      'address' : '$jalan, $kelurahan',
      'jarak': jarak,
      'jarakM': jarakM
    };
  }
}
