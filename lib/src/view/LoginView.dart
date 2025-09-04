import 'package:disaster_relief_coordination/src/bloc/LoginBloc.dart';
import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomButton.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomOutlineTextField.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/CustomOutlinePasswordField.dart';
import 'ForgotPasswordView.dart';
import 'RegisterView.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginBloc loginBloc;

  final TextEditingController controller = TextEditingController();

  @override
  void initState(){
    super.initState();

    loginBloc = LoginBloc();
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
              child:  CustomText(text: 'Login', fontFamily: 'Roboto', fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
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
              child: CustomOutlineTextField(hintext: 'Email', controller: loginBloc.emailController),
            ),
            Padding(padding: EdgeInsets.all(16.0),
              child: CustomOutlinePassField(hintext: 'Password', controller: loginBloc.passwordController),
            ),
            Padding(padding: EdgeInsets.all(16.0),
              child:  GestureDetector(
                onTap: (){
                  // Navigate to forgot password screen
                  print('Forgot Password tapped');
                  Navigator.push(context,  MaterialPageRoute(builder: (context) {
                    return ForgotPasswordView();
                  }));
                },
                child: CustomText(text: 'Forgot Password?', fontFamily: 'Roboto', fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
              ),
            ),
            Padding(padding: EdgeInsets.all(16.0),
              child:  CustomButton(hintText: 'LOGIN', fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w700, onPressed: (){
                loginBloc.login(context);
              }, width: screenWidth * 0.8, height: screenHeight * 0.05 ),
            ),

            Padding(padding: EdgeInsets.all(16.0),
              child:  GestureDetector(
                onTap: (){
                  // Navigate to forgot password screen
                  Navigator.push(context,  MaterialPageRoute(builder: (context) {
                    return RegisterView();
                  }));
                },
                child: CustomText(text: "Don't have an account? Click me to register", fontFamily: 'Roboto', fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
              ),
            ),
          ],
        )
      ),
    );
  }
}