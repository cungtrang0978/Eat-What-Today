import 'package:flutter_eat_what_today/blocs/authentication_bloc.dart';
import 'package:flutter_eat_what_today/blocs/login_bloc.dart';
import 'package:flutter_eat_what_today/events/authentication_event.dart';
import 'package:flutter_eat_what_today/events/login_event.dart';
import 'package:flutter_eat_what_today/models/account.dart';
import 'package:flutter_eat_what_today/pages/buttons/google_login_button.dart';
import 'package:flutter_eat_what_today/pages/buttons/login_button.dart';
import 'package:flutter_eat_what_today/pages/buttons/register_user_button.dart';
import 'package:flutter_eat_what_today/repositories/user_repository.dart';
import 'package:flutter_eat_what_today/states/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;
  //constructor
  LoginPage({Key key, @required UserRepository userRepository}):
        assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      //when email is changed,this function is called !
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      //when password is changed,this function is called !
      _loginBloc.add(LoginEventPasswordChanged(password: _passwordController.text));
    });
  }
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      loginState.isValidEmailAndPassword & isPopulated && !loginState.isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState){
          if(loginState.isFailure) {
            print('Login failed');
          } else if(loginState.isSubmitting) {
            print('Logging in');
          } else if(loginState.isSuccess) {
            //add event: AuthenticationEventLoggedIn ?
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLoggedIn());
          }
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText:  'Enter your email'
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return loginState.isValidEmail ? null : 'Invalid email format';
                    },
                  ),
                  TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Enter password'
                      ),
                      obscureText: true,
                      autovalidate: true,
                      autocorrect: false,
                      validator: (_){
                        return loginState.isValidEmail ? null : 'Invalid password format';
                      }),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: isLoginButtonEnabled(loginState)?
                          _onLoginEmailAndPassword : null, //check is enabled ?
                        ),
                        Padding(padding: EdgeInsets.only(top: 10),),
                        GoogleLoginButton(),
                        Padding(padding: EdgeInsets.only(top: 10),),
                        RegisterUserButton(userRepository: _userRepository,)
                      ],
                    ),// a login button here
                  ),
                  //Add "register" button here, to "navigate" to "Register Page"

                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void _onLoginEmailAndPassword() {
    _loginBloc.add(LoginEventWithEmailAndPasswordPressed(
        email: _emailController.text,
        password: _passwordController.text
    ));
    //Failed because user does not exist
  }
}