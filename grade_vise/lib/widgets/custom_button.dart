import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,

      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        backgroundColor: WidgetStatePropertyAll(color),
        fixedSize: WidgetStatePropertyAll(
          Size(MediaQuery.of(context).size.width, 60),
        ),
      ),

      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(color: Colors.white),
      ),
    );
  }
}
