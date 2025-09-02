import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Loginrepository {

  Future<bool> loginUser(String email, String password);
}

class LoginRepositoryImpl extends Loginrepository {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login method
  @override
  Future<bool> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user != null;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

}
