import 'package:disaster_relief_coordination/src/bloc/LanguageBloc.dart';
import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/view/AlertView.dart';
import 'package:disaster_relief_coordination/src/view/ReliefCenterScreen.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:disaster_relief_coordination/src/widgets/PanelWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'MyStatusView.dart';
import 'SettingView.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: context.read<LanguageBloc>().translate('home'),
          fontFamily: 'GoogleSansCode',
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: screenWidth * 0.10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PanelWidget(
                  labelKey: 'alerts_warnings',
                  svgPath: SvgHelpers.alert,
                  onTap: () {
                    print('Alerts & Warnings tapped');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AlertView();
                        },
                      ),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.05), // Spacing between panels
                PanelWidget(
                  labelKey: 'relief_centers',
                  svgPath: SvgHelpers.mapin,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const ReliefCenterScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(width: screenWidth * 0.10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PanelWidget(
                  labelKey: 'my_status',
                  svgPath: SvgHelpers.person,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const MyStatusView();
                        },
                      ),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.05), // Spacing between panels
                PanelWidget(
                  labelKey: 'settings',
                  svgPath: SvgHelpers.settings,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const SettingView();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
