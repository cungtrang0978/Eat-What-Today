import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/events/meals_event.dart';
import 'package:flutter_eat_what_today/models/meal.dart';
import 'package:flutter_eat_what_today/repositories/meal_repository.dart';
import 'package:flutter_eat_what_today/states/meals_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealRepository mealRepository;

  MealsBloc({@required this.mealRepository})
      : assert(mealRepository != null),
        super(MealsStateInitial());

  @override
  Stream<MealsState> mapEventToState(MealsEvent mealsEvent) async* {
    if (mealsEvent is MealsEventRequested) {
      yield MealsStateLoading();
      try {
        final List<Meal> meals = await mealRepository.getMealsFromUser();
        yield MealsStateSuccess(meals: meals);
      } catch (exception) {
        print(exception.toString());
        yield MealsStateFailure();
      }
    } else if (mealsEvent is MealsEventRefreshed) {
      try {
        final List<Meal> meals = await mealRepository.getMealsFromUser();
        yield MealsStateSuccess(meals: meals);
      } catch (exception) {
        print(exception.toString());
        yield MealsStateFailure();
      }
    }
  }
}
