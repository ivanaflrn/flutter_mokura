import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        centerTitle: true,
        // backgroundColor: Colors.grey[200],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchHistories();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          // color: Colors.grey[200],
          child: Obx((){
            if(controller.isLoading.value){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return ListView(
                  children:[
                    for(var h in controller.histories)
                      CardHistory(h['device_name'], h['start_date'], h['end_date'], h['duration'])
                  ]
              );
            }
          })
        ),
      )
    );
  }

}

class CardHistory extends StatelessWidget {
  final String device;
  final String start_date;
  final String end_date;
  final String duration;

  const CardHistory(this.device, this.start_date, this.end_date, this.duration, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(device),
          subtitle: Text(start_date+" - "+end_date, style: TextStyle(fontSize: 12)),
          trailing: Text(duration, style: TextStyle(fontSize: 16)),
          onTap: () {},
        ),
      ),
    );
  }
}
