import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/models/meal.dart';

abstract class MealAdditionState extends Equatable {
  @override
  List<Object> get props => [];
}

class MealAdditionStateInitial extends MealAdditionState {}

class MealAdditionStateChanging extends MealAdditionState {
  final List<Food> foods;

  MealAdditionStateChanging({this.foods});

  @override
  List<Object> get props => [foods];
}

class MealAdditionStateChangingFailure extends MealAdditionState {}

class MealAdditionStateLoading extends MealAdditionState {}

class MealAdditionStateSuccess extends MealAdditionState {}

class MealAdditionStateFailure extends MealAdditionState {}
