import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/FamilyMemberModel.dart';
import '../model/PersonModel.dart';

class FamilyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _userStatusCollection => _firestore.collection('user_status');
  CollectionReference get _familyCollection => _firestore.collection('family_members');

  /// Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  /// Initialize family service
  Future<void> initialize() async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }
  }

  /// Add a family member
  Future<void> addFamilyMember(String memberUserId, String name, String relationship, {String? gender}) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final docId = '${_currentUserId}_$memberUserId'; // Unique ID based on relationship

    final familyMemberData = {
      'userId': _currentUserId, // The current user who is adding the family member
      'memberUserId': memberUserId, // The family member's user ID
      'name': name,
      'relationship': relationship,
      'addedDate': DateTime.now().toIso8601String(), // Use current time instead of server timestamp
      'gender': gender,
    };

    // Use set with merge to update if exists or create new
    await _familyCollection.doc(docId).set(familyMemberData, SetOptions(merge: true));
  }

  /// Remove a family member by user ID
  Future<void> removeFamilyMemberByUserId(String memberUserId) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      final docId = '${_currentUserId}_$memberUserId';
      await _familyCollection.doc(docId).delete();
    } catch (e) {
      print('Error removing family member: $e');
      rethrow;
    }
  }

  /// Remove a family member by document ID
  Future<void> removeFamilyMember(String familyMemberId) async {
    if (_currentUserId == null) {
      throw Exception('User not authenticated');
    }

    await _familyCollection.doc(familyMemberId).delete();
  }

  /// Get all family members for current user
  Stream<List<FamilyMemberModel>> getFamilyMembers() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _familyCollection
        .where('userId', isEqualTo: _currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FamilyMemberModel.fromMap(doc.id, data);
      }).toList();
    });
  }

  /// Search for registered users by name
  Future<List<PersonModel>> searchUsersByName(String searchQuery) async {
    if (_currentUserId == null) {
      return [];
    }

    try {
      // Get all users from users collection (which has names)
      final usersSnapshot = await _usersCollection.get();

      List<PersonModel> matchingUsers = [];

      for (var userDoc in usersSnapshot.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userId = userDoc.id;
        final name = userData['FullName'] as String? ?? userData['name'] as String? ?? 'User ${userId.substring(0, 6)}';

        // Skip current user
        if (userId == _currentUserId) {
          continue;
        }

        // Check if name contains search query (case insensitive)
        if (name.toLowerCase().contains(searchQuery.toLowerCase())) {
          // Get status from user_status collection
          final statusDoc = await _userStatusCollection.doc(userId).get();
          final statusData = statusDoc.exists ? statusDoc.data() as Map<String, dynamic> : null;

          matchingUsers.add(PersonModel(
            id: userId,
            name: name,
            status: statusData != null ? (statusData['isSafe'] == true ? 'Safe' : 'Unsafe') : 'Unknown',
            gender: statusData?['gender'] ?? userData['gender'] ?? 'Other',
          ));
        }
      }

      return matchingUsers;
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  /// Get family members with their current status (real-time updates)
  Stream<List<PersonModel>> getFamilyMembersWithStatus() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    // First, get the current family members
    return _familyCollection
        .where('userId', isEqualTo: _currentUserId)
        .snapshots()
        .asyncMap((familySnapshot) async {
      if (familySnapshot.docs.isEmpty) {
        return [];
      }

      List<PersonModel> familyWithStatus = [];
      List<String> memberUserIds = [];

      // Collect all family member user IDs
      for (var familyDoc in familySnapshot.docs) {
        final familyData = familyDoc.data() as Map<String, dynamic>;
        final memberUserId = familyData['memberUserId'];
        if (memberUserId != null) {
          memberUserIds.add(memberUserId);
        }
      }

      if (memberUserIds.isEmpty) {
        return [];
      }

      // Get current status for all family members
      try {
        final statusQuery = await _userStatusCollection
            .where(FieldPath.documentId, whereIn: memberUserIds)
            .get();

        // Create a map of user ID to status data for quick lookup
        Map<String, Map<String, dynamic>> statusMap = {};
        for (var doc in statusQuery.docs) {
          statusMap[doc.id] = doc.data() as Map<String, dynamic>;
        }

        // Build the family members list with current status
        for (var familyDoc in familySnapshot.docs) {
          final familyData = familyDoc.data() as Map<String, dynamic>;
          final memberUserId = familyData['memberUserId'];

          if (memberUserId != null) {
            final statusData = statusMap[memberUserId];

            familyWithStatus.add(PersonModel(
              id: memberUserId,
              name: familyData['name'] ?? 'Unknown',
              status: statusData != null && statusData['isSafe'] == true ? 'Safe' : 'Unsafe',
              gender: statusData?['gender'] ?? familyData['gender'] ?? 'Other',
            ));
          }
        }
      } catch (e) {
        print('Error getting family member statuses: $e');
        // Fallback: create list with default safe status
        for (var familyDoc in familySnapshot.docs) {
          final familyData = familyDoc.data() as Map<String, dynamic>;
          final memberUserId = familyData['memberUserId'];

          if (memberUserId != null) {
            familyWithStatus.add(PersonModel(
              id: memberUserId,
              name: familyData['name'] ?? 'Unknown',
              status: 'Safe',
              gender: familyData['gender'] ?? 'Other',
            ));
          }
        }
      }

      return familyWithStatus;
    });
  }

  /// Check if a user is already a family member
  Future<bool> isFamilyMember(String memberUserId) async {
    if (_currentUserId == null) {
      return false;
    }

    try {
      final querySnapshot = await _familyCollection
          .where('userId', isEqualTo: _currentUserId)
          .where('memberUserId', isEqualTo: memberUserId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user is family member: $e');
      return false;
    }
  }

  /// Get user profile information for a specific user
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();

      if (docSnapshot.exists) {
        return docSnapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }
}