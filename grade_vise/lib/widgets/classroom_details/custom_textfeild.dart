import 'package:flutter/material.dart';
import 'package:grade_vise/utils/fonts.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData icon;

  const CustomTextFieldWidget({
    super.key,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hintText,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.grey,
              fontFamily: dmSans,
            ),
          ),
          Icon(icon, color: Colors.white70),
        ],
      ),
    );
  }
}
