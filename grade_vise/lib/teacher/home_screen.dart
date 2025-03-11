import 'package:flutter/material.dart';
import 'package:grade_vise/teacher/landing_page.dart';
import 'package:grade_vise/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello Akshay",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge!.copyWith(color: Colors.white),
                  ),
                  const CircleAvatar(radius: 30),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Image.asset('assets/images/image.png'),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: ElevatedButton(
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _showCreateDialog(context); // Delayed bottom sheet
                          });
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size(MediaQuery.of(context).size.width * 0.6, 50),
                          ),
                          backgroundColor: WidgetStatePropertyAll(bgColor),
                          padding: WidgetStatePropertyAll(
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Create new",
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show animated bottom sheet dialog
  void _showCreateDialog(BuildContext context) {
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField("Classroom Name", false, context),
                  _buildTextField("Section", false, context),
                  _buildTextField("Subject", false, context),
                  _buildTextField("Password", true, context),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LandingPage(),
                          ), // Replace NewPage with your new page widget
                        );
                      },
                      child: Text(
                        "Create",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge!.copyWith(color: Colors.black),
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

  // Function to create input fields
  Widget _buildTextField(String label, bool isPassword, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
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
}
