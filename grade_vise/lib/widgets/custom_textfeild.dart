import 'package:flutter/material.dart';
import 'package:grade_vise/utils/fonts.dart';

class CustomTextfeild extends StatelessWidget {
  final String hintText;
  final bool isObute;
  final TextEditingController controller;

  const CustomTextfeild({
    super.key,
    required this.hintText,
    required this.isObute,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObute,
      controller: controller,
      decoration: InputDecoration(
        label: Text(hintText),
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.black,
          fontFamily: sourceSans,
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
