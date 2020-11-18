import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/pages/food_addition_screen.dart';
import 'package:flutter_eat_what_today/pages/foods_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodsScreen()));
                },
              ),
              FlatButton(
                child: Text('Add Meal'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
