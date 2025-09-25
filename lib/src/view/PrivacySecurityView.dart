import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/PasswordChangeBloc.dart';
import '../helpers/SvgHelpers.dart';
import '../widgets/CustomText.dart';
import '../widgets/CustomOutlineTextField.dart';
import '../widgets/CustomOutlinePasswordField.dart';

class PrivacySecurityView extends StatefulWidget {
  const PrivacySecurityView({super.key});

  @override
  State<PrivacySecurityView> createState() => _PrivacySecurityViewState();
}

class _PrivacySecurityViewState extends State<PrivacySecurityView> {
  // Controllers for password change
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Settings toggles
  bool _locationTracking = true;
  bool _dataSharing = false;
  bool _analyticsEnabled = true;
  bool _notificationsEnabled = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showPasswordChangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomText(
            text: 'Change Password',
            fontFamily: 'GoogleSansCode-Medium',
            fontSize: 20.0,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOutlinePassField(
                  hintext: 'Current Password',
                  controller: _currentPasswordController,
                ),
                const SizedBox(height: 16.0),
                CustomOutlinePassField(
                  hintext: 'New Password',
                  controller: _newPasswordController,
                ),
                const SizedBox(height: 16.0),
                CustomOutlinePassField(
                  hintext: 'Confirm New Password',
                  controller: _confirmPasswordController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const CustomText(
                text: 'Cancel',
                fontFamily: 'GoogleSansCode-Medium',
                fontSize: 16.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
            BlocBuilder<PasswordChangeBloc, PasswordChangeState>(
              builder: (context, state) {
                final isLoading = state is PasswordChangeLoading;

                return ElevatedButton(
                  onPressed: isLoading ? null : _handlePasswordChange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : const CustomText(
                          text: 'Change Password',
                          fontFamily: 'GoogleSansCode-Medium',
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                        ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _handlePasswordChange() {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill in all fields');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('New passwords do not match');
      return;
    }

    if (newPassword.length < 8) {
      _showMessage('Password must be at least 8 characters long');
      return;
    }

    // Dispatch password change event to BLoC
    context.read<PasswordChangeBloc>().add(
      ChangePasswordRequested(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          text: message,
          fontFamily: 'GoogleSansCode-Regular',
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.left,
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordChangeBloc, PasswordChangeState>(
      listener: (context, state) {
        if (state is PasswordChangeSuccess) {
          // Clear the fields
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          // Show success message
          _showMessage('Password changed successfully!', isSuccess: true);

          // Close the dialog
          Navigator.of(context).pop();
        } else if (state is PasswordChangeFailure) {
          _showMessage('Failed to change password: ${state.error}');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText(
            text: 'Privacy & Security',
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
                const _HeaderSection(),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const _SecuritySection(),
                      const SizedBox(height: 16.0),
                      const _PrivacySection(),
                      const SizedBox(height: 16.0),
                      const _DataManagementSection(),
                      const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(Icons.security, size: 40.0, color: Colors.blue),
          ),
          const SizedBox(height: 16.0),
          const CustomText(
            text: 'Privacy & Security',
            fontFamily: 'GoogleSansCode-Bold',
            fontSize: 24.0,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const CustomText(
            text: 'Manage your account security and privacy settings',
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

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SvgPicture.asset(
                    SvgHelpers.privacy,
                    width: 24.0,
                    height: 24.0,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12.0),
                const CustomText(
                  text: 'Security Settings',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildSecurityItem(
              context,
              'Change Password',
              'Update your account password',
              Icons.lock,
              Colors.orange,
              () => _showPasswordChangeDialog(context),
            ),
            const SizedBox(height: 16.0),
            _buildPasswordChangeButton(context),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.0),
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
              child: Icon(icon, color: color, size: 24.0),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontFamily: 'GoogleSansCode-Medium',
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 2.0),
                  CustomText(
                    text: subtitle,
                    fontFamily: 'GoogleSansCode-Regular',
                    fontSize: 14.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  void _showPasswordChangeDialog(BuildContext context) {
    // Get the parent state and call its password change dialog
    final parentState = context
        .findAncestorStateOfType<_PrivacySecurityViewState>();
    if (parentState != null) {
      parentState._showPasswordChangeDialog();
    }
  }

  Widget _buildPasswordChangeButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showPasswordChangeDialog(context),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_open, color: Colors.white, size: 24.0),
              const SizedBox(width: 12.0),
              const CustomText(
                text: 'Change Password Now',
                fontFamily: 'GoogleSansCode-Medium',
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 8.0),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 18.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacySection extends StatefulWidget {
  const _PrivacySection();

  @override
  State<_PrivacySection> createState() => _PrivacySectionState();
}

class _PrivacySectionState extends State<_PrivacySection> {
  bool _locationTracking = true;
  bool _dataSharing = false;
  bool _analyticsEnabled = true;
  bool _notificationsEnabled = true;

  void _handleNotificationToggle(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });

    // Show appropriate message based on the toggle state
    if (value) {
      _showMessage(
        'Push notifications enabled. You will receive emergency alerts and safety updates.',
        isSuccess: true,
      );
    } else {
      _showMessage(
        'Push notifications disabled. You will not receive emergency alerts.',
      );
    }

    // Here you would typically integrate with your notification service
    // For example:
    // NotificationService.setNotificationsEnabled(value);
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    // Use the parent context to show the message
    if (context.findAncestorStateOfType<_PrivacySecurityViewState>() != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CustomText(
            text: message,
            fontFamily: 'GoogleSansCode-Regular',
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.left,
          ),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    Icons.privacy_tip,
                    color: Colors.green,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const CustomText(
                  text: 'Privacy Settings',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildPrivacyToggle(
              'Location Tracking',
              'Allow app to track your location for emergency services',
              _locationTracking,
              (value) => setState(() => _locationTracking = value),
            ),
            const SizedBox(height: 12.0),
            _buildPrivacyToggle(
              'Data Sharing',
              'Share anonymous usage data to improve the app',
              _dataSharing,
              (value) => setState(() => _dataSharing = value),
            ),
            const SizedBox(height: 12.0),
            _buildPrivacyToggle(
              'Analytics',
              'Collect app usage analytics',
              _analyticsEnabled,
              (value) => setState(() => _analyticsEnabled = value),
            ),
            const SizedBox(height: 12.0),
            _buildPrivacyToggle(
              'Push Notifications',
              'Receive emergency and safety notifications',
              _notificationsEnabled,
              _handleNotificationToggle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 2.0),
                CustomText(
                  text: subtitle,
                  fontFamily: 'GoogleSansCode-Regular',
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: Colors.blue),
        ],
      ),
    );
  }
}

class _DataManagementSection extends StatelessWidget {
  const _DataManagementSection();

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.data_usage,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                const CustomText(
                  text: 'Data Management',
                  fontFamily: 'GoogleSansCode-Medium',
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildDataManagementItem(
              context,
              'Delete Account',
              'Permanently delete your account',
              Icons.delete_forever,
              Colors.red,
              () => _showDeleteAccountDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataManagementItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12.0),
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
              child: Icon(icon, color: color, size: 24.0),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontFamily: 'GoogleSansCode-Medium',
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 2.0),
                  CustomText(
                    text: subtitle,
                    fontFamily: 'GoogleSansCode-Regular',
                    fontSize: 14.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(
          text: message,
          fontFamily: 'GoogleSansCode-Regular',
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          textAlign: TextAlign.left,
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomText(
            text: 'Delete Account',
            fontFamily: 'GoogleSansCode-Medium',
            fontSize: 20.0,
            color: Colors.red,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          content: const CustomText(
            text:
                'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
            fontFamily: 'GoogleSansCode-Regular',
            fontSize: 14.0,
            color: Colors.black54,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.left,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const CustomText(
                text: 'Cancel',
                fontFamily: 'GoogleSansCode-Medium',
                fontSize: 16.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showMessage(
                  context,
                  'Account deletion request submitted. You will receive a confirmation email.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const CustomText(
                text: 'Delete',
                fontFamily: 'GoogleSansCode-Medium',
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
