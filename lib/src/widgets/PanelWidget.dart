import 'package:disaster_relief_coordination/src/bloc/LanguageBloc.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helpers/ColorHelpers.dart';

class PanelWidget extends StatelessWidget {
  final String labelKey;
  final String svgPath;
  final VoidCallback? onTap;

  const PanelWidget({
    super.key,
    required this.labelKey,
    required this.svgPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.44,
        height: screenHeight * 0.2,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              width: screenWidth * 0.1,
              height: screenHeight * 0.1,
              colorFilter: ColorFilter.mode(
                ColorHelpers.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            CustomText(
              text: context.read<LanguageBloc>().translate(labelKey),
              fontFamily: 'GoogleSansCode',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
