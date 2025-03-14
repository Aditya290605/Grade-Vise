import 'package:flutter/material.dart';

class SubjectContainer extends StatelessWidget {
  final String title;
  const SubjectContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 180,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.pink.shade200.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.shade100.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
