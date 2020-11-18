import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String id;
  String foodId;
  DateTime createdAt;
  DateTime modifiedAt;
  MealType mealType;
  DateTime eatenAt;

  Meal({this.id, this.foodId, this.createdAt, this.modifiedAt, this.mealType});

  Meal.fromJson(Map<String, dynamic> json) {
    foodId = json['fid'] ?? '';
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
  }

  @override
  String toString() {
    return 'Meal{id: $id, foodId: $foodId, createdAt: $createdAt, modifiedAt: $modifiedAt, mealType: $mealType}';
  }
}

enum MealType { breakfast, lunch, dinner, other }

DateTime convertFromTimestamp(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}
