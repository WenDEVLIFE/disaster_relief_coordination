import 'package:disaster_relief_coordination/src/helpers/ColorHelpers.dart';
import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:disaster_relief_coordination/src/widgets/PanelWidget.dart';
import 'package:flutter/material.dart';

import 'MyStatusView.dart';
import 'SettingView.dart';

class DashboardView extends StatelessWidget {

  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Home', fontFamily: 'GoogleSansCode', fontSize: 30, color: Colors.black, fontWeight: FontWeight.w700, textAlign: TextAlign.center)
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: screenWidth * 0.10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PanelWidget(label: 'Alerts & Warnings', svgPath: SvgHelpers.alert, onTap: (){
                 print('Alerts & Warnings tapped');
                },),
                SizedBox(width: screenWidth * 0.05), // Spacing between panels
                PanelWidget(label: 'Relief Centers', svgPath: SvgHelpers.mapin, onTap: (){

                },),
              ],
            ),
            SizedBox(width: screenWidth * 0.10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PanelWidget(label: 'My Status', svgPath: SvgHelpers.person, onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyStatusView();
                  }));

                },),
                SizedBox(width: screenWidth * 0.05), // Spacing between panels
                PanelWidget(label: 'Settings', svgPath: SvgHelpers.settings, onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SettingView();
                  }));

                },),
              ],
            ),
          ],
        ),
      ),
    );
  }

}