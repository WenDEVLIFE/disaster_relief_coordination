import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelpers.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorHelpers.primaryColor,
        title: const CustomText(text: 'Settings', fontFamily: 'GoogleSansCode', fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700, textAlign: TextAlign.center)
      ),
      body: Center(
        child: Text('Settings Page', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}