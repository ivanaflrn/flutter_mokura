import 'package:get/get.dart';

import '../controllers/add_topic_controller.dart';

class AddTopicBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddTopicController());
  }
}
