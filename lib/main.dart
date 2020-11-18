import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/login_bloc.dart';
import 'package:flutter_eat_what_today/blocs/simple_bloc_observer.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/pages/home_screen.dart';
import 'package:flutter_eat_what_today/pages/test_calendar_screen.dart';
import 'package:flutter_eat_what_today/pages/login_page.dart';
import 'package:flutter_eat_what_today/pages/splash_page.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//In this lesson, we will build User Interface(UI)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  final FoodRepository _foodRepository = FoodRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hôm Nay Ăn Gì?',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: _userRepository)
          ..add(AuthenticationEventStarted()),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {
            if (authenticationState is AuthenticationStateSuccess) {
              return HomeScreen();
            } else if (authenticationState is AuthenticationStateFailure) {
              return BlocProvider<LoginBloc>(
                  create: (context) =>
                      LoginBloc(userRepository: _userRepository),
                  child: LoginPage(
                    userRepository: _userRepository,
                  ) //LoginPage,
                  );
            }
            return SplashPage();
          },
        ),
      ),
      // FilmList(),
    );
  }
}
