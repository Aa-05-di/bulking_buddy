import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return IntroductionScreen(
      globalBackgroundColor: const Color(0xFF141A28),
      pages: [
        PageViewModel(
          titleWidget: const SizedBox.shrink(), // remove default title
          bodyWidget: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.75, // 3/4 of screen
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/intro_welcome.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to Bulking Buddy",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Discover high-protein meals and get AI-powered workout plans tailored to your daily intake.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/intro_login.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Log In to Your Account",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Access your dashboard, track orders, and continue your fitness journey.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
            ],
          ),
        ),
        PageViewModel(
          titleWidget: const SizedBox.shrink(),
          bodyWidget: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/intro_register.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Register to Get Started",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "New here? Create an account to start buying or to become a seller yourself!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
      next: const Icon(Icons.arrow_forward, color: Color(0xFF00CBA9)),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF00CBA9))),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white24,
        activeColor: Color(0xFF00CBA9),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
