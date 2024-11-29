import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mokura/app/routes/app_pages.dart';
import 'package:mokura/services/dio_service.dart';


class LoginPageController extends GetxController {
  //TODO: Implement LoginPageController
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  RxBool isHidden = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> login() async {
    isLoading.toggle();
    try{
      var result = await DioClient.instance.post("/auth/login", data: {
        "email": email.text,
        "password": password.text
      });
      GetStorage().write("token", result["data"]["token"]);
      GetStorage().write("user_id", result["data"]["user_id"]);
      GetStorage().write("username", result["data"]["username"]);
      GetStorage().write("fullname", result["data"]["fullname"]);
      GetStorage().write("email", result["data"]["email"]);
      GetStorage().write("emergency_contact", result["data"]["emergency_contact"]);
      GetStorage().write("isLoggedIn", true);
      Get.offAllNamed(Routes.LAYOUT);
      debugPrint(result.toString());

    }catch(e){
      debugPrint(e.toString());
      Get.snackbar("Oops !", "Username atau Password salah !",
          snackPosition: SnackPosition.TOP);
    }
    isLoading.toggle();

    // try {
    //   var result = await DioClient.instance.get("devices/get",
    //       options: Options(
    //         headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
    //       )
    //   );
    //   debugPrint(result.toString());
    // } catch (e) {
    //   debugPrint(e.toString());
    // }

  }
}
