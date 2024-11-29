import 'package:get/get.dart';
import 'package:mokura/app/modules/community/controllers/community_controller.dart';
import 'package:mokura/app/modules/history/controllers/history_controller.dart';
import 'package:mokura/app/modules/home/controllers/home_controller.dart';
import 'package:mokura/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/layout_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutController>(() => LayoutController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.put(CommunityController());
    Get.put(HistoryController());
  }
}