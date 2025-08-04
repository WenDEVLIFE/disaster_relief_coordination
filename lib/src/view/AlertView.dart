import 'package:disaster_relief_coordination/src/bloc/AlertBloc.dart';
import 'package:disaster_relief_coordination/src/widgets/AlertCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlertView extends StatefulWidget {
  const AlertView({super.key});

  @override
  StateView createState() => StateView();
}

class StateView extends State<AlertView> {
  @override
  void initState() {
    super.initState();
    context.read<AlertBloc>().add(const LoadAlerts());
  }

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
          'Alerts',
          style: TextStyle(
            fontFamily: 'GoogleSansCode',
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AlertBloc, AlertState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.alerts.length,
                  itemBuilder: (context, index) {
                    final alerts = state.alerts[index];
                    return AlertCard(alert: alerts);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}