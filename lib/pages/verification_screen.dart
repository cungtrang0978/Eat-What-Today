import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eat_what_today/blocs/verification_bloc.dart';
import 'package:flutter_eat_what_today/events/verification_event.dart';
import 'package:flutter_eat_what_today/repositories/food_repository.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/verification_state.dart';

import 'home_screen.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
      ),
      body: Container(child: BlocBuilder<VerificationBloc, VerificationState>(
        builder: (context, verificationState) {
          if (verificationState is VerificationStateNotVerified) {
            return Center(
              child: Column(
                children: [
                  Text('email: ${verificationState.user.email}'),
                  FlatButton(
                    child: Text('Send email verification'),
                    onPressed: () {
                      BlocProvider.of<VerificationBloc>(context)
                          .add(VerificationEventWithVerifiedPressed());
                    },
                  )
                ],
              ),
            );
          }
          if (verificationState is VerificationStateVerified) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()));
            return Center(
              child: Text('Verified'),
            );
          }
          if (verificationState is VerificationStateVerifying) {
            return Center(
              child: Column(
                children: [Text('email: ${verificationState.user.email}')],
              ),
            );
          }
          return Center(
            child: Text('started'),
          );
        },
      )),
    );
  }
}
