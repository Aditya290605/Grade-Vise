import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/firebase_options.dart';
import 'package:grade_vise/responsive_layout/responsive_screen.dart';
import 'package:grade_vise/services/firebase_auth_methods.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),

        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'GradeVise',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            titleLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            titleSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            bodySmall: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
        ),
        home: AnimatedSplashScreen(
          splash: 'assets/images/splash_screen.gif',
          splashIconSize: MediaQuery.of(context).size.height,
          backgroundColor: bgColor,
          duration: 5000,
          nextScreen: const ResponsiveScreen(),
        ),
      ),
    );
  }
}
