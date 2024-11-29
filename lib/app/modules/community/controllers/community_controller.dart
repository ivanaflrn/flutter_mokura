import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mokura/services/dio_service.dart';

class CommunityController extends GetxController {
  //TODO: Implement CommunityController

  RxList topics = [].obs;
  RxBool isLoading = false.obs;

  final count = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchTopics();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchTopics() async {
    topics.clear();
    isLoading.toggle();
    try {
      var result = await DioClient.instance.get("/topics",
          options: Options(
            headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
          )
      );
      topics.assignAll(result["data"]);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading.toggle();
  }

  void increment() => count.value++;
}
