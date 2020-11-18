import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FoodsEvent extends Equatable {
  const FoodsEvent();
}

class FoodsEventRequested extends FoodsEvent {
  FoodsEventRequested();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FoodsEventRefreshed extends FoodsEvent {
  FoodsEventRefreshed();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
