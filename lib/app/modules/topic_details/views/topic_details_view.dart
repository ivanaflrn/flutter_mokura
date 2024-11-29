import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../controllers/topic_details_controller.dart';

class TopicDetailsView extends GetView<TopicDetailsController> {
  const TopicDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topik'),
        centerTitle: true,  
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(
              controller: controller.scrollController,
              children: [
                // main topic
                Container(
                  padding: const EdgeInsets.only(top:20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                image: NetworkImage('https://picsum.photos/200/300'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Obx((){
                            if(controller.isLoading.value){
                              return const SizedBox();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(controller.topic.value["user"]["username"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                Text(DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(controller.topic.value["created_at"].toString()))),
                              ],
                            );
                          }),
                        ]
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 10, bottom: 0),
                        alignment: Alignment.bottomLeft,
                          child: Obx((){
                            if(controller.isLoading.value){
                              return const Center(child: CircularProgressIndicator());
                            }
                            return Text(controller.topic.value["title"], textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),);
                          }),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Obx((){
                          if(controller.isLoading.value){
                            return const SizedBox();
                          }else{
                            return Text(controller.topic.value["text"]);
                          }
                        })
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Obx((){
                          if(controller.isLoading.value){
                            return const SizedBox();
                          }
                          if(controller.images.value[0] != null){
                            return Image.network(controller.images.value[0], loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            });
                          }
                          return const SizedBox();

                        }),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                // replies
                Obx(() {
                  if(controller.isLoading.value){
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: [
                      for(var item in controller.replies)
                        ReplyCard(item["user"]["username"], item["text"], item["image"] != null ? item["image"] : "", item["created_at"])
                    ],
                  );
                }),
                SizedBox(height: 100,),
              ],
            ),
            Positioned(
              bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    border: Border(top: BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant, width: 1))
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Obx((){
                              if(controller.image.value != null){
                                return Container(
                                  color: Colors.cyanAccent,
                                  width: 140,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.file(File(controller.image.value!.path), height: 100,),
                                      IconButton(
                                          onPressed: (){
                                            controller.image.value = null;
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox();
                            }),
                            TextField(
                              controller: controller.reply,
                              minLines: 1,
                              maxLines: 5,
                              textInputAction: TextInputAction.newline,
                              onTapOutside: (PointerDownEvent e) {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                hintText: 'Balas topik',
                                suffixIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() {
                                      if(controller.image.value == null){
                                        return IconButton(
                                            onPressed: () {
                                              controller.attachGallery();
                                            },
                                            icon: const Icon(Icons.attach_file)
                                        );
                                      }
                                      return const SizedBox();
                                    }),
                                    Obx(() {
                                      if(controller.image.value == null){
                                        return IconButton(
                                            onPressed: () {
                                              controller.attachCamera();
                                            },
                                            icon: const Icon(Icons.camera_alt)
                                        );
                                      }
                                      return const SizedBox();
                                    }),
                                    IconButton(
                                      onPressed: () async {
                                        await controller.send(context);
                                        controller.reply.clear();
                                      },
                                      icon: const Icon(Icons.send)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  ReplyCard(this.username, this.text, this.image, this.datetime);

  String username;
  String text;
  String image;
  String datetime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage('https://picsum.photos/200/300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(datetime))),
                  ],
                ),
              ]
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 50, right: 20),
            child: Text(text),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: image != "" ? Image.network(image) : const SizedBox(),
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}
