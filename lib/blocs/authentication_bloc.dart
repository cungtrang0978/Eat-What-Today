import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  //constructor
  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(AuthenticationStateInitial()); //initial state

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent authenticationEvent) async* {
    if (authenticationEvent is AuthenticationEventStarted) {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final firebaseUser = await _userRepository.getUser();

        yield AuthenticationStateSuccess(firebaseUser: firebaseUser);
      } else {
        yield AuthenticationStateFailure();
      }
    } else if (authenticationEvent is AuthenticationEventLoggedIn) {
      // await userRepository.insertUser();
      print("authenticationEvent: AuthenticationEventLoggedIn");
      yield AuthenticationStateSuccess(
          firebaseUser: await _userRepository.getUser());
    } else if (authenticationEvent is AuthenticationEventLoggedOut) {
      _userRepository.signOut();
      yield AuthenticationStateFailure();
    }
  }
}
