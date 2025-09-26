class ImageHelper {
  static const String logoPath = 'assets/image/logo.png';

  static const String man = 'assets/image/man.png';
  static const String woman = 'assets/image/woman.png';

  // Method to get the appropriate icon based on gender
  static String getPersonIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return man;
      case 'female':
        return woman;
      default:
        return man; // Default to man icon for other/unspecified genders
    }
  }
}
