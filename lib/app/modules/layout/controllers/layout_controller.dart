import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:mokura/app/modules/community/views/community_view.dart';
import 'package:mokura/app/modules/history/views/history_view.dart';
import 'package:mokura/app/modules/home/views/home_view.dart';
import 'package:mokura/app/modules/profile/views/profile_view.dart';

import '../../../../firebase_options.dart';
import '../../../../services/notification_service.dart';


class LayoutController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  final screens = [const HomeView(), const CommunityView(), const HistoryView(), const ProfileView()];
  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Get.putAsync(() => NotificationService().init());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
