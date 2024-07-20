import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hris/app/config/api.dart';
import 'package:hris/app/controllers/user_details_controller.dart';
import 'package:http/http.dart' as http;

class ApprovalCutiController extends GetxController {
  RxList<Map<String, dynamic>> approveList = <Map<String, dynamic>>[].obs;
  bool _isFetching = false;

  Future<void> listApproveCuti() async {
    if (_isFetching) return;

    _isFetching = true;

    try {
      Map<String, dynamic> userData =
          await userDetailsController.getUserDetails();
      final userDetails = userData;

      //   Headers
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
      String url = Api.listApproveCuti;
      final jsonBody = jsonEncode(body);
      final response =
          await http.post(Uri.parse(url), headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (kDebugMode) {
          if (kDebugMode) {
            print(responseData);
          }
        }
        if (responseData.containsKey('data') && responseData['data'] is List) {
          List<dynamic> data = responseData['data'];
          List<String> total = responseData['total'];
          if (data.isNotEmpty) {
            approveList.value = List<Map<String, dynamic>>.from(data);
          } else {
            approveList.value = List<Map<String, dynamic>>.from(total);
            if (kDebugMode) {
              print("Error: Received empty data list");
            }
          }
        } else {
          if (kDebugMode) {
            print("Error: Invalid data format");
          }
        }
      } else {
        if (kDebugMode) {
          print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        }
        if (kDebugMode) {
          print("Response Body: ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    } finally {
      _isFetching = false;
    }
  }
}
