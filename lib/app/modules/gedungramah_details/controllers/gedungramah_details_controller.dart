import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GedungramahDetailsController extends GetxController {
  //TODO: Implement GedungramahDetailsController
  RxString id = ''.obs;
  RxInt progress = 0.obs;
  WebViewController webViewController = WebViewController();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    id.value = Get.arguments['id'];
    debugPrint("parameter: ${Get.arguments.toString()}");
    webViewController.loadRequest(
      Uri.parse("https://flying-crowd-f7e.notion.site/UKDW-f6f1e1fd0d564b89b6ada1ee5136e583?pvs=4"),
    );
    webViewController
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          this.progress.value = progress;
        },
      )
    );
  }

  Future<void> initWeb() async{
    webViewController.loadRequest(
      Uri.parse("https://flying-crowd-f7e.notion.site/UKDW-f6f1e1fd0d564b89b6ada1ee5136e583?pvs=4"),
    );
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              this.progress.value = progress;
              debugPrint("progress: $progress");
            },
          )
      );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
