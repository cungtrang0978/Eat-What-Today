import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/models/meal.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';

class MealRepository {
  final CollectionReference mealsRef =
      FirebaseFirestore.instance.collection('meals');

  final UserRepository userRepository;
  final FoodRepository foodRepository;

  MealRepository({
    @required this.userRepository,
    @required this.foodRepository,
  }) : assert(userRepository != null && foodRepository != null);

  Future<void> insertMeal(Meal meal) async {
    final user = await userRepository.getUser();
    meal.createdBy = user.uid;
    meal.createdAt = DateTime.now();
    if (meal.eatenBys == null) {
      meal.eatenBys = List<String>();
      meal.eatenBys.add(user.uid);
    }
    await mealsRef.add(meal.toJson());
  }

  Future<List<Meal>> getMealsFromUser() async {
    print("getMealsFromUser");
    List<Meal> meals = List<Meal>();

    final user = await userRepository.getUser();
    QuerySnapshot querySnapshot = await mealsRef
        .where('eatenBy', arrayContains: user.uid)
        // .where('createdBy', whereIn: [user.uid])
        .get();
    querySnapshot.docs.forEach((mealDoc) {
      Meal meal = Meal.fromJson(mealDoc.data());
      meal.mid = mealDoc.id;
      meals.add(meal);
    });
    return meals;
  }

  Future<void> updateMeal(Meal meal) async {
    mealsRef
        .doc(meal.mid)
        .update(meal.toJson())
        .then((value) => print("Meal Updated"))
        .catchError((error) => print("Failed to update meal: $error"));
  }
}
