class ChargingStation{
  String id;
  String title;
  String desc;
  String thumbnail;

  ChargingStation({required this.id, required this.title, required this.desc, required this.thumbnail});

  factory ChargingStation.fromMapDio(Map<String, dynamic> map) {
    return ChargingStation(
        id: map['_id'],
        title: map['title'],
        desc: map['desc'],
        thumbnail: map['thumbnail']
    );
  }
}