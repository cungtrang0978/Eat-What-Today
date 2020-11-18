import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class MealEvent extends Equatable{
  const MealEvent();
 @override
  // TODO: implement props
  List<Object> get props => [];
}

class MealEventRequested extends MealEvent{
  final String uid;

  MealEventRequested({@required this.uid}): assert(uid!=null);

  @override
  // TODO: implement props
  List<Object> get props => [uid];
}

class MealEventRefreshed extends MealEvent{
  final String uid;
  MealEventRefreshed({@required this.uid}): assert(uid!=null);
  @override
  // TODO: implement props
  List<Object> get props => [uid];
}
