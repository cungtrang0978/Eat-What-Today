import 'dart:developer';

import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/pages/TestScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;

  double _widthListView = 0;
  double _left = 0;
  double _widthMiniScrollBar = 0;
  static const double _widthScrollBar = 100;
  static const double _heightScrollBar = 10;
  int itemCount = 50;
  static const double _widthItem = 100;
  static const double _heightItem = 100;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  _onScroll() {
    double offset = _scrollController.offset;

    _left = offset * _widthMiniScrollBar / _widthScrollBar;
    // print(_scrollController.offset *
    //     50 /
    //     _scrollController.position.maxScrollExtent);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _widthListView = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hôm nay ăn gì?'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationEventLoggedOut(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TestScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 100,
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return item(index);
              },
              itemCount: itemCount,
              scrollDirection: Axis.horizontal,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          scrollBar(),
          FlatButton(
            onPressed: () {
              _scrollController.jumpTo(_widthListView);
            },
            child: Text("Hello"),
          ),
        ],
      ),
    );
  }

  Widget item(index) {
    return Container(
      // key: itemKey,
      color: Colors.teal,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      child: Text('$index'),
    );
  }

  Stack scrollBar() {
    _widthMiniScrollBar =
        _widthScrollBar * _widthListView / _widthItem / itemCount;
    // print(
    //     "_widthMiniScrollBar $_widthMiniScrollBar; _widthScrollBar: $_widthScrollBar");
    // print(
    //     "tyle: ${_widthScrollBar / _widthMiniScrollBar} :: ${_widthItem * itemCount / _widthListView}");
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          height: _heightScrollBar,
          width: _widthScrollBar,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: _left,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            height: _heightScrollBar,
            width: _widthMiniScrollBar,
          ),
        ),
      ],
    );
  }
}
