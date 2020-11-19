import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/foods_bloc.dart';
import 'package:flutter_eat_what_today/events/foods_event.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/pages/food_addition_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/foods_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodsScreen extends StatefulWidget {
  @override
  _FoodsScreenState createState() => _FoodsScreenState();
}

class _FoodsScreenState extends State<FoodsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FoodsBloc>(context).add(FoodsEventRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FoodsScreen'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FoodAdditionScreen())),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              BlocProvider.of<FoodsBloc>(context).add(FoodsEventRefreshed());
            },
          )
        ],
      ),
      body: Container(
        child: BlocBuilder<FoodsBloc, FoodsState>(
          builder: (BuildContext context, foodsState) {
            if (foodsState is FoodsStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (foodsState is FoodsStateSuccess) {
              final List<Food> foods = foodsState.foods;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return Container(
                    child: Text(food.name),
                    padding: EdgeInsets.all(10),
                  );
                },
                itemCount: foods.length,
              );
            }
            if (foodsState is FoodsStateFailure) {
              return Text(
                'Something went wrong',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              );
            }
            return Center(
              child: Text('Initial'),
            );
          },
        ),
      ),
    );
  }
}
