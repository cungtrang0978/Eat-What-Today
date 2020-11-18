import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eat_what_today/models/food.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';

class FoodAdditionScreen extends StatefulWidget {
  @override
  _FoodAdditionScreenState createState() => _FoodAdditionScreenState();
}

class _FoodAdditionScreenState extends State<FoodAdditionScreen> {
  TextEditingController nameController;

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
          FlatButton(onPressed: () {
            // if(nameController.text.isNotEmpty){
            //   final food = Food(name: nameController.text, createdBy: "Thang", createdAt: DateTime.now());
            //   FoodRepository().insertFood(food);
            // }
            FoodRepository().getFoods();
          }, child: Text('Insert Food'),)
        ],
      ),
    );
  }
}
