import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grade_vise/teacher/home_screen.dart';
import 'package:grade_vise/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
        title: Text(
          "Select Your Role",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45),
            topLeft: Radius.circular(45),
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFF293241),
              Color.fromARGB(255, 51, 62, 72),
              Color.fromARGB(255, 107, 119, 131),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              "What is your role?",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ).animate().fade(duration: 500.ms),

            const Spacer(),

            RoleCard(
              imageUrl:
                  "https://i.pinimg.com/474x/a6/9e/db/a69edb28c7ff8521a3fb8825b56a995c.jpg",
              label: "Student",
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: RoleCard(
                imageUrl:
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Bwz8-TWJNKPdLhikrDm97LAOm7OJQgCIgQ&s",
                label: "Teacher",
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String imageUrl;
  final String label;

  const RoleCard({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.width * 0.38,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: ClipOval(child: Image.network(imageUrl, fit: BoxFit.cover)),
          ),
        ).animate().scale(
          duration: Duration(milliseconds: 850),
          curve: Curves.easeInOut,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ).animate().fade(duration: 600.ms),
      ],
    );
  }
}
