import 'package:animated_battery_gauge/animated_battery_gauge.dart';
import 'package:animated_battery_gauge/battery_gauge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

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
        title: const Text('DashboardView'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Jika bluetoothConnected bernilai false, tampilkan loading indicator
        if (!controller.bluetoothConnected.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Jika bluetoothConnected true, tampilkan tampilan utama
        return Column(
          children: [
            // Gauge untuk kecepatan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Obx(() => SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 45,
                  ranges: <GaugeRange>[
                    GaugeRange(
                      startValue: 0,
                      endValue: 45,
                      color: Colors.blueAccent,
                      startWidth: 3,
                      endWidth: 3,
                    ),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: controller.speed.value.toDouble(),
                      enableAnimation: true,
                      animationType: AnimationType.ease,
                      animationDuration: 1000,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        '${controller.speed.value.toStringAsFixed(1)} km/h',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      angle: 90,
                      positionFactor: 0.5,
                    ),
                  ],
                ),
              ])),
            ),
            // Gauge untuk baterai
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Obx(() => AnimatedBatteryGauge(
                duration: const Duration(seconds: 2),
                value: controller.battery.value.toDouble(),
                size: const Size(150, 80),
                borderColor: Colors.blueAccent,
                valueColor: CupertinoColors.activeGreen,
                mode: BatteryGaugePaintMode.grid,
                hasText: true,
              )),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => FilledButton(
                  onPressed: () {
                    if (!controller.exitButtonProcess.value) {
                      controller.close();
                    }
                  },
                  style: ButtonStyle(
                    minimumSize:
                    MaterialStateProperty.all(const Size(100, 40)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: controller.exitButtonProcess.value
                      ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ))
                      : const Text("Exit"),
                )),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: (){
                    _dialogBuilder(context);
                  },
                  child: const Text("Emergency"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
