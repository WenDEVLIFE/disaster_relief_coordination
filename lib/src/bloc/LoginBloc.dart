import 'package:disaster_relief_coordination/src/repository/LoginRepository.dart';
import 'package:disaster_relief_coordination/src/repository/RegisterRepository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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

  void login(BuildContext context) async{
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // Show error message
      print('Email and password cannot be empty');
      return;
    }

    bool isLoggedIn = await loginRepository.loginUser(email, password);

    if (isLoggedIn) {
      // Navigate to the next screen or show success message
      print('Login successful');

    } else {
      // Show error message
      print('Login failed. Please check your credentials.');
    }
  }
}