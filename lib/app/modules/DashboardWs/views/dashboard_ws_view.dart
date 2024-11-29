import 'package:animated_battery_gauge/animated_battery_gauge.dart';
import 'package:animated_battery_gauge/battery_gauge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controllers/dashboard_ws_controller.dart';

class DashboardWsView extends GetView<DashboardWsController> {
  const DashboardWsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardWsView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Obx(() =>
                SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                          minimum: 0,
                          maximum: 45,
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 45,
                                color: Colors.blueAccent,
                                startWidth: 3,
                                endWidth: 3),

                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                                value: controller.speed.value.toDouble(),
                              enableAnimation: true,
                              animationType: AnimationType.ease,
                              animationDuration: 1000,
                            )
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Text('${controller.speed.value} km/h',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                angle: 90,
                                positionFactor: 0.5)
                          ]
                      )
                    ]
                ),
            )
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: AnimatedBatteryGauge(
              duration: const Duration(seconds: 2),
              value: controller.battery.value.toDouble(),
              size: const Size(150, 80),
              borderColor: Colors.blueAccent,
              valueColor: CupertinoColors.activeGreen,
              mode: BatteryGaugePaintMode.grid,
              hasText: true,
            ),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() =>
                  FilledButton(
                      onPressed: () {
                        if(!controller.exitButtonProcess.value){
                          controller.close();
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(100, 40)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: controller.exitButtonProcess.value ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                      ) : const Text("Exit")
                  )
              ),
              SizedBox(width: 10,),
              FilledButton(
                  onPressed: (){},
                  child: Text("Emergency"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      minimumSize: MaterialStateProperty.all(Size(100, 40)),
                    shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),

                  )
              )
            ],
          )
        ],
      ),
    );
  }
}
