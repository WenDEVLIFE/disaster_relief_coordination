import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/SvgHelpers.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomOutlineTextField.dart';
import '../widgets/CustomText.dart';

class ForgotPasswordView extends StatefulWidget{
  const ForgotPasswordView({super.key});

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>{
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomText(text: 'Forgot Password',
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center),
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
                    colorFilter:  ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlineTextField(hintext: 'Email', controller: emailController),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child:  CustomButton(hintText: 'LOGIN', fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w700, onPressed: (){

                }, width: screenWidth * 0.8, height: screenHeight * 0.05 ),
              ),

            ],
          ),
        ),
      )
    );
  }
  }