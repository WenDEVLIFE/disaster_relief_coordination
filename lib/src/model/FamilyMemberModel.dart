class FamilyMemberModel {
  final String id;
  final String userId; // The family member's user ID
  final String name;
  final String relationship; // e.g., 'Family', 'Friend', 'Spouse', etc.
  final DateTime addedDate;
  final String? gender;

  FamilyMemberModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.relationship,
    required this.addedDate,
    this.gender,
  });

  // Copy with method for immutability
  FamilyMemberModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? relationship,
    DateTime? addedDate,
    String? gender,
  }) {
    return FamilyMemberModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      addedDate: addedDate ?? this.addedDate,
      gender: gender ?? this.gender,
    );
  }

  // Convert to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'relationship': relationship,
      'addedDate': addedDate.toIso8601String(),
      'gender': gender,
    };
  }

  // Create from Firebase document
  factory FamilyMemberModel.fromMap(String id, Map<String, dynamic> map) {
    return FamilyMemberModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? 'Family',
      addedDate: DateTime.parse(map['addedDate'] ?? DateTime.now().toIso8601String()),
      gender: map['gender'],
    );
  }
}