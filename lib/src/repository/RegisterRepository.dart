import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class RegisterRepository {
  Future<void> registerUser(String email, String password, String name);
  Future<void> changePassword(String currentPassword, String newPassword);
}

class RegisterRepositoryImpl extends RegisterRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<void> registerUser(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception("User UID is null after registration.");

      await db.collection('users').doc(uid).set({
        'Email': email,
        'FullName': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Fluttertoast.showToast(msg: "Registration Successful");
    } catch (e) {
      Fluttertoast.showToast(msg: "Registration failed: $e");
      rethrow;
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No authenticated user found");
      }

      // Re-authenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      Fluttertoast.showToast(msg: "Password changed successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Password change failed: $e");
      rethrow;
    }
  }
}
