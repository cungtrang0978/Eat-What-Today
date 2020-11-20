import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String mid; //meal id
  String fid; //food id
  DateTime createdAt;
  DateTime modifiedAt;
  String createdBy;
  DateTime eatenAt;
  MealType mealType;
  List<String> eatenBys;

  Meal(
      {this.mid,
      this.fid,
      this.createdAt,
      this.modifiedAt,
      this.createdBy,
      this.eatenAt,
      this.mealType,
      this.eatenBys});

  Meal.fromJson(Map<String, dynamic> json) {
    fid = json['fid'];
    createdAt = json['createdAt'] == null
        ? null
        : convertFromTimestamp(json['createdAt']);
    modifiedAt = json['modifiedAt'] == null
        ? null
        : convertFromTimestamp(json['modifiedAt']);
    mealType = json['mealType'] == 'breakfast'
        ? MealType.breakfast
        : json['mealType'] == 'lunch'
            ? MealType.lunch
            : json['mealType'] == 'dinner' ? MealType.dinner : MealType.other;
    eatenAt =
        json['eatenAt'] == null ? null : convertFromTimestamp(json['eatenAt']);
    createdBy = json['createdBy'];
    eatenBys = json['eatenBy'] as List;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fid'] = this.fid;
    data['createdAt'] =
        this.createdAt == null ? null : Timestamp.fromDate(this.createdAt);
    data['modifiedAt'] =
        this.modifiedAt == null ? null : Timestamp.fromDate(this.modifiedAt);
    data['createdBy'] = this.createdBy;
    data['eatenAt'] =
        this.eatenAt == null ? null : Timestamp.fromDate(this.eatenAt);
    switch (this.mealType) {
      case MealType.breakfast:
        data['mealType'] = 'breakfast';
        break;
      case MealType.lunch:
        data['mealType'] = 'lunch';
        break;
      case MealType.dinner:
        data['mealType'] = 'dinner';
        break;
      case MealType.other:
        data['mealType'] = 'other';
        break;
    }

    data['eatenBy'] = this.eatenBys;
    return data;
  }

  @override
  String toString() {
    return 'Meal{id: $mid, foodId: $fid, createdAt: $createdAt, modifiedAt: $modifiedAt, mealType: $mealType}';
  }
}

enum MealType { breakfast, lunch, dinner, other }

DateTime convertFromTimestamp(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}
