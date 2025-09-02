import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class Loginrepository {
  Future<Map<String, dynamic>?> loginUser(String email, String password);
}

class LoginRepositoryImpl extends Loginrepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user == null) return null;

      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return {
        'Uid': user.uid,
        'Email': doc['Email'],
        'Role': doc['Role'],
        'FUllName': doc['FUllName'],
      };
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }
}