import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../services/dio_service.dart';
import 'package:dio/dio.dart' as dio_client;

import '../../../../services/image_compress.dart';

class TopicDetailsController extends GetxController {
  TextEditingController reply = TextEditingController();
  RxList images = [].obs;
  Rx<XFile?> image = Rx<XFile?>(null);
  final scrollController = ScrollController();

  RxString id = ''.obs;
  RxMap topic = {}.obs;
  RxList replies = [].obs;
  RxBool isLoading = false.obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("parameter: ${Get.arguments.toString()}");
    id.value = Get.arguments['id'];
    fetchTopics();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> attachCamera() async{
    XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
    image.value = file;
  }

  Future<void> attachGallery() async{
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    image.value = file;
  }

  Future<void> send(BuildContext context) async{
    isLoading.toggle();
    try {
      XFile? compressedFile;
      if (image.value != null) {
        compressedFile = await ImageCompressionService().compressImage(image.value!);
      }
      var formData = dio_client.FormData.fromMap({
        "text": reply.text,
        "image": image.value != null
            ? dio_client.MultipartFile.fromFileSync(compressedFile!.path, filename: compressedFile.path.split('/').last)
            : dio_client.MultipartFile.fromBytes([], filename: '')
      });


      var result = await DioClient.instance.post("/topics/${id.value}/reply",
          data: formData,
          options: Options(
              headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
          ));
      Get.snackbar("Success", "Balasan berhasil dikirim");
      onInit();
      image.value = null;
    }catch(e){
      Get.snackbar("Oops!", "Balasan gagal dikirim");
      print(e.toString());
    }
    isLoading.toggle();
    FocusScope.of(context).unfocus();
    scrollToBottom();
  }

  void increment() => count.value++;

  Future<void> fetchTopics() async {
    topic.clear();
    isLoading.toggle();
    try {
      var result = await DioClient.instance.get("/topics/${id.value}",
          options: Options(
              headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
          )
      );
      topic.assignAll(result["data"]["topic"]);
      images.clear();
      images.add(result["data"]["topic"]["image"]);
      replies.assignAll(result["data"]["replies"]);
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading.toggle();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
