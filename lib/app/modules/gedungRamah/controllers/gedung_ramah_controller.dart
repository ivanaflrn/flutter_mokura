import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../services/dio_service.dart';
import '../../../data/models/supportBuildings.dart';

class GedungRamahController extends GetxController {
  //TODO: Implement GedungRamahController
  RxList<SupportBuilding> arrSupportBuildings = <SupportBuilding>[].obs;

  final count = 0.obs;
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

  Future<void> fetchData() async {
    arrSupportBuildings.clear();
    try{
      var result = await DioClient.instance.get("app/",
          options: Options(
              headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
          )
      );
      for (var item in result["data"]["support_buildings"] as List) {
        final building = SupportBuilding.fromMapDio(item);
        arrSupportBuildings.add(building);
      }
    }catch(e){
      Get.snackbar("Oops !", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void increment() => count.value++;
}
