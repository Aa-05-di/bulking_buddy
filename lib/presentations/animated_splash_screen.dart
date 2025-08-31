import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_page.dart'; // Import your onboarding page
import 'login.dart'; // Import your login page

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // The listener that triggers navigation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });
  }

  // ----- THIS FUNCTION HAS BEEN UPDATED FOR ROBUSTNESS -----
  Future<void> _navigateToNextScreen() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // --- ADDED SAFETY CHECK ---
      // Check if the widget is still on screen before navigating
      if (!mounted) return;

      final bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => hasSeenIntro ? const Login() : const OnboardingPage(),
        ),
      );
    } catch (e) {
      // --- ADDED ERROR HANDLING ---
      // If something goes wrong, we'll now see it in the debug console
      print("Error navigating from splash screen: $e");
      // As a fallback, navigate to the login page so the user isn't stuck
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Login()),
        );
      }
    }
  }
  // ----- END OF UPDATED SECTION -----

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              'assets/splash.png',
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }
}