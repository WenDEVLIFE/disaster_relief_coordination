import 'package:disaster_relief_coordination/src/model/EmergencyContactModel.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmergencyContactView extends StatelessWidget {
  EmergencyContactView({Key? key}) : super(key: key);

  // Emergency contact data
  final List<EmergencyContactModel> emergencyContacts = [
    EmergencyContactModel(
      id: '1',
      name: 'Emergency Services',
      phoneNumber: '911',
      description: 'General Emergency',
    ),
    EmergencyContactModel(
      id: '2',
      name: 'Police Department',
      phoneNumber: '117',
      description: 'Police Emergency',
    ),
    EmergencyContactModel(
      id: '3',
      name: 'Fire Department',
      phoneNumber: '118',
      description: 'Fire Emergency',
    ),
    EmergencyContactModel(
      id: '4',
      name: 'Medical Emergency',
      phoneNumber: '119',
      description: 'Ambulance Services',
    ),
    EmergencyContactModel(
      id: '5',
      name: 'Disaster Hotline',
      phoneNumber: '112',
      description: 'National Disaster Response',
    ),
    EmergencyContactModel(
      id: '6',
      name: 'Coast Guard',
      phoneNumber: '120',
      description: 'Maritime Emergency',
    ),
  ];

  // Function to launch phone dialer
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      // First try to launch the URL
      bool launched = await launchUrl(
        phoneUri,
        mode: LaunchMode
            .externalApplication, // This works better on both platforms
      );

      if (!launched) {
        // Fallback: try platform-specific approach
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          throw 'Could not launch phone dialer';
        }
      }
    } catch (e) {
      print('Error launching phone call: $e');
      // Show error message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to make phone call. Please dial $phoneNumber manually.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: 'Emergency Contacts',
          fontFamily: 'GoogleSansCode',
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: emergencyContacts.length,
          itemBuilder: (context, index) {
            final contact = emergencyContacts[index];
            return Container(
              margin: EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF0476D0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    FontAwesomeIcons.phone,
                    color: Color(0xFF0476D0),
                    size: 24,
                  ),
                ),
                title: CustomText(
                  text: contact.name,
                  fontFamily: 'GoogleSansCode',
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    CustomText(
                      text: contact.phoneNumber,
                      fontFamily: 'GoogleSansCode',
                      fontSize: 16,
                      color: Color(0xFF0476D0),
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 2),
                    CustomText(
                      text: contact.description,
                      fontFamily: 'GoogleSansCode',
                      fontSize: 14,
                      color: Colors.grey[600]!,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                trailing: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF0476D0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () =>
                        _makePhoneCall(context, contact.phoneNumber),
                    icon: Icon(Icons.call, color: Colors.white, size: 20),
                    padding: EdgeInsets.zero,
                  ),
                ),
                onTap: () => _makePhoneCall(context, contact.phoneNumber),
              ),
            );
          },
        ),
      ),
    );
  }
}
