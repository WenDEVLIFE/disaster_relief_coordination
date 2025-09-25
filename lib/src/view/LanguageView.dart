import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/LanguageBloc.dart';
import '../helpers/SvgHelpers.dart';
import '../services/LanguageService.dart';
import '../widgets/CustomText.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  late SupportedLanguage _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = context.read<LanguageBloc>().currentLanguage;
  }

  void _handleLanguageSelection(SupportedLanguage language) {
    setState(() {
      _selectedLanguage = language;
    });

    context.read<LanguageBloc>().add(ChangeLanguage(language));

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          text: context.read<LanguageBloc>().translate('language_changed'),
          fontFamily: 'GoogleSansCode-Regular',
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: context.read<LanguageBloc>().translate('language'),
          fontFamily: 'GoogleSansCode-Medium',
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _LanguageHeader(),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _LanguageSelectionCard(
                      selectedLanguage: _selectedLanguage,
                      onLanguageSelected: _handleLanguageSelection,
                    ),
                    const SizedBox(height: 16.0),
                    const _LanguagePreview(),
                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageHeader extends StatelessWidget {
  const _LanguageHeader();

  @override
  Widget build(BuildContext context) {
    final languageBloc = context.read<LanguageBloc>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SvgPicture.asset(
              SvgHelpers.language,
              width: 40.0,
              height: 40.0,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16.0),
          CustomText(
            text: languageBloc.translate('select_language'),
            fontFamily: 'GoogleSansCode-Bold',
            fontSize: 24.0,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          CustomText(
            text: 'Choose your preferred language for the app',
            fontFamily: 'GoogleSansCode-Regular',
            fontSize: 16.0,
            color: Colors.white70,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _LanguageSelectionCard extends StatelessWidget {
  final SupportedLanguage selectedLanguage;
  final Function(SupportedLanguage) onLanguageSelected;

  const _LanguageSelectionCard({
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final languageBloc = context.read<LanguageBloc>();
    final supportedLanguages = languageBloc.getSupportedLanguages();

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Colors.purple,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                CustomText(
                  text: languageBloc.translate('select_language'),
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ...supportedLanguages.map(
              (language) => _buildLanguageOption(
                context,
                language,
                selectedLanguage,
                onLanguageSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    SupportedLanguage language,
    SupportedLanguage selectedLanguage,
    Function(SupportedLanguage) onLanguageSelected,
  ) {
    final languageBloc = context.read<LanguageBloc>();
    final isSelected = language == selectedLanguage;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2.0 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => onLanguageSelected(language),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Language flag/icon
              Container(
                width: 40.0,
                height: 30.0,
                decoration: BoxDecoration(
                  color: _getLanguageColor(language).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: _getLanguageColor(language),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: CustomText(
                    text: _getLanguageFlag(language),
                    fontFamily: 'GoogleSansCode-Medium',
                    fontSize: 16.0,
                    color: _getLanguageColor(language),
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: language.displayName,
                      fontFamily: 'GoogleSansCode-Medium',
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 2.0),
                    CustomText(
                      text: _getLanguageNativeName(language),
                      fontFamily: 'GoogleSansCode-Regular',
                      fontSize: 14.0,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLanguageColor(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return Colors.blue;
      case SupportedLanguage.tagalog:
        return Colors.red;
      case SupportedLanguage.bisaya:
        return Colors.orange;
    }
  }

  String _getLanguageFlag(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return 'EN';
      case SupportedLanguage.tagalog:
        return 'TL';
      case SupportedLanguage.bisaya:
        return 'CB';
    }
  }

  String _getLanguageNativeName(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return 'English';
      case SupportedLanguage.tagalog:
        return 'Filipino';
      case SupportedLanguage.bisaya:
        return 'Cebuano';
    }
  }
}

class _LanguagePreview extends StatelessWidget {
  const _LanguagePreview();

  @override
  Widget build(BuildContext context) {
    final languageBloc = context.read<LanguageBloc>();

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.visibility,
                    color: Colors.green,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                CustomText(
                  text: 'Language Preview',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildPreviewItem(context, 'app_name', Icons.home, Colors.blue),
            const SizedBox(height: 12.0),
            _buildPreviewItem(context, 'settings', Icons.settings, Colors.grey),
            const SizedBox(height: 12.0),
            _buildPreviewItem(context, 'about', Icons.info, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(
    BuildContext context,
    String translationKey,
    IconData icon,
    Color color,
  ) {
    final languageBloc = context.read<LanguageBloc>();

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: color, size: 20.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: CustomText(
              text: languageBloc.translate(translationKey),
              fontFamily: 'GoogleSansCode-Regular',
              fontSize: 14.0,
              color: Colors.black87,
              fontWeight: FontWeight.normal,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
