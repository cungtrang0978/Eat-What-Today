import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/login_bloc.dart';
import 'package:flutter_eat_what_today/blocs/meals_bloc.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/events/login_event.dart';
import 'package:flutter_eat_what_today/events/meals_event.dart';
import 'package:flutter_eat_what_today/models/food.dart';

import 'package:flutter_eat_what_today/models/meal.dart';

import 'package:flutter_eat_what_today/pages/foods_screen.dart';

import 'package:flutter_eat_what_today/pages/meal_addtion_screen.dart';
import 'package:flutter_eat_what_today/pages/settings_screen.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/meal_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/meals_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime now = DateTime.now();
  MealsBloc mealsBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mealsBloc = BlocProvider.of<MealsBloc>(context);
    mealsBloc.add(MealsEventRequested());
  }

  static DateTime calculateDateTime(DateTime dateTime, int plusIndex) {
    int dayToMiliseconds = plusIndex * 24 * 60 * 60 * 1000;
    return DateTime.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch + dayToMiliseconds);
  }

  static String weekdayToString(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
        break;
      case 2:
        return 'Tuesday';
        break;
      case 3:
        return 'Wednesday';
        break;
      case 4:
        return 'Thursday';
        break;
      case 5:
        return 'Friday';
        break;
      case 6:
        return 'Saturday';
        break;
      case 7:
        return 'Sunday';
        break;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();
    final foodRepository = FoodRepository(userRepository: userRepository);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                            builder: (context) => MealAdditionScreen()));
                  },
                ),
              ],
            ),
            BlocBuilder<MealsBloc, MealsState>(
              builder: (context, mealsState) {
                if (mealsState is MealsStateLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (mealsState is MealsStateSuccess) {
                  List<Meal> meals = mealsState.meals;

                  List<TableRow> mealRows = List<TableRow>();
                  mealRows.add(TableRow(children: [
                    staticMealCell(''),
                    staticMealCell('Breakfast'),
                    staticMealCell('Lunch'),
                    staticMealCell('Dinner'),
                  ]));
                  for (int index = 0; index < 10; index++) {
                    int plusIndex; // plusIndex to calculate date of week
                    switch (index) {
                      case 0:
                        plusIndex = -7;
                        break;
                      case 1:
                        plusIndex = -6;
                        break;
                      case 2:
                        plusIndex = -5;
                        break;
                      case 3:
                        plusIndex = -4;
                        break;
                      case 4:
                        plusIndex = -3;
                        break;
                      case 5:
                        plusIndex = -2;
                        break;
                      case 6:
                        plusIndex = -1;
                        break;
                      case 7:
                        plusIndex = 0;
                        break;
                      case 8:
                        plusIndex = 1;
                        break;
                      case 9:
                        plusIndex = 2;
                        break;
                    }
                    final color = index % 2 == 0
                        ? Colors.greenAccent[100]
                        : Colors.redAccent[100];
                    final date = calculateDateTime(now, plusIndex);
                    List<Widget> cellChildren = List<Widget>();
                    List<Meal> dateMeals = meals.where((meal) {
                      return meal.eatenAt.day == date.day;
                    }).toList();

                    //insert top cells
                    cellChildren.add(staticMealCell(weekdayToString(date),
                        date: date,
                        color: index % 2 == 0
                            ? Colors.greenAccent[100]
                            : Colors.redAccent[100]));

                    //method insert empty mealCell
                    void _insertEmptyCell(MealType mealType) {
                      cellChildren.add(mealCell(
                          Meal(eatenAt: date, mealType: mealType),
                          color: color));
                    }

                    if (dateMeals.isEmpty) {
                      _insertEmptyCell(MealType.breakfast);
                      _insertEmptyCell(MealType.lunch);
                      _insertEmptyCell(MealType.dinner);
                    } else {
                      //insert breakfast cell
                      if (dateMeals
                          .where((meal) => meal.mealType == MealType.breakfast)
                          .toList()
                          .isNotEmpty) {
                        Meal meal = dateMeals
                            .where(
                                (meal) => meal.mealType == MealType.breakfast)
                            .toList()
                            .first;
                        cellChildren.add(mealCell(meal, color: color));
                      } else {
                        _insertEmptyCell(MealType.breakfast);
                      }

                      //insert lunch cell
                      if (dateMeals
                          .where((meal) => meal.mealType == MealType.lunch)
                          .toList()
                          .isNotEmpty) {
                        Meal meal = dateMeals
                            .where((meal) => meal.mealType == MealType.lunch)
                            .toList()
                            .first;
                        cellChildren.add(mealCell(meal, color: color));
                      } else {
                        _insertEmptyCell(MealType.lunch);
                      }

                      //insert dinner cell
                      if (dateMeals
                          .where((meal) => meal.mealType == MealType.dinner)
                          .toList()
                          .isNotEmpty) {
                        Meal meal = dateMeals
                            .where((meal) => meal.mealType == MealType.dinner)
                            .toList()
                            .first;
                        cellChildren.add(mealCell(meal, color: color));
                      } else {
                        _insertEmptyCell(MealType.dinner);
                      }
                    }

                    mealRows.add(TableRow(children: cellChildren));
                  }
                  return Table(
                      border: TableBorder.all(
                          color: Colors.black26,
                          width: 1,
                          style: BorderStyle.solid),
                      children: mealRows);
                }
                if (mealsState is MealsStateFailure) {
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
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text('Refresh'),
              onPressed: () {
                mealsBloc.add(MealsEventRefreshed());
              },
            )
          ],
        ),
      ),
    );
  }

  Widget mealCell2(Meal meal, {@required Color color}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: meal.fid != null
          ? FutureBuilder<Food>(
        future: mealsBloc.mealRepository.foodRepository.getFood(meal.fid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          if (snapshot.hasData) {
            final food = snapshot.data;
            return GestureDetector(
              child: Container(
                width: 150,
                constraints: BoxConstraints(
                    minHeight: 50, minWidth: double.maxFinite),
                // padding: EdgeInsets.all(15),
                alignment: Alignment.center,
                color: color,
                child: Container(
                  constraints: BoxConstraints(minHeight: 50),
                  alignment: Alignment.center,
                  child: Text(food.name),
                ),
              ),
              onTap: () async {
                // print(meal);
                bool isSuccessfulAddition = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MealAdditionScreen(
                          meal: meal,
                          food: food,
                        ))) ??
                    false;
                if (isSuccessfulAddition) {
                  mealsBloc.add(MealsEventRefreshed());
                }
              },
            );
          } else {
            return Text('');
          }
        },
      )
          : GestureDetector(
        child: Container(
          constraints:
          BoxConstraints(minHeight: 50, minWidth: double.maxFinite),
          width: 150,
          child: Text(''),
        ),
        onTap: () async {
          // print(meal);
          bool isSuccessfulAddition = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MealAdditionScreen(
                    meal: meal,
                  ))) ??
              false;
          if (isSuccessfulAddition) {
            mealsBloc.add(MealsEventRefreshed());
          }
        },
      ),
    );
  }

  Widget mealCell(Meal meal, {@required Color color}) {

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: GestureDetector(
        child: Container(
          width: 150,
          constraints:
              BoxConstraints(minHeight: 50, minWidth: double.maxFinite),
          // padding: EdgeInsets.all(15),
          alignment: Alignment.center,
          color: color,
          child: meal.fid != null
              ? FutureBuilder<Food>(
                  future:
                      mealsBloc.mealRepository.foodRepository.getFood(meal.fid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      final food = snapshot.data;
                      return Container(
                        constraints: BoxConstraints(minHeight: 50),
                        alignment: Alignment.center,
                        child: Text(food.name),
                      );
                    } else {
                      return Text('');
                    }
                  },
                )
              : Container(
                  constraints: BoxConstraints(minHeight: 50),
                  width: double.maxFinite,
                  child: Text(''),
                ),
        ),
        onTap: () async {
          print(meal);
          bool isSuccessfulAddition = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealAdditionScreen(
                            meal: meal,
                          ))) ??
              false;
          if (isSuccessfulAddition) {
            mealsBloc.add(MealsEventRefreshed());
          }
        },
      ),
    );
  }

  String convertDateToString(DateTime dateTime) {
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year;
    return '$day/$month/$year';
  }

  Widget staticMealCell(String label, {DateTime date, Color color}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Center(
        child: Container(
          color: color,
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (date != null) Text(convertDateToString(date)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
