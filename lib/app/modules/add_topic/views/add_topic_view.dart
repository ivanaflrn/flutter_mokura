import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_topic_controller.dart';

class AddTopicView extends GetView<AddTopicController> {
  const AddTopicView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Topic'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.topicTitle,
              onTapOutside: (PointerDownEvent e) {
                FocusScope.of(context).unfocus();
              },
              autofocus: true,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Judul",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: controller.topicText,
              maxLines: 7,
              minLines: 1,
              onTapOutside: (PointerDownEvent e) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Text",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      controller.pickGallery();
                    },
                    icon: Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      controller.pickCamera();
                    },
                    icon: Icon(Icons.camera_alt)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() => controller.images.value == null
                ? SizedBox()
                : Container(
                    height: 200,
                    width: double.maxFinite,
                    child: Image.file(
                      File(controller.images.value!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.maxFinite,
              child: FilledButton(
                onPressed: () {
                  controller.send();
                },
                child: Obx(() => controller.isLoading.value ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ) : Text("Post Topic")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
