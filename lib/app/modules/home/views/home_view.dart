import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/home_controller.dart';
import 'package:mokura/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  Future<void> _dialogBuilder(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Tombol Darurat"),
          content: const Text("Apakah anda yakin ingin menekan tombol darurat?"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: (){
                controller.emergencyCall();
                Navigator.of(context).pop();
                _nextActionDialog(context);
              },
              child: const Text("Ya"),
            )],
        );
      });
  }
  Future<void> _nextActionDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Tindakan lebih lanjut"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    await launchUrlString("https://wa.me/6282178760728");
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.only(bottom: 5),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey))
                      ),
                      child: const Text("Hubungi Admin Mokura", style: TextStyle(fontSize: 16))
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await launchUrlString("https://wa.me/"+GetStorage().read("emergency_contact"));
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.only(bottom: 5),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey))
                      ),
                      child: const Text("Hubungi Kontak Darurat", style: TextStyle(fontSize: 16))
                  ),
                ),

              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Text('Mokura'),
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn_emergency",
        onPressed: () {
          _dialogBuilder(context);
        },
        backgroundColor: Colors.red,
        child:const Icon(Icons.warning_amber_rounded, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchHome();
        },
        child: Container(
          // color: Theme.of(context).colorScheme.surface,
          child: Container(
            child: ListView(
              children: [
                // Start Selamat datang
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Column(
                    children: [
                      Align(
                        child: Text(
                          "Hai! Selamat datang,",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Align(
                        child: Text(
                          GetStorage().read("fullname"),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ),
                //   End Selamat datang
        
                //   Start hubungkan ke device
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hubungkan perangkat",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                "Hubungkan aplikasi dengan\nkursi roda",
                              )
                            ],
                          ),
                          FilledButton(
                              onPressed: () {
                                Get.toNamed("/connect");
                              },
                              child: Text("Hubungkan", style: TextStyle(fontSize: 14))
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //   End hunungkan device
        
                // Start Gedung Ramah
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gedung Ramah",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.GEDUNG_RAMAH);
                          },
                          child: Text(
                            "Lihat lainnya",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx((){
                          if(controller.isLoading.value){
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
        
                          return Row(
                            children: [
                              for (var item in controller.arrSupportBuildings)
                                GedungRamahCardComponent(item["name"], item["address"], item["thumbnail"])
                            ],
                          );
                        })
                    ),
                  ),
                ),
                //   End Gedung Ramah
        
                //   Start Stasiun Pengisian Daya
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Stasiun Pengisian Daya",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            "Lihat lainnya",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() {
                      if(controller.isLoading.value){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Row(
                        children: [
                          for (var item in controller.arrChargingStations)
                            StasiunCardComponent(item["name"], item["distance"]+" - "+item["address"], item["thumbnail"], item["url"])
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //   End Stasiun Pengisian Daya
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GedungRamahCardComponent extends StatelessWidget {
  GedungRamahCardComponent(this.title, this.desc, this.urlImage);

  String title;
  String desc;
  String urlImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.GEDUNGRAMAH_DETAILS, arguments: {'id': '1'});
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 180,
        height: 230,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Container(
              width: 180,
              height: 165,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                image: DecorationImage(
                    image: NetworkImage(urlImage), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class StasiunCardComponent extends StatelessWidget {
  final String title;
  final String desc;
  final String urlImage;
  final String maps;

  StasiunCardComponent(this.title, this.desc, this.urlImage, this.maps);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // Open maps URL when tapped
        if (await canLaunchUrlString(maps)) {
          // await launchUrlString(maps);
          await launchUrlString(maps, mode: LaunchMode.externalApplication);
        } else {
          // If the URL can't be launched, show an error message
          Get.snackbar("Error", "Could not open the map link",
              snackPosition: SnackPosition.BOTTOM);
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        width: 180,
        height: 230,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Container(
              width: 180,
              height: 165,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(urlImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}