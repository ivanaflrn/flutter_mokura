import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Selamat Datang!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),),
              Text("Silahkan login terlebih dahulu", style: TextStyle( fontSize: 18),),
              SizedBox(height: 30,),
              TextField(
                controller: controller.email,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder()
                ),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() => TextField(
                obscureText: controller.isHidden.value,
                controller: controller.password,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: ()=> controller.isHidden.toggle(),
                    icon: controller.isHidden.value ? Icon(Icons.remove_red_eye_outlined) : Icon(Icons.remove_red_eye),),
                  labelText: "Password",
                    border: OutlineInputBorder()
                ),
              ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(() => Container(
                width: double.maxFinite,
                child: FilledButton(
                  onPressed: () => controller.login(),
                  child:  controller.isLoading.value ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                  ) : Text("Login"),
                ),
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Tidak punya akun? "),
                    InkWell(
                      onTap: (){
                        Get.offAllNamed("/register");
                      },
                      child: Text("Daftar", style: TextStyle(color: Colors.blue),),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
