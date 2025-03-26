import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/firebase_options.dart';
import 'package:grade_vise/responsive_layout/responsive_screen.dart';
import 'package:grade_vise/services/firebase_auth_methods.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Background notification handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupFCM();
  }

  void setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request notification permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    User? user = FirebaseAuth.instance.currentUser;

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Notifications permission granted!");

      // Get FCM Token and save to Firestore
      String? token = await messaging.getToken();
      print("FCM Token: $token");

      // Save token to Firestore

      if (user != null && token != null) {
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fcmToken': token,
        });
      }
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'fcmToken': newToken,
      });
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("New notification: ${message.notification!.title}");
      }
    });

    // Handle notification clicks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey('meet_link')) {
        String meetLink = message.data['meet_link'];
        launchMeet(meetLink);
      }
    });
  }

  void launchMeet(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not open Meet link");
    }
  }

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
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            enableFeedback: false,
          ),
          textTheme: const TextTheme(
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
