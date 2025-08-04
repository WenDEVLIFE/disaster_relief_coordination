import 'package:flutter/material.dart';

import '../helpers/ColorHelpers.dart';
import '../widgets/CustomText.dart';

class MyStatusView extends StatelessWidget {
  const MyStatusView({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorHelpers.primaryColor,
        title: const CustomText(
          text: 'My Status',
          fontFamily: 'GoogleSansCode',
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.3,
              color: Colors.green,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: 'Your Current Status',
                      fontFamily: 'GoogleSansCode',
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    const CustomText(
                      text: 'Last updated: 2023-10-01',
                      fontFamily: 'GoogleSansCode',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ),
          ),
          Expanded(
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.7,
              color: Colors.white,
              child: SingleChildScrollView(
              ),
            ),
          ),
        ],
      ),
    );
  }
}