import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages in the application
enum SupportedLanguage {
  english('en', 'English'),
  tagalog('tl', 'Tagalog'),
  bisaya('ceb', 'Bisaya');

  const SupportedLanguage(this.code, this.displayName);

  final String code;
  final String displayName;
}

/// Service for managing application language and translations
class LanguageService {
  static const String _languageKey = 'selected_language';
  static const SupportedLanguage _defaultLanguage = SupportedLanguage.english;

  late SupportedLanguage _currentLanguage;
  late Map<String, String> _currentTranslations;

  /// Initialize the language service
  Future<void> initialize() async {
    _currentLanguage = await _getSavedLanguage() ?? _defaultLanguage;
    _currentTranslations = _getTranslationsForLanguage(_currentLanguage);
  }

  /// Get the current selected language
  SupportedLanguage get currentLanguage => _currentLanguage;

  /// Get translation for a given key
  String translate(String key) {
    return _currentTranslations[key] ?? key;
  }

  /// Change the current language
  Future<void> changeLanguage(SupportedLanguage language) async {
    _currentLanguage = language;
    _currentTranslations = _getTranslationsForLanguage(language);
    await _saveLanguage(language);
  }

  /// Get all supported languages
  List<SupportedLanguage> getSupportedLanguages() {
    return SupportedLanguage.values;
  }

  /// Get saved language from shared preferences
  Future<SupportedLanguage?> _getSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        return SupportedLanguage.values.firstWhere(
          (lang) => lang.code == languageCode,
          orElse: () => _defaultLanguage,
        );
      }
    } catch (e) {
      // Return null if there's an error reading preferences
    }
    return null;
  }

  /// Save language to shared preferences
  Future<void> _saveLanguage(SupportedLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.code);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Get translations for a specific language
  Map<String, String> _getTranslationsForLanguage(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return _englishTranslations;
      case SupportedLanguage.tagalog:
        return _tagalogTranslations;
      case SupportedLanguage.bisaya:
        return _bisayaTranslations;
    }
  }

  // English translations
  static const Map<String, String> _englishTranslations = {
    // Navigation & Common
    'app_name': 'Disaster Relief Coordination',
    'home': 'Home',
    'profile': 'Profile',
    'settings': 'Settings',
    'about': 'About',
    'language': 'Language',
    'privacy_security': 'Privacy & Security',
    'emergency_contacts': 'Emergency Contacts',
    'notifications': 'Notifications',
    'alerts': 'Alerts',
    'alerts_warnings': 'Alerts & Warnings',
    'relief_centers': 'Relief Centers',
    'search_relief_centers': 'Search relief centers...',
    'get_directions': 'Get Directions',
    'getting_directions_to': 'Getting directions to',
    'directions_loaded_successfully': 'Directions loaded successfully!',
    'unable_to_open_map_application': 'Unable to open map application',
    'unable_to_make_phone_call': 'Unable to make phone call. Please dial',
    'manually': 'manually.',
    'my_status': 'My Status',
    'status': 'Status',
    'safe': 'Safe',
    'unsafe': 'Unsafe',
    'unknown': 'Unknown',

    // Language Selection
    'select_language': 'Select Language',
    'language_changed': 'Language changed successfully',
    'english': 'English',
    'tagalog': 'Tagalog',
    'bisaya': 'Bisaya',

    // Profile
    'personal_information': 'Personal Information',
    'full_name': 'Full Name',
    'gender': 'Gender',
    'male': 'Male',
    'female': 'Female',
    'other': 'Other',
    'save_changes': 'Save Changes',
    'edit_profile': 'Edit Profile',
    'cancel': 'Cancel',
    'profile_details': 'Profile Details',
    'loading_profile': 'Loading profile...',
    'not_set': 'Not set',
    'enter_full_name': 'Enter your full name',
    'enter_gender': 'Enter your gender',
    'cancel_edit': 'Cancel Edit',
    'please_fill_profile_fields': 'Please fill in all fields',

    // Privacy & Security
    'privacy_security_title': 'Privacy & Security',
    'security_settings': 'Security Settings',
    'privacy_settings': 'Privacy Settings',
    'data_management': 'Data Management',
    'change_password': 'Change Password',
    'change_password_now': 'Change Password Now',
    'current_password': 'Current Password',
    'new_password': 'New Password',
    'confirm_new_password': 'Confirm New Password',
    'password_changed_successfully': 'Password changed successfully!',
    'password_change_failed': 'Failed to change password',
    'please_fill_all_fields': 'Please fill in all fields',
    'new_passwords_do_not_match': 'New passwords do not match',
    'password_must_be_8_characters':
        'Password must be at least 8 characters long',

    // Settings
    'location_tracking': 'Location Tracking',
    'allow_location_tracking':
        'Allow app to track your location for emergency services',
    'data_sharing': 'Data Sharing',
    'share_anonymous_data': 'Share anonymous usage data to improve the app',
    'analytics': 'Analytics',
    'collect_usage_analytics': 'Collect app usage analytics',
    'push_notifications': 'Push Notifications',
    'receive_emergency_notifications':
        'Receive emergency and safety notifications',
    'notifications_enabled':
        'Push notifications enabled. You will receive emergency alerts and safety updates.',
    'notifications_disabled':
        'Push notifications disabled. You will not receive emergency alerts.',

    // About
    'about_title': 'About',
    'app_information': 'App Information',
    'version': 'Version',
    'build_number': 'Build Number',
    'release_date': 'Release Date',
    'key_features': 'Key Features',
    'emergency_alerts': 'Emergency Alerts',
    'emergency_alerts_desc': 'Real-time disaster alerts and notifications',
    'profile_management': 'Profile Management',
    'profile_management_desc': 'Personal information and safety status',
    'location_services': 'Location Services',
    'location_services_desc': 'Interactive maps and location tracking',
    'notifications_desc': 'Instant updates and emergency broadcasts',
    'emergency_response_safety': 'Emergency Response & Safety Management',
    'developer': 'Developer',
    'supernova_corp': 'Supernova Corp',
    'building_technology': 'Building technology for a safer world',
    'contact_us': 'Contact Us',
    'email': 'Email',
    'website': 'Website',
    'support': 'Support',
    'support_email': 'support@supernovacorp.com',
    'company_website': 'www.supernovacorp.com',
    'support_24_7': 'Available 24/7',

    // Notifications
    'clear_all': 'Clear All',
    'mark_all_read': 'Mark All Read',
    'loading_notifications': 'Loading notifications...',
    'no_notifications_yet': 'No notifications yet',
    'tap_add_sample': 'Tap the + button to add a sample notification',
    'error_loading_notifications': 'Error loading notifications',
    'all_notifications_cleared': 'All notifications cleared',
    'all_notifications_marked_read': 'All notifications marked as read',

    // Common Actions
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'confirm': 'Confirm',
    'delete': 'Delete',
    'edit': 'Edit',
    'view': 'View',
    'close': 'Close',
    'back': 'Back',
    'next': 'Next',
    'previous': 'Previous',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
    'information': 'Information',
    'logout': 'Logout',
    'logout_confirmation': 'Are you sure you want to logout?',
  };

  // Tagalog translations
  static const Map<String, String> _tagalogTranslations = {
    // Navigation & Common
    'app_name': 'Koordinasyon ng Tulong sa Sakuna',
    'home': 'Home',
    'profile': 'Profile',
    'settings': 'Mga Setting',
    'about': 'Tungkol Sa',
    'language': 'Wika',
    'privacy_security': 'Pagkapribado at Seguridad',
    'emergency_contacts': 'Mga Emergency Contact',
    'notifications': 'Mga Abiso',
    'alerts': 'Mga Alerto',
    'alerts_warnings': 'Mga Alerto at Babala',
    'relief_centers': 'Mga Sentro ng Tulong',
    'search_relief_centers': 'Maghanap ng mga sentro ng tulong...',
    'get_directions': 'Kumuha ng Direksyon',
    'getting_directions_to': 'Kumuha ng direksyon papunta sa',
    'directions_loaded_successfully':
        'Matagumpay na na-load ang mga direksyon!',
    'unable_to_open_map_application': 'Hindi mabuksan ang application ng mapa',
    'unable_to_make_phone_call': 'Hindi makatawag. Mangyaring i-dial ang',
    'manually': 'manu-mano.',
    'my_status': 'Aking Katayuan',
    'status': 'Katayuan',
    'safe': 'Ligtas',
    'unsafe': 'Hindi Ligtas',
    'unknown': 'Hindi Alam',

    // Language Selection
    'select_language': 'Pumili ng Wika',
    'language_changed': 'Matagumpay na nabago ang wika',
    'english': 'Ingles',
    'tagalog': 'Tagalog',
    'bisaya': 'Bisaya',

    // Profile
    'personal_information': 'Personal na Impormasyon',
    'full_name': 'Buong Pangalan',
    'gender': 'Kasarian',
    'male': 'Lalaki',
    'female': 'Babae',
    'other': 'Iba',
    'save_changes': 'I-save ang mga Pagbabago',
    'edit_profile': 'I-edit ang Profile',
    'cancel': 'Kanselahin',
    'profile_details': 'Mga Detalye ng Profile',
    'loading_profile': 'Naglo-load ng profile...',
    'not_set': 'Hindi nakatakda',
    'enter_full_name': 'Ilagay ang iyong buong pangalan',
    'enter_gender': 'Ilagay ang iyong kasarian',
    'cancel_edit': 'Kanselahin ang Pag-edit',
    'please_fill_profile_fields': 'Mangyaring punan ang lahat ng mga patlang',

    // Privacy & Security
    'privacy_security_title': 'Pagkapribado at Seguridad',
    'security_settings': 'Mga Setting ng Seguridad',
    'privacy_settings': 'Mga Setting ng Pagkapribado',
    'data_management': 'Pamamahala ng Data',
    'change_password': 'Baguhin ang Password',
    'change_password_now': 'Baguhin ang Password Ngayon',
    'current_password': 'Kasalukuyang Password',
    'new_password': 'Bagong Password',
    'confirm_new_password': 'Kumpirmahin ang Bagong Password',
    'password_changed_successfully': 'Matagumpay na nabago ang password!',
    'password_change_failed': 'Nabigo ang pagbabago ng password',
    'please_fill_all_fields': 'Mangyaring punan ang lahat ng mga patlang',
    'new_passwords_do_not_match': 'Ang mga bagong password ay hindi magkatugma',
    'password_must_be_8_characters':
        'Ang password ay dapat na hindi bababa sa 8 karakter',

    // Settings
    'location_tracking': 'Pagsubaybay sa Lokasyon',
    'allow_location_tracking':
        'Payagan ang app na subaybayan ang iyong lokasyon para sa mga serbisyong pang-emergency',
    'data_sharing': 'Pagbabahagi ng Data',
    'share_anonymous_data':
        'Magbahagi ng anonymous na data ng paggamit upang mapabuti ang app',
    'analytics': 'Analytics',
    'collect_usage_analytics': 'Mangolekta ng analytics ng paggamit ng app',
    'push_notifications': 'Push Notifications',
    'receive_emergency_notifications':
        'Tumanggap ng mga abiso sa emergency at kaligtasan',
    'notifications_enabled':
        'Ang push notifications ay pinagana. Makakatanggap ka ng mga alerto sa emergency at mga update sa kaligtasan.',
    'notifications_disabled':
        'Ang push notifications ay hindi pinagana. Hindi ka makakatanggap ng mga alerto sa emergency.',

    // About
    'about_title': 'Tungkol Sa',
    'app_information': 'Impormasyon ng App',
    'version': 'Bersyon',
    'build_number': 'Build Number',
    'release_date': 'Petsa ng Paglabas',
    'key_features': 'Mga Pangunahing Tampok',
    'emergency_alerts': 'Mga Alerto sa Emergency',
    'emergency_alerts_desc': 'Real-time na mga alerto at abiso sa sakuna',
    'profile_management': 'Pamamahala ng Profile',
    'profile_management_desc':
        'Personal na impormasyon at katayuan ng kaligtasan',
    'location_services': 'Mga Serbisyo sa Lokasyon',
    'location_services_desc':
        'Interactive na mga mapa at pagsubaybay sa lokasyon',
    'notifications_desc': 'Instant na mga update at emergency broadcast',
    'emergency_response_safety':
        'Emergency Response at Pamamahala ng Kaligtasan',
    'developer': 'Developer',
    'supernova_corp': 'Supernova Corp',
    'building_technology': 'Bumubuo ng teknolohiya para sa mas ligtas na mundo',
    'contact_us': 'Makipag-ugnayan Sa Amin',
    'email': 'Email',
    'website': 'Website',
    'support': 'Suporta',
    'support_email': 'support@supernovacorp.com',
    'company_website': 'www.supernovacorp.com',
    'support_24_7': 'Available 24/7',

    // Common Actions
    'ok': 'OK',
    'yes': 'Oo',
    'no': 'Hindi',
    'confirm': 'Kumpirmahin',
    'delete': 'Burahin',
    'edit': 'I-edit',
    'view': 'Tingnan',
    'close': 'Isara',
    'back': 'Bumalik',
    'next': 'Susunod',
    'previous': 'Nakaraan',
    'loading': 'Nilo-load...',
    'error': 'Error',
    'success': 'Tagumpay',
    'warning': 'Babala',
    'information': 'Impormasyon',
    'logout': 'Logout',
    'logout_confirmation': 'Sigurado ka bang gusto mong mag-logout?',
  };

  // Bisaya (Cebuano) translations
  static const Map<String, String> _bisayaTranslations = {
    // Navigation & Common
    'app_name': 'Koordinasyon sa Tabang sa Kalamidad',
    'home': 'Balay',
    'profile': 'Profile',
    'settings': 'Mga Setting',
    'about': 'Mahitungod Sa',
    'language': 'Pinulongan',
    'privacy_security': 'Pagkapribado ug Seguridad',
    'emergency_contacts': 'Mga Emergency Contact',
    'notifications': 'Mga Notipikasyon',
    'alerts': 'Mga Alerto',
    'alerts_warnings': 'Mga Alerto ug Mga Pahimangno',
    'relief_centers': 'Mga Sentro sa Tabang',
    'search_relief_centers': 'Pangitaa ang mga sentro sa tabang...',
    'get_directions': 'Kuhaa ang Direksyon',
    'getting_directions_to': 'Naga-kuha og direksyon paingon sa',
    'directions_loaded_successfully': 'Malamposong na-load ang mga direksyon!',
    'unable_to_open_map_application': 'Dili mabukas ang application sa mapa',
    'unable_to_make_phone_call': 'Dili makatawag. Palihug i-dial ang',
    'manually': 'manu-mano.',
    'my_status': 'Akong Kahimtang',
    'status': 'Kahimtang',
    'safe': 'Luwas',
    'unsafe': 'Dili Luwas',
    'unknown': 'Wala Mailhi',

    // Language Selection
    'select_language': 'Pilia ang Pinulongan',
    'language_changed': 'Malamposong nabag-o ang pinulongan',
    'english': 'Iningles',
    'tagalog': 'Tagalog',
    'bisaya': 'Bisaya',

    // Profile
    'personal_information': 'Personal nga Impormasyon',
    'full_name': 'Bug-os nga Ngalan',
    'gender': 'Gender',
    'male': 'Lalaki',
    'female': 'Babae',
    'other': 'Uban Pa',
    'save_changes': 'I-save ang mga Kausaban',
    'edit_profile': 'I-edit ang Profile',
    'cancel': 'Kanselahin',
    'profile_details': 'Mga Detalye sa Profile',
    'loading_profile': 'Naga-load sa profile...',
    'not_set': 'Wala matakda',
    'enter_full_name': 'Isulod ang imong bug-os nga ngalan',
    'enter_gender': 'Isulod ang imong gender',
    'cancel_edit': 'Kanselahin ang Pag-edit',
    'please_fill_profile_fields': 'Palihug pun-a ang tanang mga natad',

    // Privacy & Security
    'privacy_security_title': 'Pagkapribado ug Seguridad',
    'security_settings': 'Mga Setting sa Seguridad',
    'privacy_settings': 'Mga Setting sa Pagkapribado',
    'data_management': 'Pagdumala sa Data',
    'change_password': 'Usba ang Password',
    'change_password_now': 'Usba ang Password Karon',
    'current_password': 'Kasamtangang Password',
    'new_password': 'Bag-ong Password',
    'confirm_new_password': 'Kumpirmahi ang Bag-ong Password',
    'password_changed_successfully': 'Malamposong nabag-o ang password!',
    'password_change_failed': 'Napakyas ang pag-usba sa password',
    'please_fill_all_fields': 'Palihug pun-a ang tanang mga natad',
    'new_passwords_do_not_match': 'Ang mga bag-ong password dili magkatugma',
    'password_must_be_8_characters':
        'Ang password kinahanglan labing menos 8 ka mga karakter',

    // Settings
    'location_tracking': 'Pagsubay sa Lokasyon',
    'allow_location_tracking':
        'Tugoti ang app nga mosubay sa imong lokasyon alang sa mga serbisyo sa emergency',
    'data_sharing': 'Pagbahagi sa Data',
    'share_anonymous_data':
        'Magbahagi sa anonymous nga datos sa paggamit aron mapauswag ang app',
    'analytics': 'Analytics',
    'collect_usage_analytics': 'Mangolekta sa analytics sa paggamit sa app',
    'push_notifications': 'Push Notifications',
    'receive_emergency_notifications':
        'Modawat sa mga notipikasyon sa emergency ug kaluwasan',
    'notifications_enabled':
        'Ang push notifications gipagana. Makadawat ka sa mga alerto sa emergency ug mga update sa kaluwasan.',
    'notifications_disabled':
        'Ang push notifications wala gipagana. Dili ka makadawat sa mga alerto sa emergency.',

    // About
    'about_title': 'Mahitungod Sa',
    'app_information': 'Impormasyon sa App',
    'version': 'Bersyon',
    'build_number': 'Build Number',
    'release_date': 'Petsa sa Pagpagawas',
    'key_features': 'Mga Pangunang Feature',
    'emergency_alerts': 'Mga Alerto sa Emergency',
    'emergency_alerts_desc':
        'Real-time nga mga alerto ug notipikasyon sa kalamidad',
    'profile_management': 'Pagdumala sa Profile',
    'profile_management_desc':
        'Personal nga impormasyon ug kahimtang sa kaluwasan',
    'location_services': 'Mga Serbisyo sa Lokasyon',
    'location_services_desc':
        'Interactive nga mga mapa ug pagsubay sa lokasyon',
    'notifications_desc': 'Instant nga mga update ug emergency broadcast',
    'emergency_response_safety': 'Emergency Response ug Safety Management',
    'developer': 'Developer',
    'supernova_corp': 'Supernova Corp',
    'building_technology':
        'Nagatukod og teknolohiya alang sa mas luwas nga kalibotan',
    'contact_us': 'Kontaka Kami',
    'email': 'Email',
    'website': 'Website',
    'support': 'Suporta',
    'support_email': 'support@supernovacorp.com',
    'company_website': 'www.supernovacorp.com',
    'support_24_7': 'Available 24/7',

    // Common Actions
    'ok': 'OK',
    'yes': 'Oo',
    'no': 'Dili',
    'confirm': 'Kumpirmahi',
    'delete': 'Buraha',
    'edit': 'I-edit',
    'view': 'Tan-awa',
    'close': 'Sirad-an',
    'back': 'Balik',
    'next': 'Sunod',
    'previous': 'Miaging',
    'loading': 'Naga-load...',
    'error': 'Sayop',
    'success': 'Malamposon',
    'warning': 'Pahimangno',
    'information': 'Impormasyon',
    'logout': 'Logout',
    'logout_confirmation': 'Sigurado ka bang gusto nimong mag-logout?',
  };
}
