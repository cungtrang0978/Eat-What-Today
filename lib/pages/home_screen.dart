import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/login_bloc.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/events/login_event.dart';
import 'package:flutter_eat_what_today/models/account.dart';
import 'package:flutter_eat_what_today/models/meal.dart';
import 'package:flutter_eat_what_today/pages/food_addition_screen.dart';
import 'package:flutter_eat_what_today/pages/foods_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_eat_what_today/pages/meal_addtion_screen.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/meal_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/login_state.dart';

class HomeScreen extends StatefulWidget {
  final FoodRepository foodRepository;

  HomeScreen({@required this.foodRepository}) : assert(foodRepository != null);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedOut());
              BlocProvider.of<LoginBloc>(context).add(LoginEventStarted());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              FlatButton(
                child: Text('Goto Foods Screen'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FoodsScreen()));
                },
              ),
              FlatButton(
                child: Text('Goto Meal Addition Screen'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MealAdditionScreen(
                                foodRepository: widget.foodRepository,
                              )));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
