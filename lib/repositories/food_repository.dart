import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';

class FoodRepository {
  final CollectionReference foodsRef =
      FirebaseFirestore.instance.collection('foods');

  final UserRepository userRepository;

  FoodRepository({@required this.userRepository})
      : assert(userRepository != null);

  Future<void> insertFood(Food food) async {
    final user = await userRepository.getUser();
    food.createdBy = user.uid;
    foodsRef.add(food.toJson());
  }

  Future<Food> getFood(String fid) async {
    DocumentSnapshot foodSnapshot = await foodsRef.doc(fid).get();
    final food = Food.fromJson(foodSnapshot.data());
    food.fid = foodSnapshot.id;
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

  Future<List<Food>> getFoodsByName(String name) async {
    List<Food> foods = List<Food>();
    foodsRef.where('name', arrayContains: name).get().then((querySnapshot) {
      querySnapshot.docs.forEach((foodDoc) {
        Food food = Food.fromJson(foodDoc.data());
        food.fid = foodDoc.id;
        foods.add(food);
      });
    });
    return foods;
  }
}
