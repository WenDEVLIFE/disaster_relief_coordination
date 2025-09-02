import 'package:disaster_relief_coordination/src/widgets/CustomOutlineTextField.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(16.0),
              child: CustomOutlineTextField(hintext: 'Email', controller: controller),
            ),
            Padding(padding: EdgeInsets.all(16.0),
              child: CustomOutlineTextField(hintext: 'Email', controller: controller),
            ),
          ],
        )
      ),
    );
  }
}