import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';

import '../bloc/PersonBloc.dart';
import '../helpers/ColorHelpers.dart';
import '../model/PersonModel.dart';
import '../services/UserStatusService.dart';
import '../widgets/CustomText.dart';
import '../widgets/SafeCardWidget.dart';
import '../widgets/AddFamilyMemberDialog.dart';

class MyStatusView extends StatefulWidget {
  const MyStatusView({super.key});

  @override
  _MyStatusViewState createState() => _MyStatusViewState();
}

class _MyStatusViewState extends State<MyStatusView> {
  bool _isSafe = true;
  String _lastUpdated = 'Never';
  PersonModel? _currentUser;
  StreamSubscription<bool>? _statusSubscription;
  StreamSubscription<String>? _lastUpdatedSubscription;

  @override
  void initState() {
    super.initState();
    _loadSavedStatus();
    context.read<PersonBloc>().add(const LoadPersons());
    _setupRealTimeListeners();
  }

  void _setupRealTimeListeners() {
    try {
      final userStatusService = UserStatusService();

      // Listen to current user status changes
      _statusSubscription = userStatusService.getCurrentUserStatus().listen((
        isSafe,
      ) async {
        if (mounted) {
          setState(() {
            _isSafe = isSafe;
            _updateCurrentUserInList();
          });

          // Update last updated timestamp when status changes
          try {
            final lastUpdated = await userStatusService.getLastUpdated();
            if (mounted) {
              setState(() {
                _lastUpdated = lastUpdated;
              });
            }
          } catch (e) {
            print('Error getting last updated: $e');
          }
        }
      });
    } catch (e) {
      print('Error setting up real-time listeners: $e');
    }
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedStatus() async {
    try {
      final userStatusService = UserStatusService();
      final userStatusData = await userStatusService.getUserStatusWithGender();
      final userProfile = await userStatusService.getUserProfile();

      setState(() {
        if (userStatusData != null) {
          _isSafe = userStatusData['isSafe'] ?? true;
          _lastUpdated = userStatusData['timestamp'] != null
              ? _formatTimestamp(userStatusData['timestamp'])
              : 'Never';
        } else {
          _isSafe = true;
          _lastUpdated = 'Never';
        }

        // Update current user with gender information from user_status collection
        if (userStatusData != null && _currentUser != null) {
          final gender = userStatusData['gender'] ?? 'Other';
          _currentUser = _currentUser!.copyWith(gender: gender);
        }
      });
    } catch (e) {
      print('Error loading saved status: $e');
      // Fallback to default values if Firebase fails
      setState(() {
        _isSafe = true;
        _lastUpdated = 'Never';
      });

      // Show user-friendly error message if authentication fails
      if (e.toString().contains('not authenticated')) {
        _showAuthenticationError();
      }
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Never';
    }
  }

  Future<void> _saveStatus() async {
    try {
      final userStatusService = UserStatusService();
      // Get current user gender from the current user model
      final currentGender = _currentUser?.gender ?? 'Other';
      await userStatusService.saveUserStatus(_isSafe, gender: currentGender);

      // Update current user in the list
      setState(() {
        _lastUpdated = _getCurrentDateTime();
        _updateCurrentUserInList();
      });
    } catch (e) {
      print('Error saving status: $e');

      // Show user-friendly error message if authentication fails
      if (e.toString().contains('not authenticated')) {
        _showAuthenticationError();
      } else {
        _showErrorSnackBar('Failed to update status. Please try again.');
      }
    }
  }

  void _showAuthenticationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please log in to update your status'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _toggleStatus() async {
    // Check if user is authenticated before allowing status toggle
    try {
      final userStatusService = UserStatusService();
      await userStatusService
          .initialize(); // This will throw if not authenticated

      setState(() {
        _isSafe = !_isSafe;
      });
      _saveStatus();
    } catch (e) {
      print('Authentication check failed: $e');
      _showAuthenticationError();
    }
  }

  void _updateCurrentUserInList() async {
    try {
      final userStatusService = UserStatusService();
      final currentUserId = userStatusService.currentUserId;

      if (currentUserId == null) {
        print('Current user ID is null');
        return;
      }

      // Get user status data to get gender from user_status collection
      final userStatusData = await userStatusService.getUserStatusWithGender();
      final gender = userStatusData?['gender'] ?? 'Other';

      // Create current user if not exists
      if (_currentUser == null) {
        _currentUser = PersonModel(
          id: currentUserId,
          name: 'You',
          status: _isSafe ? 'Safe' : 'Unsafe',
          gender: gender,
        );
      } else {
        _currentUser = _currentUser!.copyWith(
          status: _isSafe ? 'Safe' : 'Unsafe',
          gender: gender,
        );
      }

      // Add current user to the list using the BLoC event
      context.read<PersonBloc>().add(AddCurrentUser(_currentUser!));
    } catch (e) {
      print('Error updating current user in list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const CustomText(
          text: 'My Status',
          fontFamily: 'GoogleSansCode',
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _toggleStatus,
              child: Container(
                decoration: BoxDecoration(
                  color: _isSafe ? ColorHelpers.safeColor : Colors.red,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.2,
                        child: Center(
                          child: SvgPicture.asset(
                            SvgHelpers.safe,
                            width: screenWidth * 0.1,
                            height: screenHeight * 0.1,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      CustomText(
                        text: _isSafe ? 'I am safe' : 'I am not safe',
                        fontFamily: 'GoogleSansCode',
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      CustomText(
                        text: 'Last updated: $_lastUpdated',
                        fontFamily: 'GoogleSansCode',
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.7,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    // Header with add family member button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: 'Family & Friends',
                          fontFamily: 'GoogleSansCode',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                            textAlign: TextAlign.left,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AddFamilyMemberDialog(),
                            );
                          },
                          icon: const Icon(Icons.person_add, color: Colors.white),
                          label: const CustomText(
                            text: 'Add',
                            fontFamily: 'GoogleSansCode',
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600, textAlign: TextAlign.left
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHelpers.safeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: BlocBuilder<PersonBloc, PersonState>(
                        builder: (context, state) {
                          if (state.people.isEmpty) {
                            return const Center(
                              child: CustomText(
                                text: 'No family members added yet.\nTap "Add" to add your first family member.',
                                fontFamily: 'GoogleSansCode',
                                fontSize: 16,
                                color: Colors.grey,
                                textAlign: TextAlign.center, fontWeight: FontWeight.w600,
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: state.people.length,
                            itemBuilder: (context, index) {
                              final person = state.people[index];
                              return SafeCardWidget(person: person);
                            },
                          );
                        },
                      ),
                    ),
                    CustomButton(
                      hintText: 'Update Status',
                      fontFamily: 'GoogleSansCode',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      onPressed: _toggleStatus,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.07,
                    ),
                    SizedBox(height: screenHeight * 0.09),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
