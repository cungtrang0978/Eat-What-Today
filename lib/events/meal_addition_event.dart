import 'package:equatable/equatable.dart';

abstract class MealAdditionEvent extends Equatable {
  const MealAdditionEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MealAdditionEventMealChanged extends MealAdditionEvent {
  final String meal;

  MealAdditionEventMealChanged({this.meal});

  @override
  // TODO: implement props
  List<Object> get props => [meal];
}

class MealAdditionInsertPressed extends MealAdditionEvent {
  final String meal;

  MealAdditionInsertPressed({this.meal});

  @override
  // TODO: implement props
  List<Object> get props => [meal];
}
