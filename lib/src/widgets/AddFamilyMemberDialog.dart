import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/PersonBloc.dart';
import '../helpers/ColorHelpers.dart';
import '../model/PersonModel.dart';
import '../services/FamilyService.dart';
import 'CustomButton.dart';
import 'CustomOutlineTextField.dart';
import 'CustomText.dart';

class AddFamilyMemberDialog extends StatefulWidget {
  const AddFamilyMemberDialog({super.key});

  @override
  _AddFamilyMemberDialogState createState() => _AddFamilyMemberDialogState();
}

class _AddFamilyMemberDialogState extends State<AddFamilyMemberDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final FamilyService _familyService = FamilyService();

  List<PersonModel> _searchResults = [];
  bool _isLoading = false;
  bool _isAdding = false;
  String _selectedRelationship = 'Family';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.length >= 2) {
      _searchUsers(_searchController.text);
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _familyService.searchUsersByName(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addFamilyMember(PersonModel user) async {
    if (_selectedRelationship.isEmpty) {
      _showError('Please select a relationship');
      return;
    }

    setState(() {
      _isAdding = true;
    });

    try {
      await _familyService.addFamilyMember(
        user.id,
        user.name,
        _selectedRelationship,
        gender: user.gender,
      );

      // The stream will automatically update with the new member

      Navigator.of(context).pop(); // Close dialog
      _showSuccess('Family member added or updated successfully');
    } catch (e) {
      print('Error adding family member: $e');
      _showError('Failed to add family member. Please try again.');
    } finally {
      setState(() {
        _isAdding = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Add Family Member',
              fontFamily: 'GoogleSansCode',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black,
                textAlign: TextAlign.left
            ),
            const SizedBox(height: 20),

            // Search field
            CustomOutlineTextField(
              controller: _searchController,
              hintext: 'Search by name...',
              prefixIcon: Icons.search,
              onChanged: (value) {},

            ),
            const SizedBox(height: 20),

            // Relationship dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: _selectedRelationship,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'Family', child: Text('Family')),
                  DropdownMenuItem(value: 'Friend', child: Text('Friend')),
                  DropdownMenuItem(value: 'Spouse', child: Text('Spouse')),
                  DropdownMenuItem(value: 'Parent', child: Text('Parent')),
                  DropdownMenuItem(value: 'Child', child: Text('Child')),
                  DropdownMenuItem(value: 'Sibling', child: Text('Sibling')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRelationship = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Loading indicator or search results
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _searchResults.isEmpty && _searchController.text.length >= 2
                      ? const Center(
                          child: CustomText(
                            text: 'No users found',
                            fontFamily: 'GoogleSansCode',
                            fontSize: 16,
                            color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.left
                          ),
                        )
                      : _searchController.text.length < 2
                          ? const Center(
                              child: CustomText(
                                text: 'Type at least 2 characters to search',
                                fontFamily: 'GoogleSansCode',
                                fontSize: 16,
                                color: Colors.grey,
                                  textAlign: TextAlign.left, fontWeight: FontWeight.w600,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final user = _searchResults[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: user.status == 'Safe'
                                          ? ColorHelpers.safeColor
                                          : Colors.red,
                                      child: Text(
                                        user.name.substring(0, 1).toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: CustomText(
                                      text: user.name,
                                      fontFamily: 'GoogleSansCode',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.left, color: Colors.grey,
                                    ),
                                    subtitle: CustomText(
                                      text: '${user.gender} • ${user.status}',
                                      fontFamily: 'GoogleSansCode',
                                      fontSize: 14,
                                      color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.left
                                    ),
                                    trailing: _isAdding
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: () => _addFamilyMember(user),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorHelpers.safeColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const CustomText(
                                              text: 'Add',
                                              fontFamily: 'GoogleSansCode',
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.left
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
            ),

            const SizedBox(height: 20),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAdding ? null : () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const CustomText(
                  text: 'Cancel',
                  fontFamily: 'GoogleSansCode',
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                    textAlign: TextAlign.left
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}