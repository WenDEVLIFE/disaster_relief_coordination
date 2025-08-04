import 'package:flutter/cupertino.dart';

class CircleWidget extends StatelessWidget {
  final double radius;
  final Color color;

  const CircleWidget({
    Key? key,
    required this.radius,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}