import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/LanguageBloc.dart';
import '../bloc/ProfileBloc.dart';
import '../model/PersonModel.dart';
import '../widgets/CustomText.dart';
import '../widgets/CustomOutlineTextField.dart';

enum Gender { male, female }

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _genderController;
  Gender? selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _genderController = TextEditingController();
    // Load profile data when view is initialized
    context.read<ProfileBloc>().add(const LoadProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  void _updateControllers(PersonModel? profile) {
    if (profile != null) {
      _nameController.text = profile.name;
      _genderController.text = profile.gender;

      // Set the selected gender for radio buttons
      if (profile.gender.toLowerCase() == 'male') {
        selectedGender = Gender.male;
      } else if (profile.gender.toLowerCase() == 'female') {
        selectedGender = Gender.female;
      } else {
        selectedGender = null;
      }
    }
  }

  void _handleEditToggle() {
    context.read<ProfileBloc>().add(const ToggleEditMode());
  }

  void _handleSaveProfile() {
    final name = _nameController.text.trim();

    if (name.isNotEmpty && selectedGender != null) {
      final genderString = selectedGender == Gender.male ? 'Male' : 'Female';
      context.read<ProfileBloc>().add(
        UpdateProfile(name: name, gender: genderString),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.read<LanguageBloc>().translate(
              'please_fill_profile_fields',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: context.read<LanguageBloc>().translate('profile'),
          fontFamily: 'GoogleSansCode-Medium',
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (!state.isLoading && state.profile != null) {
            _updateControllers(state.profile);
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.profile == null) {
            return _LoadingView();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ProfileHeader(),
                const SizedBox(height: 32.0),
                _ProfileInfoCard(
                  profile: state.profile,
                  isEditing: state.isEditing,
                  nameController: _nameController,
                  genderController: _genderController,
                  selectedGender: selectedGender,
                  onGenderChanged: (gender) {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                  onEditToggle: _handleEditToggle,
                  onSave: _handleSaveProfile,
                ),
                const SizedBox(height: 24.0),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16.0),
          CustomText(
            text: context.read<LanguageBloc>().translate('loading_profile'),
            fontFamily: 'GoogleSansCode-Regular',
            fontSize: 16.0,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.person, size: 50.0, color: Colors.blue),
          ),
          const SizedBox(height: 16.0),
          CustomText(
            text: context.read<LanguageBloc>().translate(
              'personal_information',
            ),
            fontFamily: 'GoogleSansCode-Medium',
            fontSize: 18.0,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final PersonModel? profile;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController genderController;
  final Gender? selectedGender;
  final Function(Gender?) onGenderChanged;
  final VoidCallback onEditToggle;
  final VoidCallback onSave;

  const _ProfileInfoCard({
    required this.profile,
    required this.isEditing,
    required this.nameController,
    required this.genderController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.onEditToggle,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: context.read<LanguageBloc>().translate(
                    'profile_details',
                  ),
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                IconButton(
                  onPressed: onEditToggle,
                  icon: Icon(
                    isEditing ? Icons.close : Icons.edit,
                    color: Colors.blue,
                  ),
                  tooltip: isEditing
                      ? context.read<LanguageBloc>().translate('cancel_edit')
                      : context.read<LanguageBloc>().translate('edit_profile'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildNameField(context),
            const SizedBox(height: 16.0),
            _buildGenderField(context),
            if (isEditing) ...[
              const SizedBox(height: 24.0),
              _buildActionButtons(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: context.read<LanguageBloc>().translate('full_name'),
          fontFamily: 'GoogleSansCode-Medium',
          fontSize: 14.0,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8.0),
        isEditing
            ? CustomOutlineTextField(
                hintext: context.read<LanguageBloc>().translate(
                  'enter_full_name',
                ),
                controller: nameController,
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: CustomText(
                  text:
                      profile?.name ??
                      context.read<LanguageBloc>().translate('not_set'),
                  fontFamily: 'GoogleSansCode-Regular',
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.left,
                ),
              ),
      ],
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: context.read<LanguageBloc>().translate('gender'),
          fontFamily: 'GoogleSansCode-Medium',
          fontSize: 14.0,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8.0),
        isEditing
            ? Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: CustomText(
                            text: 'Male',
                            fontFamily: 'GoogleSansCode-Regular',
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          value: Gender.male,
                          groupValue: selectedGender,
                          onChanged: onGenderChanged,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<Gender>(
                          title: CustomText(
                            text: 'Female',
                            fontFamily: 'GoogleSansCode-Regular',
                            fontSize: 14.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.left,
                          ),
                          value: Gender.female,
                          groupValue: selectedGender,
                          onChanged: onGenderChanged,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: CustomText(
                  text:
                      profile?.gender ??
                      context.read<LanguageBloc>().translate('not_set'),
                  fontFamily: 'GoogleSansCode-Regular',
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.left,
                ),
              ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: CustomText(
              text: context.read<LanguageBloc>().translate('save_changes'),
              fontFamily: 'GoogleSansCode-Medium',
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
