import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/app/controllers/user_details_controller.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;


  TextEditingController kdAksesC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController emailC= TextEditingController(text: "email c");
  TextEditingController noTelpC = TextEditingController();
  TextEditingController namaPegawaiC = TextEditingController();


  Future<void> updatePegawai() async {
    Map<String, dynamic> userData = await userDetailsController.getUserDetails();


  }
}
