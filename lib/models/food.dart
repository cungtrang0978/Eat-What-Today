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

  Food.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
    createdAt = json['created'] == null
        ? null
        : convertFromTimestamp(json['createdAt']);
    modifiedAt = json['modifiedAt'] == null
        ? null
        : convertFromTimestamp(json['modifiedAt']);
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    data['createdAt'] =
        createdAt == null ? null : Timestamp.fromDate(this.createdAt);
    data['modifiedAt'] =
        modifiedAt == null ? null : Timestamp.fromDate(this.modifiedAt);
    data['createdBy'] = this.createdBy;
    return data;
  }

  DateTime convertFromTimestamp(Timestamp timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(
        timestamp.microsecondsSinceEpoch);
  }
}
