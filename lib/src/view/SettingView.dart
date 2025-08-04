import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import '../widgets/MenuWidget.dart';

class SettingView extends StatelessWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const CustomText(
          text: 'Settings',
          fontFamily: 'GoogleSansCode',
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: MenuListWidget()
        ),
      ),
    );
  }
}