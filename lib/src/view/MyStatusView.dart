import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helpers/ColorHelpers.dart';
import '../widgets/CustomText.dart';

class MyStatusView extends StatelessWidget {
  const MyStatusView({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Text(
          'My Status View',
        ),
      ),
    );
  }
}