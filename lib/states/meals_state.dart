import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/models/meal.dart';

abstract class MealsState extends Equatable {
  const MealsState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MealsStateInitial extends MealsState {}

class MealsStateLoading extends MealsState {}

class MealsStateSuccess extends MealsState {
  final List<Meal> meals;

  MealsStateSuccess({@required this.meals}) : assert(meals != null);
  @override
  // TODO: implement props
  List<Object> get props => [meals];
}

class MealsStateFailure extends MealsState {}
