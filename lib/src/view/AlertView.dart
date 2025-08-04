import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertView extends StatefulWidget {
  const AlertView({super.key});

  @override
  StateView createState() => StateView();
}

class StateView extends State<AlertView> {
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
        title: const Text(
          'Alert',
          style: TextStyle(
            fontFamily: 'GoogleSansCode',
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'This is the Alert View',
          style: TextStyle(
            fontFamily: 'GoogleSansCode',
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}