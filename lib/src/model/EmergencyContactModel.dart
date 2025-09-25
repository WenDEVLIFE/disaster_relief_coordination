class EmergencyContactModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String description;

  const EmergencyContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.description,
  });

  // Copy with method for immutability
  EmergencyContactModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? description,
  }) {
    return EmergencyContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      description: description ?? this.description,
    );
  }
}
