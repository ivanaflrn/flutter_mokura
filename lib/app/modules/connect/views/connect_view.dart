import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../routes/app_pages.dart';
import '../controllers/connect_controller.dart';

class ConnectView extends GetView<ConnectController> {
  const ConnectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: QRView(
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                  cutOutBottomOffset: 100
                ),
                key: controller.qrKey,
                onQRViewCreated: (QRViewController QRcontroller) {
                  QRcontroller.scannedDataStream.listen((scanData) {
                    controller.startScan(scanData.code.toString());
                  });
                },
              ),
            ),
            Positioned(
              bottom: 60,
              left: 50,
              right: 50,
              child:Obx(() => FilledButton(
                onPressed: () {

                },
                child: controller.qrText.value.isEmpty ?
                Text("Scanning...") :
                Text("Connecting to ${controller.qrText.value}"),
              ))
            ),
          ],
        ),
      ),
    );
  }
}
