import 'package:flutter/material.dart';
import 'package:grade_vise/utils/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            // Animated title with slide effect
            SlideTransition(
              position: _textSlideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Hello Student",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(color: Colors.white),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium!.copyWith(color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            // Drawer animation coming from bottom
            SlideTransition(
              position: _drawerSlideAnimation,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
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
                          ),
                          const SizedBox(height: 20),
                          CustomTextfeild(
                            hintText: "Last name",
                            isObute: false,
                          ),
                          const SizedBox(height: 20),
                          CustomTextfeild(
                            hintText: "Email address",
                            isObute: false,
                          ),
                          const SizedBox(height: 20),
                          CustomTextfeild(hintText: "Password", isObute: true),
                          const SizedBox(height: 20),
                          CustomTextfeild(
                            hintText: "Confirm password",
                            isObute: true,
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            onPressed: () {},
                            text: "Sign Up",
                            color: bgColor,
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    color: bgColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
          ],
        ),
      ),
    );
  }
}
