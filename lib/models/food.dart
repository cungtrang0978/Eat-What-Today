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

  Food.fromCollection(value) {
    name = value.get('name') ?? '';
    imageUrl = value.get('imageUrl') ?? '';
    createdAt = convertFromTimestamp(value.get('createdAt')) ?? DateTime.now();
    modifiedAt = value.get('modifiedAt') ?? null;
    createdBy = value.get('createdBy') ?? '';
  }

  DateTime convertFromTimestamp(Timestamp timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(
        timestamp.microsecondsSinceEpoch);
  }
}
