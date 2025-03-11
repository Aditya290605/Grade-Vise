import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grade_vise/screens/starter_screen.dart';
import 'package:grade_vise/pages/sign_in.dart';
import 'package:grade_vise/services/firebase_auth_methods.dart';
import 'package:grade_vise/services/firestore_methods.dart';
import 'package:grade_vise/teacher/home_screen.dart';
import 'package:grade_vise/utils/colors.dart';
import 'package:grade_vise/utils/fonts.dart';
import 'package:grade_vise/utils/show_error.dart';
import 'package:grade_vise/widgets/custom_button.dart';
import 'package:grade_vise/widgets/custom_textfeild.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  // Controllers for the animations
  late AnimationController _textController;
  late AnimationController _drawerController;
  late AnimationController _contentController;

  // Animations
  late Animation<Offset> _textSlideAnimation;
  late Animation<Offset> _drawerSlideAnimation;
  late Animation<double> _contentOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Text animation controller - first animation
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Drawer animation controller - second animation
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Content animation controller - third animation
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Drawer slide animation - comes from bottom to top
    _drawerSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOut),
    );

    // Content opacity animation
    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    // Start animations in sequence
    _textController.forward().then((_) {
      _drawerController.forward().then((_) {
        _contentController.forward();
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _drawerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController fname = TextEditingController();

    final TextEditingController email = TextEditingController();
    final TextEditingController pass = TextEditingController();
    final TextEditingController confrimPass = TextEditingController();

    void getUserSignUp(String email, String pass) async {
      await FirebaseAuthMethods(
        FirebaseAuth.instance,
      ).signUpUser(context, email, pass);
    }

    void addUser(String fname, String email) {
      FirestoreMethods().createUser(
        context,
        FirebaseAuth.instance.currentUser!.uid,
        fname,
        email,
      );
    }

    void handleSignIn() async {
      User? user =
          await FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle();

      if (user != null) {
        // Only navigate after sign-in is complete
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } else {
        debugPrint("Sign-in failed!");
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Animated title with slide effect
            SlideTransition(
              position: _textSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Hello Student",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontFamily: sourceSans,
                  ),
                ),
              ),
            ),
            // Animated subtitle with slide effect
            SlideTransition(
              position: _textSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Text(
                  "Sign Up",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontFamily: sourceSans,
                  ),
                ),
              ),
            ),

            // Drawer animation coming from bottom
            Expanded(
              child: SlideTransition(
                position: _drawerSlideAnimation,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45),
                    ),
                    color: Colors.white,
                  ),
                  child: FadeTransition(
                    opacity: _contentOpacityAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            CustomTextfeild(
                              hintText: "First name",
                              isObute: false,
                              controller: fname,
                            ),

                            const SizedBox(height: 25),
                            CustomTextfeild(
                              hintText: "Email address",
                              isObute: false,
                              controller: email,
                            ),
                            const SizedBox(height: 25),
                            CustomTextfeild(
                              hintText: "Password",
                              isObute: true,
                              controller: pass,
                            ),
                            const SizedBox(height: 25),
                            CustomTextfeild(
                              hintText: "Confirm password",
                              isObute: true,
                              controller: confrimPass,
                            ),
                            const SizedBox(height: 40),
                            CustomButton(
                              isLoading: isLoading,
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });

                                if (fname.text.isEmpty ||
                                    email.text.isEmpty ||
                                    pass.text.isEmpty ||
                                    confrimPass.text.isEmpty) {
                                  showSnakbar(
                                    context,
                                    "please enter all details",
                                  );
                                } else if (pass.text != confrimPass.text) {
                                  showSnakbar(
                                    context,
                                    "password doesn't match",
                                  );
                                } else {
                                  getUserSignUp(
                                    email.text.trim(),

                                    pass.text.trim(),
                                  );

                                  addUser(fname.text.trim(), email.text.trim());

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(),
                                    ),
                                  );
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                              text: "Sign Up",
                              color: bgColor,
                            ),
                            const SizedBox(height: 20),

                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Or",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 20),

                            InkWell(
                              onTap: () {
                                handleSignIn();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      221,
                                      190,
                                      186,
                                      186,
                                    ),
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/google.png'),
                                    const SizedBox(width: 15),
                                    Text(
                                      "Continue to Google",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: sourceSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ),
                                  ),
                              child: RichText(
                                text: TextSpan(
                                  text: "Already have an account? ",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: sourceSans,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Sign In",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color: bgColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: sourceSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
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
