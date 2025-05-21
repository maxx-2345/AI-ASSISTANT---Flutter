import 'package:ai_assistant/widget/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialog {
  //Info
  static void info(String msg) {
    Get.snackbar(
      'Info',
      msg,
      backgroundColor: Color.fromRGBO(33, 150, 243, 0.5),
      duration: Duration(seconds: 2),
    );
  }

  //success
  static void success(String msg) {
    Get.snackbar(
      'Success',
      msg,
      backgroundColor: Color.fromRGBO(33, 243, 33, .5),
      duration: Duration(seconds: 2),
    );
  }

  //error
  static void error(String msg) {
    Get.snackbar(
      'Error',
      msg,
      backgroundColor: Color.fromRGBO(243, 33, 33, .5),
      duration: Duration(seconds: 2),
    );
  }

  //Loading dialog
  static void showLoadingDialog() {
    Get.dialog(const Center(child: CustomLoading()));
  }
}
