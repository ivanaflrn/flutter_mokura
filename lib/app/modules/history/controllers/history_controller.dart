import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mokura/services/dio_service.dart';

class HistoryController extends GetxController {
  RxList histories = [].obs;
  RxBool isLoading = false.obs;

  final count = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchHistories();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchHistories() async {
    isLoading.toggle();
    histories.clear();
    print("call history");
    try {
      var result = await DioClient.instance.get("/histories",
        queryParameters: {"id_user": GetStorage().read("user_id")},
        options: Options(
          headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
        )
      );
      histories.assignAll(result["data"]);
    } catch (e) {
      print(e.toString());
    }
    isLoading.toggle();
  }

  void increment() => count.value++;
}
