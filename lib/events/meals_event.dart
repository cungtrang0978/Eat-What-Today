import 'package:equatable/equatable.dart';

abstract class MealsEvent extends Equatable {
  const MealsEvent();
}

class MealsEventRequested extends MealsEvent {
  MealsEventRequested();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MealsEventRefreshed extends MealsEvent {
  MealsEventRefreshed();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
