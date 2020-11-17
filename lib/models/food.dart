import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String fid;
  String name;
  String imageUrl;
  DateTime createdAt;
  DateTime modifiedAt;
  String createdBy;

  Food(
      {this.fid,
      this.name,
      this.imageUrl,
      this.createdAt,
      this.modifiedAt,
      this.createdBy});

  @override
  String toString() {
    return 'Food{fid: $fid, name: $name, imageUrl: $imageUrl, createdAt: $createdAt, modifiedAt: $modifiedAt, createdBy: $createdBy}';
  }



  Food.fromJson(Map<String, dynamic> json){
    name = json['name']??'';
    imageUrl = json['imageUrl']??'';
    createdAt = convertFromTimestamp(json['createdAt'])?? DateTime.now();
    modifiedAt = json['modifiedAt']??null;
    createdBy = json['createdBy']??'';

  }

  DateTime convertFromTimestamp(Timestamp timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(
        timestamp.microsecondsSinceEpoch);
  }
}
