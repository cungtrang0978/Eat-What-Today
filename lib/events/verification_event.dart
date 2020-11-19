import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class VerificationEvent extends Equatable {
  const VerificationEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerificationEventStarted extends VerificationEvent {}

class VerificationEventWithVerifiedPressed extends VerificationEvent {}
