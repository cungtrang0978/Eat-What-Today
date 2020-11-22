import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/login_bloc.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/events/login_event.dart';
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text('Log out'),
                onPressed: (){
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(AuthenticationEventLoggedOut());
                  BlocProvider.of<LoginBloc>(context).add(LoginEventStarted());
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
