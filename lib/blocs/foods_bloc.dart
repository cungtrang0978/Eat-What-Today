import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/events/foods_event.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/states/foods_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodsBloc extends Bloc<FoodsEvent, FoodsState> {
  final FoodRepository foodRepository;

  FoodsBloc({@required this.foodRepository})
      : assert(foodRepository != null),
        super(FoodsStateInitial());

  @override
  Stream<FoodsState> mapEventToState(FoodsEvent foodsEvent) async* {
    if (foodsEvent is FoodsEventRequested) {
      yield FoodsStateLoading();
      try {
        final List<Food> foods = await foodRepository.getFoods();
        yield FoodsStateSuccess(foods: foods);
      } catch (exception) {
        yield FoodsStateFailure();
      }
    }else if( foodsEvent is FoodsEventRefreshed){
      try {
        final List<Food> foods = await foodRepository.getFoods();
        yield FoodsStateSuccess(foods: foods);
      } catch (exception) {
        yield FoodsStateFailure();
      }
    }
  }
}
