import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_eat_what_today/models/meal.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/meal_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';

class MealAdditionScreen extends StatefulWidget {
  final FoodRepository foodRepository;

  MealAdditionScreen({@required this.foodRepository})
      : assert(foodRepository != null);

  @override
  _MealAdditionScreenState createState() => _MealAdditionScreenState();
}

class _MealAdditionScreenState extends State<MealAdditionScreen> {
  TextEditingController foodController = TextEditingController();
  TextEditingController mealTypeController = TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<Food>> foodKey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<MealType>> mealTypeKey = new GlobalKey();

  String selectedFoodId;
  List<MealType> mealTypes = [
    MealType.breakfast,
    MealType.lunch,
    MealType.dinner,
    MealType.other
  ];
  List<Widget> mealTypeItems;

  List<bool> isSelected = List.generate(4, (_) => false);

  void _onButtonPressed({BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureBuilder<List<Food>>(
            future: widget.foodRepository.getFoods(),
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
                        onTap: (){
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

            TextField(
              controller: foodController,
              decoration: InputDecoration(
                hintText: 'Choose Food'
              ),
              onTap: () {
                _onButtonPressed(context: context);
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
            RaisedButton(
              child: Text('Add'),
              onPressed: () {
                print('add');
                MealType mealType;
                for (int i = 0; i < isSelected.length; i++) {
                  if (isSelected[i]) {
                    mealType = mealTypes[i];
                  }
                }
                if (selectedFoodId.isNotEmpty && mealType != null) {
                  final meal =
                      Meal(fid: selectedFoodId, mealType: mealType);
                  MealRepository(userRepository: UserRepository())
                      .insertMeal(meal);
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
}