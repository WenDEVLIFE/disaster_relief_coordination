import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomButton.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomOutlineTextField.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import '../widgets/CustomOutlinePasswordField.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController controller = TextEditingController();
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
                child: CustomOutlineTextField(hintext: 'Full Name', controller: controller),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlineTextField(hintext: 'Email', controller: controller),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlinePassField(hintext: 'Password', controller: controller),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child: CustomOutlinePassField(hintext: 'Confirm Password', controller: controller),
              ),
              Padding(padding: EdgeInsets.all(16.0),
                child:  CustomButton(hintText: 'LOGIN', fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w700, onPressed: (){

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

}