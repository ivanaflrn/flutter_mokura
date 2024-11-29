import 'package:get/get.dart';

import '../controllers/topic_details_controller.dart';

class TopicDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopicDetailsController>(
      () => TopicDetailsController(),
    );
  }
}
