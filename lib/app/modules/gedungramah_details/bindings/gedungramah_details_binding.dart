import 'package:get/get.dart';

import '../controllers/gedungramah_details_controller.dart';

class GedungramahDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GedungramahDetailsController>(
      () => GedungramahDetailsController(),
    );
  }
}
