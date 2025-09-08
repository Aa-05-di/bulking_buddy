import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding_page.dart';
import 'login.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  
  void _onAnimationEnd() async {
    await Future.delayed(const Duration(milliseconds: 250)); 
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => hasSeenIntro ? const Login() : const OnboardingPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Color(0xFF00CBA9),
      Colors.white,
      Colors.teal,
    ];

    final textStyle = GoogleFonts.orbitron(
      textStyle: const TextStyle(
        fontSize: 42.0,
        fontWeight: FontWeight.bold,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/bgl.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
          Center(
            
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              onFinished: _onAnimationEnd,
              
              animatedTexts: [
                
                TyperAnimatedText(
                  'Bulking Buddy',
                  textStyle: textStyle.copyWith(color: Colors.white),
                  speed: const Duration(milliseconds: 100),
                ),
                
                ColorizeAnimatedText(
                  'Bulking Buddy',
                  textStyle: textStyle,
                  colors: colorizeColors,
                  speed: const Duration(milliseconds: 120),
                ),
              ],
            ),
            
          ),
        ],
      ),
    );
  }
}