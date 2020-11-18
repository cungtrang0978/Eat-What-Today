import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  String id;
  String foodId;
  DateTime createdAt;
  DateTime modifiedAt;
  MealType mealType;

  Meal({this.id, this.foodId, this.createdAt, this.modifiedAt, this.mealType});

  Meal.fromJson(Map<String, dynamic> json) {
    foodId = json['fid'] ?? '';
    createdAt = convertFromTimestamp(json['createdAt']) ?? null;
    modifiedAt = convertFromTimestamp(json['modifiedAt']) ?? null;
    mealType = json['mealType'] == 'breakfast'
        ? MealType.breakfast
        : json['mealType'] == 'lunch' ? MealType.lunch : MealType.dinner;
  }

  @override
  String toString() {
    return 'Meal{id: $id, foodId: $foodId, createdAt: $createdAt, modifiedAt: $modifiedAt, mealType: $mealType}';
  }
}

enum MealType { breakfast, lunch, dinner }

DateTime convertFromTimestamp(Timestamp timestamp) {
  return DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
}
