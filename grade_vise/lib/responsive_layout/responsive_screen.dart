import 'package:flutter/material.dart';
import 'package:grade_vise/screens/mobile_screen.dart';
import 'package:grade_vise/screens/web_screen.dart';
import 'package:grade_vise/utils/colors.dart';

class ResponsiveScreen extends StatelessWidget {
  const ResponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, options) {
        if (options.maxWidth > maxWidth) {
          return const WebScreen();
        }
        return const MobileScreen();
      },
    );
  }
}
