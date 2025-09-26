import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/PersonModel.dart';

class UserStatusService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _userStatusCollection =>
      _firestore.collection('user_status');

  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Initialize user status service
  Future<void> initialize() async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
  }

  /// Save user status to Firestore
  Future<void> saveUserStatus(bool isSafe) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final statusData = {
      'userId': _currentUserId,
      'isSafe': isSafe,
      'lastUpdated': FieldValue.serverTimestamp(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Save to user_status collection
    await _userStatusCollection.doc(_currentUserId).set(statusData);

    // Also update user document
    await _usersCollection.doc(_currentUserId).set({
      'lastStatusUpdate': FieldValue.serverTimestamp(),
      'isSafe': isSafe,
    }, SetOptions(merge: true));
  }

  /// Get user status from Firestore
  Future<bool> getUserStatus() async {
    if (_currentUserId == null) {
      return true; // Default to safe
    }

    try {
      final docSnapshot = await _userStatusCollection.doc(_currentUserId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return data['isSafe'] ?? true;
      }
      return true; // Default to safe
    } catch (e) {
      print('Error getting user status: $e');
      return true; // Default to safe
    }
  }

  /// Get last updated timestamp
  Future<String> getLastUpdated() async {
    if (_currentUserId == null) {
      return 'Never';
    }

    try {
      final docSnapshot = await _userStatusCollection.doc(_currentUserId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        final timestamp = data['timestamp'] as String?;
        if (timestamp != null) {
          final dateTime = DateTime.parse(timestamp);
          return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        }
      }
      return 'Never';
    } catch (e) {
      print('Error getting last updated: $e');
      return 'Never';
    }
  }

  /// Stream of all user statuses for real-time updates
  Stream<List<PersonModel>> getAllUserStatuses() {
    return _userStatusCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PersonModel(
          id: data['userId'] ?? doc.id,
          name: data['userId'] == _currentUserId
              ? 'You'
              : 'User ${doc.id.substring(0, 6)}',
          status: data['isSafe'] == true ? 'Safe' : 'Unsafe',
          gender: 'Other', // You might want to add gender field to Firestore
        );
      }).toList();
    });
  }

  /// Stream of current user status for real-time updates
  Stream<bool> getCurrentUserStatus() {
    if (_currentUserId == null) {
      return Stream.value(true);
    }

    return _userStatusCollection.doc(_currentUserId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['isSafe'] ?? true;
      }
      return true;
    });
  }

  /// Update user profile information
  Future<void> updateUserProfile(String name, String gender) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _usersCollection.doc(_currentUserId).set({
      'name': name,
      'gender': gender,
      'lastProfileUpdate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Get user profile information
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (_currentUserId == null) {
      return null;
    }

    try {
      final docSnapshot = await _usersCollection.doc(_currentUserId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Listen to user status changes (for real-time updates)
  Stream<DocumentSnapshot> getUserStatusStream() {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    return _userStatusCollection.doc(_currentUserId).snapshots();
  }
}
