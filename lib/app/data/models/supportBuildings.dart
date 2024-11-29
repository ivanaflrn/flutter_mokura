class SupportBuilding{
  String id;
  String title;
  String desc;
  String thumbnail;

  SupportBuilding({required this.id, required this.title, required this.desc, required this.thumbnail});

  factory SupportBuilding.fromMapDio(Map<String, dynamic> map) {
    return SupportBuilding(
        id: map['_id'],
        title: map['title'],
        desc: map['desc'],
        thumbnail: map['thumbnail']
    );
  }
}