import 'package:disaster_relief_coordination/src/repository/RegisterRepository.dart';
import 'package:disaster_relief_coordination/src/services/GmailService.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum Gender { male, female }

abstract class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String otpCode = '';
  final RegisterRepositoryImpl _registerRepository = RegisterRepositoryImpl();
  Gender? selectedGender;

  // This will register the user after validating the inputs
  Future<void> register(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String name = nameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        selectedGender == null) {
      print('Please fill in all fields including gender');
      Fluttertoast.showToast(
        msg: "Please fill in all fields including gender selection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password != confirmPassword) {
      print('Passwords do not match');
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password.length < 6) {
      print('Password should be at least 6 characters');
      Fluttertoast.showToast(
        msg: "Password should be at least 6 characters",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return;
    }
    if (email.contains(' ')) {
      print('Email should not contain spaces');
      Fluttertoast.showToast(
        msg: "Email should not contain spaces",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return;
    }
    if (email.contains('@') == false || email.contains('.') == false) {
      print('Please enter a valid email');
      Fluttertoast.showToast(
        msg: "Please enter a valid email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      String genderString = selectedGender == Gender.male ? 'Male' : 'Female';
      await _registerRepository.registerUser(
        email,
        password,
        name,
        gender: genderString,
      );
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      nameController.clear();
      otpController.clear();
    } catch (e) {
      print('Registration failed: $e');
      Fluttertoast.showToast(
        msg: "Registration failed. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
    }
  }

  // generate the codes
  Future<String> generateCode() async {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final String code = List.generate(
      6,
      (index) =>
          chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    ).join();
    return code;
  }

  // this will send the code
  Future<void> sendCode(BuildContext context) async {
    otpCode = await generateCode();
    String email = emailController.text.trim();

    try {
      bool emailSent = await GmailService.sendEmail(email, otpCode);
      if (emailSent) {
        print('Email sent successfully');
        Fluttertoast.showToast(
          msg: "Verification code sent to $email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: CupertinoColors.systemGreen,
          textColor: CupertinoColors.white,
          fontSize: 16.0,
        );
      } else {
        print('Failed to send email');
        Fluttertoast.showToast(
          msg: "Failed to send email. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: CupertinoColors.systemRed,
          textColor: CupertinoColors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
      Fluttertoast.showToast(
        msg: "Failed to send email. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: CupertinoColors.systemRed,
        textColor: CupertinoColors.white,
        fontSize: 16.0,
      );
    }
  }
}
