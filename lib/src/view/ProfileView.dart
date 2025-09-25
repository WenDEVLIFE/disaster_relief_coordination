import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ProfileBloc.dart';
import '../model/PersonModel.dart';
import '../widgets/CustomText.dart';
import '../widgets/CustomOutlineTextField.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _genderController;

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
    }
  }

  void _handleEditToggle() {
    context.read<ProfileBloc>().add(const ToggleEditMode());
  }

  void _handleSaveProfile() {
    final name = _nameController.text.trim();
    final gender = _genderController.text.trim();

    if (name.isNotEmpty && gender.isNotEmpty) {
      context.read<ProfileBloc>().add(
        UpdateProfile(name: name, gender: gender),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Profile',
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
            return const _LoadingView();
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
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16.0),
          CustomText(
            text: 'Loading profile...',
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
          const CustomText(
            text: 'Personal Information',
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
  final VoidCallback onEditToggle;
  final VoidCallback onSave;

  const _ProfileInfoCard({
    required this.profile,
    required this.isEditing,
    required this.nameController,
    required this.genderController,
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
                const CustomText(
                  text: 'Profile Details',
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
                  tooltip: isEditing ? 'Cancel Edit' : 'Edit Profile',
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildNameField(),
            const SizedBox(height: 16.0),
            _buildGenderField(),
            if (isEditing) ...[
              const SizedBox(height: 24.0),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Full Name',
          fontFamily: 'GoogleSansCode-Medium',
          fontSize: 14.0,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8.0),
        isEditing
            ? CustomOutlineTextField(
                hintext: 'Enter your full name',
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
                  text: profile?.name ?? 'Not set',
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

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Gender',
          fontFamily: 'GoogleSansCode-Medium',
          fontSize: 14.0,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8.0),
        isEditing
            ? CustomOutlineTextField(
                hintext: 'Enter your gender',
                controller: genderController,
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
                  text: profile?.gender ?? 'Not set',
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

  Widget _buildActionButtons() {
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
            child: const CustomText(
              text: 'Save Changes',
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
