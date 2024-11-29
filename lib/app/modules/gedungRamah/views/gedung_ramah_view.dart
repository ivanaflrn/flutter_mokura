import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mokura/app/routes/app_pages.dart';

import '../controllers/gedung_ramah_controller.dart';

class GedungRamahView extends GetView<GedungRamahController> {
  const GedungRamahView({Key? key}) : super(key: key);
  List<CardItem> _itemList() {
    List<CardItem> list = [];
    for (var item in controller.arrSupportBuildings) {
      list.add(CardItem(item.id, item.title, item.desc, item.thumbnail));
    }
    return list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text('Gedung Ramah Kursi Roda'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: ListView(
              children:[
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Cari',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none
                      ),
                      filled: true,
                      fillColor: Colors.white
                  ),
                ),
                SizedBox(height: 20),
                FutureBuilder(
                    future: controller.fetchData(),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }else{
                        return Column(
                          children: _itemList(),
                        );
                      }

                    })
              ]
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  CardItem(this.id, this.title, this.desc, this.urlImage);

  String title;
  String desc;
  String urlImage;
  String id;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.GEDUNGRAMAH_DETAILS, arguments: {'id': id});
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(urlImage),
                        fit: BoxFit.cover
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(desc, overflow: TextOverflow.ellipsis, maxLines: 3, style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
