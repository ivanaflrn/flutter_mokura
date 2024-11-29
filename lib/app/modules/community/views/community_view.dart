import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/community_controller.dart';
import 'package:mokura/app/routes/app_pages.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey[100],
        title: const Text('Komunitas'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchTopics();
        },
        child: Container(
          // color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: ListView(
              children:[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Topik',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none
                    ),
                    filled: true,
                    // fillColor: Colors.white
                  ),
                ),
                SizedBox(height: 20),
                Obx((){
                  if(controller.isLoading.value){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.topics.length,
                    itemBuilder: (context, index){
                      return ItemsCard(
                        controller.topics[index]['id_topic'].toString(),
                        controller.topics[index]['title'],
                        controller.topics[index]['text'],
                        controller.topics[index]['user']['username']
                      );
                    }
                  );
                }),
              ]
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn_add_topic",
        onPressed: () {
          Get.toNamed(Routes.ADD_TOPIC);
        },
        child: Icon(Icons.add),
      )
    );
  }


}

class ItemsCard extends StatelessWidget {
  ItemsCard(this.id, this.title, this.subtitle, this.username);

  String id;
  String title;
  String subtitle;
  String username;

  @override
  Widget build(BuildContext context) {
    return Card(
      // surfaceTintColor: Theme.of(context).colorScheme.onSurfaceVariant,
      color: Theme.of(context).colorScheme.onSecondary,
      child: ListTile(
        title: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Container(
                child: Text(subtitle,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )
            ),
            SizedBox(height: 10),
            Text(username, textAlign: TextAlign.left, style: TextStyle(fontSize: 12)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Get.toNamed(Routes.TOPIC_DETAILS, arguments: {
            'id': id,
          });
        },
      ),
    );
  }
}
