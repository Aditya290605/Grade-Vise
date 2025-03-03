import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/firebase_options.dart';
import 'package:grade_vise/responsive_layout/responsive_screen.dart';
import 'package:grade_vise/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradeVise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
        ),
      ),
      home: AnimatedSplashScreen(
        splash: 'assets/images/splash_screen.gif',
        splashIconSize: MediaQuery.of(context).size.height,
        backgroundColor: bgColor,
        duration: 5000,
        nextScreen: const ResponsiveScreen(),
      ),
    );
  }
}
