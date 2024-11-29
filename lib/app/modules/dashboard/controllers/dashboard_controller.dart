import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

import '../../../../services/dio_service.dart';

class DashboardController extends GetxController {
  // Bluetooth variables
  String address = Get.arguments['address'];
  BluetoothConnection? connection;
  RxBool bluetoothConnected = false.obs;

  // WebSocket variables
  WebSocketChannel? ws;
  Rx<DateTime> startTime = DateTime.now().obs;
  Rx<DateTime> endTime = DateTime.now().obs;
  int reconnectTime = 2;
  Timer? sensorUpdateTimer;
  Timer? sendDataTimer;
  // Location variables

  var latitude = "".obs;
  var longitude = "".obs;
  StreamSubscription<Position>? positionStream;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );
  // device variable

  String deviceName = "";
  int deviceId = 0;

  // Sensor data variables
  RxInt rpm = 0.obs;
  RxInt speed = 0.obs;
  RxInt battery = 0.obs;
  RxInt dutyCycle = 0.obs;

  // Temporary sensor values
  double _tempRpm = 0.0;
  double _tempSpeed = 0.0;
  double _tempBattery = 0.0;
  double _tempDutyCycle = 0.0;

  // Status variables
  RxBool isConnected = false.obs;
  RxBool exitButtonProcess = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeBluetooth();
    await _getDeviceDetail();
    await _initializeLocationStream();
    await _connectWs();

    // Timer untuk memperbarui variabel sensor setiap detik
    sensorUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      rpm.value = _tempRpm.toInt();
      speed.value = _tempSpeed.toInt();
      battery.value = _tempBattery.toInt();
      dutyCycle.value = _tempDutyCycle.toInt();
    });
  }

  Future<void> _getDeviceDetail() async {
    try {
      var result = await DioClient.instance.get("/devices/bluetooth",
          queryParameters: {
              "bluetooth_id": address
          },
          options: Options(
              headers: {"Authorization": "Bearer ${GetStorage().read("token")}"}
          )
      );
      deviceName = result["data"]["device_name"];
      deviceId = result["data"]["id_device"];
    } catch (e) {
      print("Error getting device detail: $e");
    }
  }

  Future<void> _initializeBluetooth() async {
      connection = await BluetoothConnection.toAddress(address);
      print("Bluetooth connected");
      if(connection?.isConnected == false){
        // Menampilkan pesan error dan kembali ke halaman layout
        Get.snackbar("Koneksi Bluetooth Gagal", "Tidak dapat terhubung ke perangkat Bluetooth.");

        // Tutup koneksi Bluetooth dan bersihkan instance jika terjadi error
        _closeBluetoothConnection();

        // Kembali ke halaman layout dan reset controller
        Future.delayed(const Duration(seconds: 2), () {
          Get.offAllNamed("/layout");
          Get.delete<DashboardController>(); // Hapus instance controller untuk reset
        });
      }
      if(connection?.isConnected == true){
        bluetoothConnected.value = true;
      }
      connection?.input?.listen((Uint8List data) {
        String decodedData = ascii.decode(data);
        _parseBluetoothData(decodedData);
      }).onDone(() {
        print("Bluetooth connection is closed");
      });
  }

  void _parseBluetoothData(String incomingData) {
    // print('Bluetooth data: $incomingData');
    try {
      List<String> splitData = incomingData.split(';');
      if (splitData.length >= 4) {
        _tempRpm = double.tryParse(splitData[0].substring(1)) ?? 0.0;
        _tempSpeed = double.tryParse(splitData[1]) ?? 0.0;
        _tempBattery = double.tryParse(splitData[2]) ?? 0.0;
        _tempDutyCycle = double.tryParse(splitData[3].replaceAll('#', '')) ?? 0.0;
      } else {
        print("Bluetooth data parsing error: data format is not correct.");
      }
    } catch (e) {
      print("Error parsing Bluetooth data: $e");
    }
  }

  Future<void> _connectWs() async {
    print("connecting ws");
    const url = 'wss://mokura-api.marem.my.id/client?role=device&device_id=2';
    ws = WebSocketChannel.connect(Uri.parse(url));
    startStreamData();
    ws?.stream.listen((event) {
      print("connected");
      print(event);
      isConnected.value = true;
    }, onError: (error){
      print('Error ws: $error');
      Timer(Duration(seconds: reconnectTime), () {
        print('Reconnecting...');
        _connectWs();
      });
    }, onDone: (){

    });
  }

  void startStreamData(){
    print("start stream data");
    sendDataTimer = Timer.periodic(const Duration(seconds: 2), (sendDataTimer) async {

      // // speed.value = rng.nextInt(45);
      // rpm.value = rng.nextInt(50).toString();
      // battery.value = rng.nextInt(100);
      Map data = {
        'user_id': GetStorage().read('user_id'),
        'device_id': deviceId,
        'device_name': deviceName,
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

  void sendData(String data) {
    ws?.sink.add(data);
  }

  Future<void> _initializeLocationStream() async {
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      String lat = position?.latitude.toString() ?? '0';
      String long = position?.longitude.toString() ?? '0';
      latitude.value = lat;
      longitude.value = long;
    });
  }

  // Fungsi untuk menutup koneksi Bluetooth
  void _closeBluetoothConnection() {
    if (connection != null) {
      connection?.finish();
      connection?.close();
      connection = null; // Set connection ke null untuk memastikan koneksi benar-benar ditutup
    }
  }

  @override
  void onClose() {
    sensorUpdateTimer?.cancel();
    sendDataTimer?.cancel();
    ws?.sink.close();
    ws = null;
    positionStream?.cancel();
    _closeBluetoothConnection();
    super.onClose();
  }

  Future<void> close() async {
    exitButtonProcess.value = true;
    ws?.sink.close();
    sensorUpdateTimer?.cancel();
    sendDataTimer?.cancel();
    positionStream?.cancel();
    _closeBluetoothConnection();
    endTime.value = DateTime.now();
    try {
      var result = await DioClient.instance.post("/histories/send-session",
          data: {
            "id_user": GetStorage().read("user_id"),
            "id_device": deviceId,
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
      print("Session data sent successfully: $result");
    } catch (e) {
      print("Error sending session data: $e");
    }
    exitButtonProcess.value = false;
    Get.offAllNamed("/layout");
  }

  Future<void> emergencyCall() async {
    try{
      Map<String, dynamic> queryParameters = {
        "title": "EMERGENCY CALL!",
        "message": "Emergency call from "+GetStorage().read("fullname")+". Please respond immediately.",
        "lat": latitude.toString(),
        "lng": longitude.toString(),
        "user_id": GetStorage().read('user_id'),
        "is_using_mokura": true,
        "device_id": deviceId.toString()
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
}
