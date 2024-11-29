import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/layout_controller.dart';

class LayoutView extends GetView<LayoutController> {
  const LayoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: controller.screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            // unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            type: BottomNavigationBarType.fixed,
            onTap: controller.changeTabIndex,
            elevation: 100,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: "Beranda"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.chat), label: "Komunitas"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: "Riwayat"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profil"),
            ],
          ),
        ));
  }
}
