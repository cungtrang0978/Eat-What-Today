import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_eat_what_today/models/food.dart';

class FoodRepository {
  final CollectionReference foodsRef =
      FirebaseFirestore.instance.collection('foods');
  String userId;


  // FoodRepository({@required this.userId}) : assert(userId != null);
  FoodRepository();

  Future<void> insertFood(Food food) async {
    foodsRef.add(food.toJson());
  }

  Future<Food> getFood(String fid) async {
    DocumentSnapshot foodSnapshot = await foodsRef.doc(fid).get();
    final food = Food.fromJson(foodSnapshot.data());
    return food;
  }

  Future<List<Food>> getFoods() async {
    List<Food> foods = List<Food>();

    QuerySnapshot querySnapshot = await foodsRef.get();
    querySnapshot.docs.forEach((foodDoc) {
      Food food = Food.fromJson(foodDoc.data());
      food.fid = foodDoc.id;
      foods.add(food);
    });
    return foods;
  }
}
