import 'dart:async';

import 'package:disaster_relief_coordination/src/bloc/RegisterBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomButton.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomOutlineTextField.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/CustomOutlinePasswordField.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController controller = TextEditingController();
  late RegisterBloc registerBloc;

  @override
  void initState() {
    super.initState();
    registerBloc = RegisterBloc();

  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(16.0),
                child:  CustomText(text: 'Register', fontFamily: 'Roboto', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.1,
                  child: SvgPicture.asset(
                    SvgHelpers.person,
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.1,
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn)
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlineTextField(hintext: 'Full Name', controller: registerBloc.nameController),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlineTextField(hintext: 'Email', controller: registerBloc.emailController),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlinePassField(hintext: 'Password', controller: registerBloc.passwordController),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlinePassField(hintext: 'Confirm Password', controller: registerBloc.confirmPasswordController),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child:  CustomButton(hintText: 'Register', fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w700, onPressed: (){

                if (registerBloc.emailController.text.isEmpty ||
                    registerBloc.passwordController.text.isEmpty ||
                    registerBloc.confirmPasswordController.text.isEmpty ||
                    registerBloc.nameController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please fill all the fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                registerBloc.sendCode(context);
                openOTPDialog();
                }, width: screenWidth * 0.8, height: screenHeight * 0.05 ),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child:  GestureDetector(
                  onTap: (){
                    // Navigate to forgot password screen
                    print('login tapped');
                    Navigator.pop(context);
                  },
                  child: CustomText(text: "Already have an account? Click me to login", fontFamily: 'Roboto', fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
                ),
              ),
            ],
          )
      ),
    );
  }

  void openOTPDialog() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        int secondsLeft = 30;
        Timer? timer;

        return StatefulBuilder(
          builder: (context, setState) {
            timer ??= Timer.periodic(Duration(seconds: 1), (t) {
              if (secondsLeft > 0) {
                setState(() {
                  secondsLeft--;
                });
              } else {
                t.cancel();
              }
            });

            final double screenHeight = MediaQuery.of(context).size.height;
            final double screenWidth = MediaQuery.of(context).size.width;

            return AlertDialog(
              backgroundColor: Colors.white,
              title: CustomText(
                text: 'Enter the Verification Code sent to your email',
                fontFamily: 'EB Garamond',
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700,
                textAlign:  TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text:  'Time left: $secondsLeft seconds',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    textAlign:  TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.05,
                      child:  CustomOutlineTextField(hintext: 'Verification Code', controller: registerBloc.otpController),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[

                TextButton(
                  child:CustomText(
                    text: 'Cancel',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    textAlign:  TextAlign.center,
                  ),
                  onPressed: () {
                    timer?.cancel();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child:CustomText(
                    text: 'Resend',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    if (secondsLeft == 0) {
                      setState(() {
                        secondsLeft = 30;
                      });
                      Fluttertoast.showToast(
                        msg: "OTP resent",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      registerBloc.sendCode(context);
                    }
                    Fluttertoast.showToast(
                      msg: "Please wait for the timer to finish",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                ),
                TextButton(
                  onPressed: secondsLeft == 0
                      ? null
                      : () async {

                    if (registerBloc.otpController.text == registerBloc.otpCode) {
                      await registerBloc.register(context);
                      timer?.cancel();
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Invalid OTP",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  },
                  child: CustomText(
                    text: 'Submit',
                    fontFamily: 'EB Garamond',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

}