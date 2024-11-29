import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/gedungramah_details_controller.dart';

class GedungramahDetailsView extends GetView<GedungramahDetailsController> {
  const GedungramahDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gedung Ramah'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webViewController),
          Obx(() => controller.progress.value < 100 ? Container(width: MediaQuery.of(context).size.width * 1, child: LinearProgressIndicator(value: controller.progress.value.toDouble())) : Container()),
        ],
      ),
      // controller.progress.value < 100 ? CircularProgressIndicator() : WebViewWidget(controller: controller.webViewController),
    );
  }
}
