import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/models/food.dart';

abstract class FoodsState extends Equatable{
  const FoodsState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FoodsStateInitial extends FoodsState{}
class FoodsStateLoading extends FoodsState{}
class FoodsStateSuccess extends FoodsState{
  final List<Food> foods;

  FoodsStateSuccess({@required this.foods}): assert(foods!=null);

  @override
  // TODO: implement props
  List<Object> get props => [foods];
}
class FoodsStateFailure extends FoodsState{}