import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../services/dio_service.dart';
import '../../../data/models/chargingStation.dart';
import '../../../data/models/supportBuildings.dart';
import '../../add_topic/controllers/add_topic_controller.dart';
import '../../layout/controllers/layout_controller.dart';


import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController {

  final layoutController = Get.put(LayoutController());
  final count = 0.obs;

  RxList arrSupportBuildings = [].obs;
  RxList arrChargingStations = [].obs;

  late double latitude;
  late double longitude;

  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    FocusManager.instance.primaryFocus?.unfocus();
    await fetchHome();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Function to get the current location using Geolocator
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // If permissions are granted, return the current position
    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchHome() async {
    isLoading.toggle();
    arrChargingStations.clear();
    arrSupportBuildings.clear();
    try {
      // Get the user's current location
      Position position = await _getCurrentLocation();
      double latitude = position.latitude;
      double longitude = position.longitude;
      this.latitude = position.latitude;
      this.longitude = position.longitude;

      // Fetch support buildings data
      var result = await DioClient.instance.get(
        "/support-buildings",
        options: Options(
            headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
        ),
      );
      for (var item in result["data"]) {
        arrSupportBuildings.add(item);
      }

      // Fetch charging stations data with latitude and longitude as query parameters
      var chargings = await DioClient.instance.get(
        "/charging-stations",
        queryParameters: {
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        },
        options: Options(
            headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
        ),
      );
      for (var item in chargings["data"]) {
        arrChargingStations.add(item);
      }

    } catch (e) {
      debugPrint(e.toString());
      // You can uncomment the snackbar to show the error in the UI
      // Get.snackbar("Oops !", "${e.toString()}", snackPosition: SnackPosition.TOP);
    }
    isLoading.toggle();
  }

  Future<void> emergencyCall() async {
    await _getCurrentLocation();
    try{
      await _getCurrentLocation();
      Map<String, dynamic> queryParameters = {
        "title": "EMERGENCY CALL!",
        "message": "Emergency call from "+GetStorage().read("fullname")+". Please respond immediately.",
        "lat": latitude.toString(),
        "lng": longitude.toString(),
        "user_id": GetStorage().read('user_id'),
        "is_using_mokura": false
      };
      var result = await DioClient.instance.post("/notification/emergency",
          queryParameters: queryParameters,
          options: Options(
              headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
          )
      );
    }catch(e){
      print(e);
    }
  }

  void callAdmin(){

  }

  void increment() => count.value++;
}
