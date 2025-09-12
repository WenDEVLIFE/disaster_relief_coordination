import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_relief_coordination/src/bloc/AlertBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/LoginBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/PersonBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/RegisterBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/StatusBloc.dart';
import 'package:disaster_relief_coordination/src/services/FirebaseServices.dart';
import 'package:disaster_relief_coordination/src/view/SplashView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseServices.run();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  return MultiBlocProvider(
  providers: [
  BlocProvider<LoginBloc>(
  create: (context) => LoginBloc()
  ),

    BlocProvider<StatusBloc>(
        create: (context) => StatusBloc()
    ),
    BlocProvider<PersonBloc>  (
        create: (context) => PersonBloc()
    ),
    BlocProvider<AlertBloc>  (
        create: (context) => AlertBloc()
    ),
    BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc()
    )
  ],
  child:  MaterialApp(
  title: 'E-Diary Cakes',
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
  primarySwatch: Colors.blue,

  ),
  home: const SplashView(),
  )
  );
  }

}

