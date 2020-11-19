import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerificationStateInitial extends VerificationState {}

class VerificationStateVerifying extends VerificationState {
  final User user;

  VerificationStateVerifying({@required this.user}) : assert(user != null);

  @override
  // TODO: implement props
  List<Object> get props => [user];
}

class VerificationStateNotVerified extends VerificationState {
  final User user;

  VerificationStateNotVerified({@required this.user}) : assert(user != null);

  @override
  // TODO: implement props
  List<Object> get props => [user];
}

class VerificationStateVerified extends VerificationState {
  final User user;

  VerificationStateVerified({@required this.user}) : assert(user != null);

  @override
  // TODO: implement props
  List<Object> get props => [user];
}
