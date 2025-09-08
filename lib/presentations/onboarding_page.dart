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
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
      bodyTextStyle: TextStyle(fontSize: 19.0, color: Colors.white70),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Color(0xFF141A28),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Bulking Buddy",
          body: "Find the best high-protein meals and sellers right in your neighborhood.",
          // image: Image.asset('assets/intro1.png'), // Add your image here
          image: const Center(child: Icon(Icons.fitness_center, size: 150, color: Color(0xFF00CBA9))),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Sign Up & Get Started",
          body: "Create an account to start your journey. Sellers and buyers welcome!",
          // image: Image.asset('assets/intro2.png'), // Add your image here
          image: const Center(child: Icon(Icons.person_add, size: 150, color: Color(0xFF00CBA9))),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Order & Track",
          body: "Easily place orders, track their status, and communicate with sellers for a seamless experience.",
          // image: Image.asset('assets/intro3.png'), // Add your image here
          image: const Center(child: Icon(Icons.local_shipping, size: 150, color: Color(0xFF00CBA9))),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can also allow users to skip
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