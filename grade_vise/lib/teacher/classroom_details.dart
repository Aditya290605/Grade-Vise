import 'package:flutter/material.dart';
import 'package:grade_vise/utils/colors.dart';

class ClassroomDetails extends StatefulWidget {
  const ClassroomDetails({super.key});

  @override
  State<ClassroomDetails> createState() => _ClassroomDetailsState();
}

class _ClassroomDetailsState extends State<ClassroomDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      "assets/images/teacher/components/more_options.png",
                    ),
                  ),
                ),

                IconButton(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.5,
                  ),
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/images/teacher/components/search.png",
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: CircleAvatar(radius: 25),
                ),
              ],
            ),

            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage("assets/images/teacher/teacher_card.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
