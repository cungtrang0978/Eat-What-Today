import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eat_what_today/blocs/foods_bloc.dart';
import 'package:flutter_eat_what_today/blocs/meals_bloc.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_eat_what_today/models/meal.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/meal_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealAdditionScreen extends StatefulWidget {
  final Meal meal;
  final Food food;

  MealAdditionScreen({this.meal, this.food});

  @override
  _MealAdditionScreenState createState() => _MealAdditionScreenState();
}

class _MealAdditionScreenState extends State<MealAdditionScreen> {
  TextEditingController foodController = TextEditingController();
  TextEditingController dateController;

  GlobalKey<AutoCompleteTextFieldState<Food>> foodKey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<MealType>> mealTypeKey = new GlobalKey();

  MealsBloc mealsBloc;

  String selectedFoodId;
  DateTime selectedDate;
  List<MealType> mealTypes = [
    MealType.breakfast,
    MealType.lunch,
    MealType.dinner,
    MealType.other
  ];
  List<Widget> mealTypeItems;

  List<bool> isSelected = List.generate(4, (_) => false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mealsBloc = BlocProvider.of<MealsBloc>(context);

    selectedDate = widget.meal != null ? widget.meal.eatenAt : DateTime.now();

    dateController =
        TextEditingController(text: convertDateToString(selectedDate));
    if (widget.meal != null) {
      switch (widget.meal.mealType) {
        case MealType.breakfast:
          isSelected[0] = true;
          break;
        case MealType.lunch:
          isSelected[1] = true;
          break;
        case MealType.dinner:
          isSelected[2] = true;
          break;
        case MealType.other:
          isSelected[3] = true;
          break;
      }
    }
  }

  void _onDateButtonPressed({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder<List<Food>>(
            future: FoodRepository(userRepository: UserRepository()).getFoods(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('error'),
                );
              }
              if (snapshot.hasData) {
                final foods = snapshot.data;
                return ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return GestureDetector(
                        child: ListTile(
                          title: Text(food.name),
                        ),
                        onTap: () {
                          print(food.name);
                          setState(() {
                            foodController.text = food.name;
                            selectedFoodId = food.fid;
                            Navigator.pop(context);
                          });
                        },
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        });
  }

  DateTime calculateDateTime(DateTime dateTime, int plusIndex) {
    int dayToMiliseconds = plusIndex * 24 * 60 * 60 * 1000;
    return DateTime.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch + dayToMiliseconds);
  }

  String convertDateToString(DateTime dateTime) {
    int day = dateTime.day;
    int month = dateTime.month;
    int year = dateTime.year;
    return '${weekdayToString(dateTime)},  $day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    mealTypeItems = List<Widget>.generate(4, (index) {
      String name;
      switch (mealTypes[index]) {
        case MealType.breakfast:
          name = 'breakfast';
          break;
        case MealType.lunch:
          name = 'lunch';
          break;
        case MealType.dinner:
          name = 'dinner';
          break;
        case MealType.other:
          name = 'other';
          break;
      }
      return Container(
        width: 70,
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        child: Text(name),
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Addition'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            /*(widget.meal != null && widget.meal.fid != null)
                ? FutureBuilder<Food>(
                    future: mealsBloc.mealRepository.foodRepository
                        .getFood(widget.meal.fid),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        foodController.text = snapshot.data.name;
                        return TextField(
                          controller: foodController,
                          decoration: InputDecoration(hintText: 'Choose Food'),
                          onTap: () {
                            _onDateButtonPressed(context: context);
                          },
                          readOnly: true,
                        );
                      }
                      return TextField(
                        controller: foodController,
                        decoration: InputDecoration(hintText: 'Choose Food'),
                        onTap: () {
                          _onDateButtonPressed(context: context);
                        },
                        readOnly: true,
                      );
                    },
                  )
                : TextField(
                    controller: foodController,
                    decoration: InputDecoration(hintText: 'Choose Food'),
                    onTap: () {
                      _onDateButtonPressed(context: context);
                    },
                    readOnly: true,
                  ),*/
            TextField(
              controller: foodController,
              decoration: InputDecoration(hintText: 'Choose Food'),
              onTap: () {
                _onDateButtonPressed(context: context);
              },
              readOnly: true,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              child: ListView(
                children: [
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (int index) {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        setState(() {
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        });
                      }
                    },
                    children: mealTypeItems,
                  ),
                ],
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              readOnly: true,
              controller: dateController,
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(selectedDate.year - 2),
                        lastDate: DateTime(selectedDate.year + 2))
                    .then((date) {
                  if (date != null)
                    setState(() {
                      dateController.text = convertDateToString(date);
                      setState(() {
                        selectedDate = date;
                      });
                    });
                });
                // showTimePicker(context: context, initialTime: TimeOfDay.now());
              },
            ),
            RaisedButton(
              child: Text('Add'),
              onPressed: () {
                MealType mealType;
                for (int i = 0; i < isSelected.length; i++) {
                  if (isSelected[i]) {
                    mealType = mealTypes[i];
                  }
                }
                if (selectedFoodId != null && mealType != null) {
                  if (widget.meal.mid == null) {
                    print('insert meal');
                    final meal = Meal(
                        fid: selectedFoodId,
                        mealType: mealType,
                        eatenAt: selectedDate);
                    mealsBloc.mealRepository.insertMeal(meal);
                  } else {
                    final meal = widget.meal;
                    meal.fid = selectedFoodId;
                    meal.mealType = mealType;
                    meal.modifiedAt = DateTime.now();
                    print(meal);
                    mealsBloc.mealRepository.updateMeal(meal);
                  }
                  Navigator.of(context).pop(true);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  AutoCompleteTextField<Food> foodTextField(List<Food> foods) {
    return AutoCompleteTextField<Food>(
      key: foodKey,
      controller: foodController,
      suggestions: foods,
      suggestionsAmount: 100,
      style: TextStyle(color: Colors.black, fontSize: 16.0),
      decoration: InputDecoration(
        suffixIcon: Container(
          width: 85.0,
          height: 60.0,
        ),
        contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
        filled: true,
        hintText: 'Search Food',
        hintStyle: TextStyle(color: Colors.black),
      ),
      clearOnSubmit: false,
      itemBuilder: (context, food) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                food.name,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        );
      },
      itemSorter: (a, b) {
        return a.name.compareTo(b.name);
      },
      itemFilter: (food, query) {
        return food.name.toLowerCase().contains(query.toLowerCase());
      },
      itemSubmitted: (food) {
        setState(() {
          foodController.text = food.name;
          print(food);
        });
      },
    );
  }

  String weekdayToString(DateTime dateTime) {
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
}
