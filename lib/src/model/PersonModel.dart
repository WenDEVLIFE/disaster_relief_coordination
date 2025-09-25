class PersonModel {
  final String id;
  final String name;
  final String status;
  final String gender;

  PersonModel({
    required this.id,
    required this.name,
    required this.status,
    required this.gender,
  });

  // Copy with method for immutability
  PersonModel copyWith({
    String? id,
    String? name,
    String? status,
    String? gender,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      gender: gender ?? this.gender,
    );
  }
}
