import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mokura/services/dio_service.dart';
import 'package:dio/dio.dart' as dio_client;

import '../../../../services/image_compress.dart';
import '../../community/controllers/community_controller.dart';

class AddTopicController extends GetxController {

  final count = 0.obs;
  ImagePicker picker = ImagePicker();
  Rx<XFile?> images = Rx<XFile?>(null);
  RxBool isLoading = false.obs;


  TextEditingController topicTitle = TextEditingController();
  TextEditingController topicText = TextEditingController();

  final communityController = Get.find<CommunityController>();

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

  Future<void> pickGallery() async{
    XFile? pick = await picker.pickImage(source: ImageSource.gallery);
    images.value = pick!;
  }

  Future<void> pickCamera() async{
    XFile? file = await picker.pickImage(source: ImageSource.camera);
    images.value = file!;
  }

  Future<void> send() async{
    isLoading.toggle();

    try {
      XFile? compressedFile;
      if (images.value != null) {
        compressedFile = await ImageCompressionService().compressImage(images.value!);
      }
      var formData = dio_client.FormData.fromMap({
        "title": topicTitle.text,
        "text": topicText.text,
        "file": images.value != null
            ? dio_client.MultipartFile.fromFileSync(compressedFile!.path, filename: compressedFile.path.split('/').last)
            : dio_client.MultipartFile.fromBytes([], filename: '')
      });


      var result = await DioClient.instance.post("/topics",
          data: formData,
          options: Options(
          headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
      ));
      Get.back(closeOverlays: false);
      Get.snackbar("Success", "Topik berhasil ditambahkan");
      communityController.fetchTopics();
    }catch(e){
      Get.snackbar("Oops!", "Topik gagal ditambahkan");
      print(e.toString());
    }
    isLoading.toggle();
  }

}
