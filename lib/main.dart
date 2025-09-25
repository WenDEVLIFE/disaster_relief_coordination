import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_relief_coordination/src/bloc/AlertBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/LanguageBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/LoginBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/NotificationBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/PasswordChangeBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/PersonBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/ProfileBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/RegisterBloc.dart';
import 'package:disaster_relief_coordination/src/bloc/StatusBloc.dart';
import 'package:disaster_relief_coordination/src/services/LanguageService.dart';
import 'package:disaster_relief_coordination/src/repository/RegisterRepository.dart';
import 'package:disaster_relief_coordination/src/services/FirebaseServices.dart';
import 'package:disaster_relief_coordination/src/services/NotificationService.dart';
import 'package:disaster_relief_coordination/src/services/PhilippineDisasterService.dart';
import 'package:disaster_relief_coordination/src/services/GdacsService.dart';
import 'package:disaster_relief_coordination/src/view/SplashView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
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
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<StatusBloc>(create: (context) => StatusBloc()),
        BlocProvider<PersonBloc>(create: (context) => PersonBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<LanguageBloc>(
          create: (context) =>
              LanguageBloc(languageService: LanguageService())
                ..add(const InitializeLanguage()),
        ),
        BlocProvider<PasswordChangeBloc>(
          create: (context) =>
              PasswordChangeBloc(registerRepository: RegisterRepositoryImpl()),
        ),
        BlocProvider<AlertBloc>(
          create: (context) => AlertBloc(
            disasterService: PhilippineDisasterService(
              openWeatherApiKey:
                  'b1b15e88fa797225412429c1c50c122a1', // Free OpenWeather API key for testing
            ),
            gdacsService: GdacsService(),
          ),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) =>
              NotificationBloc(notificationService: NotificationService())
                ..add(const LoadNotifications()),
        ),
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          String appTitle = 'Disaster Relief Coordination';
          if (state is LanguageLoaded) {
            appTitle = context.read<LanguageBloc>().translate('app_name');
          }

          return MaterialApp(
            title: appTitle,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
