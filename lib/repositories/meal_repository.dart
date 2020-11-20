import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/models/meal.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';

class MealRepository {
  final CollectionReference mealsRef =
      FirebaseFirestore.instance.collection('meals');

  final UserRepository userRepository;

  MealRepository({@required this.userRepository})
      : assert(userRepository != null);

  Future<void> insertMeal(Meal meal) async {
    final user = await userRepository.getUser();
    meal.createdBy = user.uid;
    meal.createdAt = DateTime.now();
    if(meal.eatenBys==null){
      meal.eatenBys = List<String>();
      meal.eatenBys.add(user.uid);
    }
    await mealsRef.add(meal.toJson());
  }

  Future<List<Meal>> getMeals()async{
    List<Meal> meals = List<Meal>();
    QuerySnapshot querySnapshot = await mealsRef.get();
    querySnapshot.docs.forEach((mealDoc) {
      Meal meal = Meal.fromJson(mealDoc.data());
      meal.mid = mealDoc.id;
      meals.add(meal);
    });
    return meals;
  }
}
