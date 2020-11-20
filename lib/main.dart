import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/foods_bloc.dart';
import 'package:flutter_eat_what_today/blocs/login_bloc.dart';
import 'package:flutter_eat_what_today/blocs/register_bloc.dart';
import 'package:flutter_eat_what_today/blocs/simple_bloc_observer.dart';
import 'package:flutter_eat_what_today/blocs/verification_bloc.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/events/foods_event.dart';
import 'package:flutter_eat_what_today/events/verification_event.dart';
import 'package:flutter_eat_what_today/models/account.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/pages/home_screen.dart';
import 'package:flutter_eat_what_today/pages/test_calendar_screen.dart';
import 'package:flutter_eat_what_today/pages/login_page.dart';
import 'package:flutter_eat_what_today/pages/splash_page.dart';
import 'package:flutter_eat_what_today/pages/verification_screen.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/meal_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/authentication_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/meal.dart';

//In this lesson, we will build User Interface(UI)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  final UserRepository _userRepository = UserRepository();
  final FoodRepository _foodRepository =
      FoodRepository(userRepository: _userRepository);
  final MealRepository _mealRepository =
      MealRepository(userRepository: _userRepository);

  final multiBlocProvider = MultiBlocProvider(
    providers: [
      BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) =>
            AuthenticationBloc(userRepository: _userRepository)
              ..add(AuthenticationEventStarted()),
      ),
      BlocProvider<FoodsBloc>(
        create: (BuildContext context) =>
            FoodsBloc(foodRepository: _foodRepository),
      ),
      BlocProvider<LoginBloc>(
        create: (BuildContext context) =>
            LoginBloc(userRepository: _userRepository),
      ),
      BlocProvider<RegisterBloc>(
        create: (BuildContext context) =>
            RegisterBloc(userRepository: _userRepository),
      ),
/*      BlocProvider<VerificationBloc>(
        create: (BuildContext context) =>
            VerificationBloc(userRepository: _userRepository)
              ..add(VerificationEventStarted()),
      )*/
    ],
    child: MyApp(
      userRepository: _userRepository,
      foodRepository: _foodRepository,
      mealRepository: _mealRepository,
    ),
  );

  runApp(multiBlocProvider);
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final FoodRepository foodRepository;
  final MealRepository mealRepository;

  MyApp(
      {Key key,
      @required this.userRepository,
      @required this.foodRepository,
      @required this.mealRepository})
      : assert(
          userRepository != null &&
              foodRepository != null &&
              mealRepository != null,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hôm Nay Ăn Gì?',
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authenticationState) {
          print(authenticationState.toString());
          if (authenticationState is AuthenticationStateSuccess) {
            return HomeScreen(
              foodRepository: foodRepository,
            );
          }
          if (authenticationState is AuthenticationStateFailure) {
            return LoginPage(
              userRepository: userRepository,
            );
          }
          return SplashPage();
        },
      ),
      // FilmList(),
    );
  }
}
