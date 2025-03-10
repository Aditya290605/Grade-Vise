import 'package:flutter/material.dart';

showSnakbar(BuildContext context, String mesg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesg)));
}
