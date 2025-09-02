import 'package:disaster_relief_coordination/src/helpers/SessionHelper.dart';
import 'package:disaster_relief_coordination/src/repository/LoginRepository.dart';
import 'package:disaster_relief_coordination/src/repository/RegisterRepository.dart';
import 'package:disaster_relief_coordination/src/view/GetStartedView.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginEvent extends Equatable {


  @override
  List<Object?> get props => [];
}

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginRepositoryImpl loginRepository = LoginRepositoryImpl();
  final SessionHelpers sessionHelpers = SessionHelpers();

  void login(BuildContext context) async{
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Show error message
      print('Email and password cannot be empty');
      return;
    }

    var  userData = await loginRepository.loginUser(email, password);

    if (userData != null) {
      // Login successful, navigate to the next screen
      print('Login successful: $userData');
      String email = userData['Email'].toString();
      String role = userData['Role'].toString();
      String fullName = userData['FUllName'].toString();
      String uid = userData['Uid'].toString();

      // save the session
      sessionHelpers.saveUserInfo({'email': email, 'role': role, 'fullName': fullName, 'uid': uid});

      // navigate to next page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetStartedView()));
    } else {
      // Show error message
      print('Login failed');
    }
  }
}