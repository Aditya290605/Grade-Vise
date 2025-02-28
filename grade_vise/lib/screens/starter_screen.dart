import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grade_vise/teacher/home_screen.dart';
import 'package:grade_vise/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, leading: Text('')),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45),
            topLeft: Radius.circular(45),
          ),
          color: bgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const SizedBox(height: 30),
            Text(
              "What is your role ?",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: Colors.white),
            ),

            const Spacer(),

            ClipOval(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://i.pinimg.com/474x/a6/9e/db/a69edb28c7ff8521a3fb8825b56a995c.jpg",
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ).animate().scale(
              duration: Duration(milliseconds: 850),
              curve: Curves.easeInOut,
            ),
            const SizedBox(height: 10),
            Text(
              "Student",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: Colors.white),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4Bwz8-TWJNKPdLhikrDm97LAOm7OJQgCIgQ&s",
                      ),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ).animate().scale(
                duration: Duration(milliseconds: 850),
                curve: Curves.easeInOut,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Teacher",
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(color: Colors.white),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
