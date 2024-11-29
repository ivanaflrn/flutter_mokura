import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mokura/app/routes/app_pages.dart';



class ProfileController extends GetxController {
  //TODO: Implement ProfileController

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


  void logout() async {
    GetStorage().remove("isLoggedIn");
    // print(GetStorage().read("isLoggedIn").toString());
    Get.offAllNamed(Routes.LOGIN_PAGE);
  }
}
