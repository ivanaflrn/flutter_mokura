import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await GetStorage.init();
  runApp(
    FutureBuilder(
      future: GetStorage.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }else{
          return GetMaterialApp(
            title: "Application",
            initialRoute: GetStorage().read("isLoggedIn") != null ? Routes.LAYOUT : Routes.LOGIN_PAGE,
            getPages: AppPages.routes,
            // theme: ThemeData.light(
            //     useMaterial3: true,
            // ),
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: const Color(0xff2A2E45),
            ),
            // darkTheme: ThemeData(
            //   useMaterial3: true,
            //   brightness: Brightness.dark,
            //   colorSchemeSeed: const Color(0xff2A2E45),
            // ),
            themeMode: ThemeMode.system,
          );
        }
      },
    ),
  );
}
