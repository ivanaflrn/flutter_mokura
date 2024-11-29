import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mokura/app/routes/app_pages.dart';
import 'package:mokura/services/dio_service.dart';

class RegisterController extends GetxController {
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController emergencyContact = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  RxString emailChange = "".obs;
  RxBool emailUnique = true.obs;

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  //TODO: Implement RegisterController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    debounce(emailChange, (callback) => validateUniqueEmail(), time: Duration(milliseconds: 500));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> validateUniqueEmail() async{
    try{
      var result = await DioClient.instance.post("/auth/is-exist", data: {
        "key": email.text,
      });
      emailUnique.value = result["data"];
      // debugPrint(result["data"].toString());
    }catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> register() async{
    isLoading.toggle();
    if(password.text != confirmPassword.text){
      Get.snackbar("Oops !", "Password tidak sama", snackPosition: SnackPosition.BOTTOM);
      isLoading.toggle();
      return;
    }
    try{
      var result = await DioClient.instance.post("/auth/register", data: {
        "full_name": fullName.text,
        "email": email.text,
        "password": password.text,
        "emergency_contact": emergencyContact.text,
        "phone": phoneNumber.text,
      });
      if(result["message"]=="User Created"){
        Get.offAllNamed(Routes.LOGIN_PAGE);
        Get.snackbar("Daftar Berhasil", "Silahkan login dengan akun anda!", snackPosition: SnackPosition.TOP);
      }else{
        Get.snackbar("Oops !", "Ada Error", snackPosition: SnackPosition.TOP);
        debugPrint(result.toString());
      }
    }catch(e){
      debugPrint(e.toString());
      Get.snackbar("Oops !", "Ada Error", snackPosition: SnackPosition.TOP);
    }
    isLoading.toggle();
  }

  void increment() => count.value++;
}
