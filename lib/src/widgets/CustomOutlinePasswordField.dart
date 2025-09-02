import 'package:flutter/material.dart';

class CustomOutlinePassField extends StatefulWidget {
  final String hintext;
  final TextEditingController controller;

  const CustomOutlinePassField({
    super.key,
    required this.hintext,
    required this.controller,
  });

  @override
  State<CustomOutlinePassField> createState() => _CustomOutlinePassFieldState();
}

class _CustomOutlinePassFieldState extends State<CustomOutlinePassField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.hintext,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
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
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}