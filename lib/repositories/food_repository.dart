import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_eat_what_today/models/food.dart';

class FoodRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  String userId;

  // FoodRepository({@required this.userId}) : assert(userId != null);
  FoodRepository();

  Future<void> insertFood(Food food) async {
    final foodRef = firebaseFirestore.collection('foods');
    foodRef
        .doc("1231456")
        .set({"fid": "123", "food": "ga` kho hot vit", "imageUrl": "noimage"});
  }

  Future<void> getFood() async {
    print("getfood");
    final foodRef = firebaseFirestore.collection('foods');
    DocumentSnapshot foodSnapshot = await foodRef.doc('adad').get();
    final food = Food.fromJson(foodSnapshot.data());
    print(food);
  }
}
