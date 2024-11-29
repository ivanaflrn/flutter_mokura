import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey[200],
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        width: double.infinity,
        // color: Colors.grey[200],
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://cdn1.iconfinder.com/data/icons/website-internet/48/website_-_male_user-512.png"),
                    fit: BoxFit.cover
                ),
                // color: Colors.transparent,
                borderRadius: BorderRadius.circular(60)
              ),
            ),
            SizedBox(height: 10),
            Align(alignment: Alignment.centerLeft, child: Text("Name", style: TextStyle(fontSize: 18))),
            Align(alignment: Alignment.centerLeft, child: Text("${GetStorage().read("fullname")}", style: TextStyle(fontSize: 24))),
            SizedBox(height: 30,),
            Align(alignment: Alignment.centerLeft, child: Text("Email", style: TextStyle(fontSize: 18))),
            Align(alignment: Alignment.centerLeft, child: Text("${GetStorage().read("email")}", style: TextStyle(fontSize: 24))),
            SizedBox(height: 30,),
            Container(
                width: double.infinity,
                child: FilledButton(onPressed: () => controller.logout(), child: Text("Logout"))
            ),
          ],
        ),
      )
    );
  }
}
