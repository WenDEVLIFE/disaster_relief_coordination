import 'package:disaster_relief_coordination/src/helpers/SessionHelper.dart';
import 'package:disaster_relief_coordination/src/view/GetStartedView.dart';
import 'package:disaster_relief_coordination/src/view/LoginView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helpers/ColorHelpers.dart';
import '../helpers/ImageHelper.dart';
import '../widgets/CustomText.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();

}

class _SplashViewState extends State<SplashView> {

  bool isLoading = true;
  final SessionHelpers sessionHelpers = SessionHelpers();

  void initState() {
    super.initState();
    // Simulate a delay for loading
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
      loadSessions();
    });
  }

  void loadSessions() async{
    var session = await sessionHelpers.getUserInfo();
    if (session != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return GetStartedView();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginView();
      }));
    }
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
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageHelper.logoPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child:   CustomText(text: 'Disaster Relief Coordination',
                  fontFamily: 'GoogleSansCode',
                  fontSize: 30.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  textAlign:  TextAlign.center
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            isLoading
                ? CircularProgressIndicator(
              color: ColorHelpers.primaryColor,
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}