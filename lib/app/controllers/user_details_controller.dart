import 'package:shared_preferences/shared_preferences.dart';

mixin userDetailsController {
  static Future<Map<String, dynamic>> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'nama': prefs.getString('nama'),
      'kd_akses': prefs.getString('kd_akses'),
      'token': prefs.getString('token')
    };
  }
}
