import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem {
  final String svgPath;
  final String title;
  MenuItem({required this.svgPath, required this.title});
}

class MenuListWidget extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(svgPath: SvgHelpers.person, title: 'Profile'),
    MenuItem(svgPath: SvgHelpers.notification, title: 'Notifications'),
    MenuItem(svgPath: SvgHelpers.privacy, title: 'Privacy & Security'),
    MenuItem(svgPath: SvgHelpers.emergencyContacts, title: 'Emergency Contacts'),
    MenuItem(svgPath: SvgHelpers.language, title: 'Language'),
    MenuItem(svgPath: SvgHelpers.aboutUs, title: 'About'),
    MenuItem(svgPath: SvgHelpers.logout, title: 'Logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: SvgPicture.asset(
                  menuItems[index].svgPath,
                  width: 44,
                  height: 44,
                  color: Colors.black,
                ),
                title: Text(
                  menuItems[index].title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black, size: 22),
                onTap: () {
                  // Handle taps here
                },
              );
            },
          ),
        ),
      ],
    );
  }
}