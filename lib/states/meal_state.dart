import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/models/meal.dart';

abstract class MealState extends Equatable {
  const MealState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MealStateInitial extends MealState {}

class MealStateLoading extends MealState {}

class MealStateSuccess extends MealState {
  final List<Meal> meals;

  MealStateSuccess({@required this.meals}): assert(meals!=null);

  @override
  // TODO: implement props
  List<Object> get props => [meals];
}

class MealStateFailure extends MealState {}
