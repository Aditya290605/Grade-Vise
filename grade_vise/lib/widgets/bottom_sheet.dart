import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grade_vise/services/firestore_methods.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/utils/fonts.dart';

Widget _buildTextField(
  String label,
  bool isPassword,
  BuildContext context,
  TextEditingController controller,
) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      style: Theme.of(
        context,
      ).textTheme.bodyLarge!.copyWith(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    ),
  );
}

class BottomDailog {
  void showCreateDailog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Full-screen effect
      backgroundColor: bgColor, // Matching the main container color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(45),
        ), // Smooth rounded top
      ),
      builder: (context) {
        TextEditingController classRoom = TextEditingController();
        TextEditingController section = TextEditingController();
        TextEditingController subject = TextEditingController();
        TextEditingController room = TextEditingController();

        return AnimatedPadding(
          duration: const Duration(milliseconds: 400), // Smooth animation
          curve: Curves.easeIn, // Smooth transition
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: Container(
            height:
                MediaQuery.of(context).size.height *
                0.75, // Matching main container height
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Enter Details",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: sourceSans,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Classroom Name", false, context, classRoom),
                  _buildTextField("Section", false, context, section),
                  _buildTextField("Subject", false, context, subject),
                  _buildTextField("Password", true, context, room),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: Size(120, 50),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        FirestoreMethods().createClassroom(
                          classRoom.text.trim(),
                          section.text.trim(),
                          subject.text.trim(),
                          room.text.trim(),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Create",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                          fontFamily: sourceSans,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
