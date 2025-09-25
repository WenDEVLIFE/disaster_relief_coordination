import 'package:disaster_relief_coordination/src/bloc/LanguageBloc.dart';
import 'package:disaster_relief_coordination/src/helpers/SessionHelper.dart';
import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/view/AboutView.dart';
import 'package:disaster_relief_coordination/src/view/LanguageView.dart';
import 'package:disaster_relief_coordination/src/view/LoginView.dart';
import 'package:disaster_relief_coordination/src/view/NotificationView.dart';
import 'package:disaster_relief_coordination/src/view/PrivacySecurityView.dart';
import 'package:disaster_relief_coordination/src/view/ProfileView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuItem {
  final String svgPath;
  final String titleKey;
  MenuItem({required this.svgPath, required this.titleKey});
}

class MenuListWidget extends StatelessWidget {
  MenuListWidget({super.key});

  final List<MenuItem> menuItems = [
    MenuItem(svgPath: SvgHelpers.person, titleKey: 'profile'),
    MenuItem(svgPath: SvgHelpers.notification, titleKey: 'notifications'),
    MenuItem(svgPath: SvgHelpers.privacy, titleKey: 'privacy_security'),
    MenuItem(
      svgPath: SvgHelpers.emergencyContacts,
      titleKey: 'emergency_contacts',
    ),
    MenuItem(svgPath: SvgHelpers.language, titleKey: 'language'),
    MenuItem(svgPath: SvgHelpers.aboutUs, titleKey: 'about'),
    MenuItem(svgPath: SvgHelpers.logout, titleKey: 'logout'),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                leading: SvgPicture.asset(
                  menuItems[index].svgPath,
                  width: 44,
                  height: 44,
                  colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
                title: Text(
                  context.read<LanguageBloc>().translate(
                    menuItems[index].titleKey,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'SmoochSans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 22,
                ),
                onTap: () {
                  if (menuItems[index].titleKey == 'profile') {
                    // Navigate to Profile screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileView()),
                    );
                  } else if (menuItems[index].titleKey == 'notifications') {
                    // Navigate to Notifications screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationView(),
                      ),
                    );
                  } else if (menuItems[index].titleKey == 'privacy_security') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacySecurityView(),
                      ),
                    );
                    // Navigate to Privacy & Security screen
                  } else if (menuItems[index].titleKey ==
                      'emergency_contacts') {
                    // Navigate to Emergency Contacts screen
                  } else if (menuItems[index].titleKey == 'language') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LanguageView()),
                    );
                    // Navigate to Language screen
                  } else if (menuItems[index].titleKey == 'about') {
                    // Navigate to About screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutView()),
                    );
                  }

                  if (menuItems[index].titleKey == 'logout') {
                    // Handle logout action
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            context.read<LanguageBloc>().translate('logout'),
                          ),
                          content: Text(
                            context.read<LanguageBloc>().translate(
                              'logout_confirmation',
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                context.read<LanguageBloc>().translate(
                                  'cancel',
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                context.read<LanguageBloc>().translate(
                                  'logout',
                                ),
                              ),
                              onPressed: () async {
                                // Perform logout operation here
                                Navigator.of(context).pop();
                                await SessionHelpers.clearUserInfo();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginView(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Handle other menu item taps
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${context.read<LanguageBloc>().translate(menuItems[index].titleKey)} tapped',
                        ),
                      ),
                    );
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
