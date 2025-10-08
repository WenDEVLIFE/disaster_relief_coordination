import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomOutlineTextField extends StatelessWidget {
  final String hintext;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final Function(String)? onChanged;

  const CustomOutlineTextField({
    super.key,
    required this.hintext,
    required this.controller,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: hintext, // Use labelText for floating effect
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 5.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 5.0,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }
}