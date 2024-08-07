// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/controllers/user_details_controller.dart';
import 'package:http/http.dart' as http;

class DetailPresensiController extends GetxController {
  bool _isFetching = false;
  RxList<Map<String, dynamic>> historyList = <Map<String, dynamic>>[].obs;

  Future<void> detailPresensi(String kdAkses, String tanggalPresensi) async {
    if (_isFetching) return;

    _isFetching = true;

    try {
      Map<String, dynamic> userData =
          await userDetailsController.getUserDetails();
      final userDetails = userData;

      // Headers
      final Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer ${userDetails["token"]}",
        "Content-Type": "application/json",
      };
      final String kdAkses = userDetails['kd_akses'];

      final Map<String, String> body = {
        "kd_akses": kdAkses,
      };

      // API Request
      String url = Api.detailPresensi;
      final jsonBody = jsonEncode(body);
      final response =
          await http.post(Uri.parse(url), headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          List<dynamic> data = responseData['data'];
          if (data.isNotEmpty) {
            historyList.value = List<Map<String, dynamic>>.from(data);
          } else {
            print("Error: Received empty data list");
          }
        } else {
          print("Error: Invalid data format");
        }
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      _isFetching = false;
    }
  }
}
