import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/state_manager.dart';
import 'package:mokura/services/dio_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:get_storage/get_storage.dart';

class DashboardWsController extends GetxController {
  late WebSocketChannel ws;
  int deviceId = 2;
  Rx<DateTime> startTime = DateTime.now().obs;
  Rx<DateTime> endTime = DateTime.now().obs;
  RxInt speed = 0.obs;
  RxInt battery = 52.obs;
  RxString rpm = '10'.obs;
  RxString latitude = '0'.obs;
  RxString longitude = '0'.obs;
  RxBool isConnected = false.obs;
  int reconnectTime = 3;
  RxBool exitButtonProcess = false.obs;

  late StreamSubscription<Position> positionStream;

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  Timer? timer;

  final count = 0.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    await _connectWs();
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      // do what you want to do with the position here
      String lat = position?.latitude.toString() ?? '0';
      String long = position?.longitude.toString() ?? '0';
      speed.value = (position?.speed ?? 0 * 3.6).toInt();
      latitude.value = lat;
      longitude.value = long;
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
    startStreamData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    ws.sink.close();
    positionStream.cancel();
    super.onClose();
  }

  Future<void> _connectWs() async {
    const url = 'wss://mokura-api.marem.my.id/client?role=device&device_id=2';
    // const url = 'wss://wound-stone-states-unlikely.trycloudflare.com/client?role=device&device_id=2';
    ws = WebSocketChannel.connect(Uri.parse(url));
    ws.stream.listen((event) {
      print("connected");
      print(event);
      isConnected.value = true;
      startStreamData();
    }, onError: (error){
      print('Error ws: $error');
      Timer(Duration(seconds: reconnectTime), () {
        print('Reconnecting...');
        _connectWs();
      });
    }, onDone: (){

    });
  }

  void sendData(String data) {
    ws.sink.add(data);
  }

  void startStreamData(){
    print("start stream data");
    var rng = Random();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) async {

      // speed.value = rng.nextInt(45);
      rpm.value = rng.nextInt(50).toString();
      battery.value = rng.nextInt(100);
      Map data = {
        'user_id': GetStorage().read('user_id'),
        'device_id': deviceId,
        'device_name': 'Mokura 2 Ivana',
        'speed': speed.value,
        'rpm': rpm.value,
        'battery': battery.value,
        'latitude': latitude.value.toString(),
        'longitude': longitude.value.toString(),
        'created_at': DateTime.now().toIso8601String()
      };
      sendData(jsonEncode(data));
    });
  }

  Future<void> close() async {
    exitButtonProcess.value = true;
    ws.sink.close();
    timer?.cancel();
    positionStream.cancel();
    endTime = DateTime.now().obs;
    try{
      var result = await DioClient.instance.post("/histories/send-session",
          data: {
            "id_user": GetStorage().read("user_id"),
            "id_device": 2,
            "duration": endTime.value.difference(startTime.value).inSeconds,
            "start_date": startTime.value.toIso8601String(),
            "end_date": endTime.value.toIso8601String(),
            "distances": 10,
            "latitude": latitude.value,
            "longitude": longitude.value
          },
          options: Options(
              headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
          )
      );
      print(result);
    }catch(e){
      print(e);
    }
    exitButtonProcess.value = false;
    Get.offAllNamed("/layout");
  }

}
