import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text("Daftar Akun", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, ),),
              const Text("Silahkan isi form untuk membuat akun!", style: TextStyle( fontSize: 18, ),),
              const SizedBox(height: 15),
              TextField(
                controller: controller.fullName,
                decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder()
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.phoneNumber,
                decoration: const InputDecoration(
                    hintText: "Contoh : 081234567891",
                    labelText: "No. Whatsapp",
                    border: OutlineInputBorder()
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.emergencyContact,
                decoration: const InputDecoration(
                    hintText: "Contoh : 081234567891",
                    labelText: "Kontak Darurat",
                    border: OutlineInputBorder()
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() =>
                  TextField(
                    controller: controller.email,
                    onChanged: (value) => controller.emailChange.value = value,
                    decoration: InputDecoration(
                        labelText: "Email",
                        errorText: controller.emailUnique.value ? null : "*Email sudah digunakan" ,
                        border: const OutlineInputBorder()
                    ),
                    textInputAction: TextInputAction.next,
                  )
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => TextField(
                obscureText: controller.isHidden.value,
                controller: controller.password,
                decoration: const InputDecoration(
                  labelText: "Password",
                    border: OutlineInputBorder()
                ),
              ),
              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => TextField(
                obscureText: controller.isHidden.value,
                controller: controller.confirmPassword,
                decoration: InputDecoration(
                    labelText: "Konfirmasi Password",
                    border: OutlineInputBorder()
                ),
              ),
              ),
              Obx(() => CheckboxListTile(
                  title: Text("Tampilkan password", style: TextStyle(fontSize: 14),),
                  value: !controller.isHidden.value,
                  onChanged: (value) => controller.isHidden.toggle(),
                  controlAffinity: ListTileControlAffinity.platform,
                  contentPadding: EdgeInsets.all(0),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Obx(() => Container(
                width: double.maxFinite,
                child: FilledButton(
                  onPressed: () => controller.register(),
                  child:  controller.isLoading.value ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                  ) : Text("Daftar"),
                ),
              )),
              Container(
                width: double.maxFinite,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed("/login-page"),
                  child: Text("Kembali ke Login"),
                ),
              ),
            ],
          ),
        )

      ),
    );
  }
}
