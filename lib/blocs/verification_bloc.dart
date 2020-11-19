import 'package:flutter/cupertino.dart';
import 'package:flutter_eat_what_today/events/verification_event.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/states/verification_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final UserRepository userRepository;

  VerificationBloc({@required this.userRepository})
      : assert(userRepository != null),
        super(VerificationStateInitial());

  @override
  Stream<VerificationState> mapEventToState(
      VerificationEvent verificationEvent) async* {
    // TODO: implement mapEventToState
    if (verificationEvent is VerificationEventStarted) {
      User user = await userRepository.getUser();
      print(user.emailVerified);
      if (user.emailVerified) {
        yield VerificationStateVerified(user: user);
      } else {
        yield VerificationStateNotVerified(user: user);
      }
    } else if (verificationEvent is VerificationEventWithVerifiedPressed) {
      User user = await userRepository.getUser();
      userRepository.sendEmailVerification();
      yield VerificationStateVerifying(user: user);
    }
  }
}
