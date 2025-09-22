import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/model/AlertModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/ColorHelpers.dart';
import '../helpers/ImageHelper.dart';
import 'CustomText.dart';

class AlertCard extends StatelessWidget {
  final AlertModel alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: SvgPicture.asset(
          _getDisasterIcon(alert.disasterType),
          width: screenWidth * 0.01,
          height: screenHeight * 0.04,
          colorFilter: ColorFilter.mode(
            _getDisasterColor(alert.disasterType),
            BlendMode.srcIn,
          ),
        ),
        title: CustomText(
          text: alert.alertname,
          fontFamily: 'GoogleSansCode',
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.left,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: alert.timestamp,
              fontFamily: 'GoogleSansCode',
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        trailing: CustomText(
          text: alert.address,
          fontFamily: 'GoogleSansCode',
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  String _getDisasterIcon(String disasterType) {
    switch (disasterType.toLowerCase()) {
      case 'typhoon':
      case 'tropical storm':
        return SvgHelpers.thunderstorm;
      case 'flood':
      case 'flash flood':
        return SvgHelpers.rain;
      case 'earthquake':
        return SvgHelpers.privacy; // Using earthlock as earthquake icon
      case 'volcanic activity':
        return SvgHelpers.construction; // Using construction as volcano icon
      case 'tornado':
        return SvgHelpers.thunderstorm; // Using thunderstorm as tornado icon
      default:
        return SvgHelpers.alert; // Default alert icon
    }
  }

  Color _getDisasterColor(String disasterType) {
    switch (disasterType.toLowerCase()) {
      case 'typhoon':
      case 'tropical storm':
        return Colors.orange;
      case 'flood':
      case 'flash flood':
        return Colors.blue;
      case 'earthquake':
        return Colors.brown;
      case 'volcanic activity':
        return Colors.red;
      case 'tornado':
        return Colors.purple;
      default:
        return ColorHelpers.primaryColor;
    }
  }
}
