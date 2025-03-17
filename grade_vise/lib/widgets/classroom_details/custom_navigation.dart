import 'dart:math';

import 'package:flutter/material.dart';

class CustomNavigation extends StatefulWidget {
  final List<IconData> icons;
  int selectedIndex;
  CustomNavigation({
    super.key,
    required this.icons,
    required this.selectedIndex,
  });

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: max(360, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Stack(
        children: [
          // Animated background effect
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left:
                (MediaQuery.of(context).size.width / 4.45) *
                    widget.selectedIndex +
                30, // Move based on index
            top: 12,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                widget.icons.length,
                (index) => _buildNavItem(index, widget.icons[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int itemIndex, IconData iconData) {
    final bool isSelected = widget.selectedIndex == itemIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.selectedIndex = itemIndex;
        });
      },
      child: Container(
        width: 55, // Match background width
        height: 55,
        alignment: Alignment.center,
        child: Icon(
          iconData,
          size: 28,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
}
