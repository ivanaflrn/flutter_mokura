import 'package:get/get.dart';

import '../controllers/gedung_ramah_controller.dart';

class GedungRamahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GedungRamahController>(
      () => GedungRamahController(),
    );
  }
}
