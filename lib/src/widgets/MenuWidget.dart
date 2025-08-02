import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItem {
  final String svgPath;
  final String title;
  MenuItem({required this.svgPath, required this.title});
}

class MenuListWidget extends StatelessWidget {
  final List<MenuItem> menuItems = [
    MenuItem(svgPath: 'assets/icons/user_info.svg', title: 'Profile'),
    MenuItem(svgPath: 'assets/icons/change_password.svg', title: 'Notifications'),
    MenuItem(svgPath: 'assets/icons/terms.svg', title: 'Privacy & Security'),
    MenuItem(svgPath: 'assets/icons/privacy.svg', title: 'Emergency Contacts'),
    MenuItem(svgPath: 'assets/icons/about.svg', title: 'Language'),
    MenuItem(svgPath: 'assets/icons/subscription.svg', title: 'About'),
    MenuItem(svgPath: 'assets/icons/logout.svg', title: 'Logout'),
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
                leading: SvgPicture.asset(
                  menuItems[index].svgPath,
                  width: 22,
                  height: 22,
                  color: Colors.black,
                ),
                title: Text(
                  menuItems[index].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  if (index == 0) {

                  } else if (index == 1) {

                  } else if (index == 2) {

                  } else if (index == 3) {

                  } else if (index == 4) {

                  } else if (index == 5) {

                  } else if (index == 6) {

                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}