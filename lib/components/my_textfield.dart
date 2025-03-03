import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final TextAlign textAlign;
  final int maxLength;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  const MyTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.textAlign,
    required this.maxLength,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        textAlign: textAlign,
        keyboardType: keyboardType,
        controller: controller,
        maxLength: maxLength,

        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          counterText: "",
          hintText: hintText,
        ),
      ),
    );
  }
}
