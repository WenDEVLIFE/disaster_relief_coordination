import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/ColorHelpers.dart';
import '../helpers/ImageHelper.dart';
import '../widgets/CustomText.dart';

class GetStartedView extends StatelessWidget {
  const GetStartedView({Key? key}) : super(key: key);

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
              height: screenHeight * 0.4,
              child: SvgPicture.asset(
                SvgHelpers.heart1,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  ColorHelpers.primaryColor,
                  BlendMode.srcIn,
                ),
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
              ),
            ),
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
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.10),
              child:     CustomText(text: 'Coordinate disaster response efforts and distribute essential resources',
                  fontFamily: 'GoogleSansCode',
                  fontSize: 25.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  textAlign:  TextAlign.center
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.10),
              child: CustomButton(hintText: 'Get Started', fontFamily: 'GoogleSansCode', fontSize: 20, fontWeight: FontWeight.w700, onPressed: (){

              }, width: screenWidth * 0.8, height: screenHeight * 0.07,),
            ),
          ],
        ),
      ),
    );
  }
}