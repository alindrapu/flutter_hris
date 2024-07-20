import 'package:shared_preferences/shared_preferences.dart';

mixin userDetailsController {
  static Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('id'),
      'nama': prefs.getString('nama'),
      'kd_akses': prefs.getString('kd_akses'),
      'token': prefs.getString('token'),
      'is_admin': prefs.getInt('is_admin'),
      'email': prefs.getString('email'),
      'nm_jabatan': prefs.getString('nm_jabatan'),
      'nm_agama': prefs.getString('nm_agama'),
      'sts_kepeg': prefs.getInt('sts_kepeg'),
    };
  }
}
