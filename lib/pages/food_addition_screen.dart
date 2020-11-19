import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eat_what_today/blocs/foods_bloc.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodAdditionScreen extends StatefulWidget {

  @override
  _FoodAdditionScreenState createState() => _FoodAdditionScreenState();
}

class _FoodAdditionScreenState extends State<FoodAdditionScreen> {
  TextEditingController nameController;
  GlobalKey<AutoCompleteTextFieldState<Food>> key = new GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Addition'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
            ),
          ),
/*          AutoCompleteTextField<Food>(
            key: key,
            controller: nameController,
            suggestions: [
              Food(name: "Sautatca"),
              Food(name: "May muon go"),
              Food(name: "Anh la ai"),
              Food(name: "Anh khong biet dau"),
              Food(name: "Anh yeu em"),
              Food(name: "Anh la cua em"),
              Food(name: "Em la cua anh"),

            ],
            suggestionsAmount: 100,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            decoration: InputDecoration(
              suffixIcon: Container(
                width: 85.0,
                height: 60.0,
              ),
              contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
              filled: true,
              hintText: 'Search Player Name',
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
                nameController.text = food.name;
                print(food);
              });
            },
          ),*/
          FlatButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final food = Food(
                    name: nameController.text,
                    createdAt: DateTime.now());
                BlocProvider.of<FoodsBloc>(context)
                    .foodRepository
                    .insertFood(food);
              }
              print("insert food");
              // FoodRepository().getFoods();
            },
            child: Text('Insert Food'),
          )
        ],
      ),
    );
  }
}
