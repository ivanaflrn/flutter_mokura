import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart' as flutter_barcode;

class ConnectController extends GetxController {
  // final _ble = FlutterReactiveBle();
  // StreamSubscription<DiscoveredDevice>? _scanSub;
  // StreamSubscription<ConnectionStateUpdate>? _connectSub;
  final count = 0.obs;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  RxString qrText = ''.obs;
  RxBool isConnected = false.obs;

  BluetoothConnection? connection;

  @override
  void onInit() async {
    super.onInit();
    qrText.value = '';

  }

  @override
  void onReady() {
    super.onReady();
    // debugPrint('ConnectController onInit');
  }

  void startScan(String code) {
    debugPrint('Scanning for $code');
    qrText.value = code;
    // connectBlutut(code);
    Get.offAllNamed('/dashboard', arguments: {'address': code});
  }

  void connectBlutut(String address) async{
    try{
      connection = await BluetoothConnection.toAddress(address);
      print("Bluetooth connected");
      connection?.input?.listen((Uint8List data) {
        print("data incoming: ${ascii.decode(data)}");
      }).onDone(() {
        print("Connection is closed");
      });
    }catch(e){
      print(e);
    }
  }

  // void _onScanUpdate(DiscoveredDevice device) {
  //   if(qrText.value.isEmpty) _scanSub?.cancel();
  //   debugPrint(device.toString());
  //   print(device.name);
  //   if (device.name == qrText.value) {
  //     debugPrint('Device name: ${device.name}');
  //     _connectSub = _ble.connectToDevice(id: device.id).listen((connection) {
  //       if(connection.connectionState == DeviceConnectionState.connected) {
  //         debugPrint('Connected to {device.name}');
  //         Get.offAllNamed('/dashboard');
  //         Get.snackbar("Scanned", "Connected to ${device.name}");
  //       }
  //     });
  //     _scanSub?.cancel();
  //   }
  // }

  @override
  void onClose() {
    super.onClose();
    connection?.finish();
    // _scanSub?.cancel();
  }

  Future<void> startBarcodeScanStream() async {
    try {
      flutter_barcode.FlutterBarcodeScanner.getBarcodeStreamReceiver(
              "#ff6666", "Cancel", true, flutter_barcode.ScanMode.QR)!
          .listen((barcode) {
        debugPrint(barcode);
      });
    } catch (e) {
      print(e);
    }
  }

  void increment() => count.value++;
}
