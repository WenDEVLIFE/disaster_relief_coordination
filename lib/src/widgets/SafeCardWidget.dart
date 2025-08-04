import 'package:flutter/material.dart';
import '../helpers/ImageHelper.dart';
import '../model/PersonModel.dart';
import 'CustomText.dart';

class SafeCardWidget extends StatelessWidget {
  final PersonModel person;

  const SafeCardWidget({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(ImageHelper.man),
        ),
        title: CustomText(
          text: person.name,
          fontFamily: 'GoogleSansCode',
          fontSize: 20,
          color: Colors.black ,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.left,
        ),
        subtitle:Row(
          children: [
            CustomText(
              text: person.status,
              fontFamily: 'GoogleSansCode',
              fontSize: 18,
              color: Colors.black ,
              fontWeight: FontWeight.w700,
              textAlign: TextAlign.left,
            ),
          ],
        )
      ),
    );
  }
}