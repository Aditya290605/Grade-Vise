import 'package:flutter/material.dart';
import 'package:grade_vise/utils/fonts.dart';

class PostContainerWidget extends StatelessWidget {
  final String userName;
  final String date;
  final String message;
  final String linkText;
  final IconData linkIcon;

  const PostContainerWidget({
    super.key,
    required this.userName,
    required this.date,
    required this.message,
    required this.linkText,
    required this.linkIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey, radius: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: dmSans,
                    ),
                  ),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: dmSans,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_vert, color: Colors.black),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: dmSans,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(linkIcon, color: Colors.black, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    linkText,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: dmSans,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
