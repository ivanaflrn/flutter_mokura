import 'package:get/get.dart';

import '../controllers/dashboard_ws_controller.dart';

class DashboardWsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardWsController>(
      () => DashboardWsController(),
    );
  }
}
