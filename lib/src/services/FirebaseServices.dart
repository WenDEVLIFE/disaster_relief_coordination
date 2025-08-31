import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseServices {

  static Future<void> run() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey:'AIzaSyAb31M31facZNr6ERw1rwO62bqOPGAaaVs',
        appId: Platform.isIOS
            ?  '1:864372409166:ios:818f00c0a7c0fc2a8e541f'
            : '1:864372409166:android:b7a4e1d0861c821b8e541f',
        messagingSenderId: '864372409166',
        projectId: 'disasterdb-f381f',
        storageBucket:  'disasterdb-f381f.firebasestorage.app',
      ),
    );

    if (Firebase.apps.isEmpty) {
      print('Firebase is not initialized');
      Fluttertoast.showToast(
        msg: "Firebase is not initialized",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      print('Firebase is initialized successfully');
      Fluttertoast.showToast(
        msg: "Firebase is initialized successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}