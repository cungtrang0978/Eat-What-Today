import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/events/meal_addition_event.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/models/meal.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/meal_repository.dart';
import 'package:flutter_eat_what_today/states/meal_addition_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealAdditionBloc extends Bloc<MealAdditionEvent, MealAdditionState> {
  MealRepository _mealRepository;
  FoodRepository _foodRepository;

  MealAdditionBloc(
      {@required MealRepository mealRepository, @required FoodRepository foodRepository })
      : assert(mealRepository != null && foodRepository != null),
        _mealRepository = mealRepository,
        _foodRepository = foodRepository,
        super(MealAdditionStateInitial());

  @override
  Stream<MealAdditionState> mapEventToState(
      MealAdditionEvent mealAdditionEvent) async* {
    // TODO: implement mapEventToState

    if (mealAdditionEvent is MealAdditionEventMealChanged) {
      if (mealAdditionEvent.meal.isNotEmpty) {
        List<Food> foods = await _foodRepository.getFoods();
        yield MealAdditionStateChanging(foods: foods);
      } else {
        yield MealAdditionStateChangingFailure();
      }
    }
    else if (mealAdditionEvent is MealAdditionInsertPressed) {
      yield MealAdditionStateLoading();
      if (mealAdditionEvent.meal.isNotEmpty) {
        yield MealAdditionStateSuccess();
      } else {
        yield MealAdditionStateFailure();
      }
    }
  }
}
