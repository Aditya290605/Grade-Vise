import 'package:flutter/material.dart';

class CustomTextfeild extends StatelessWidget {
  final String hintText;
  final bool isObute;

  const CustomTextfeild({
    super.key,
    required this.hintText,
    required this.isObute,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObute,

      decoration: InputDecoration(
        label: Text(hintText),
        labelStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Colors.black),

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
