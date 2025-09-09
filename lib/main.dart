import 'package:first_pro/presentations/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // This setup ensures that your app is initialized correctly.
  WidgetsFlutterBinding.ensureInitialized();
  
  // This locks the app to portrait mode only.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bulking Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF141A28),
      ),
      // The app will ALWAYS start with your animation.
      home: const AnimatedSplashScreen(),
    );
  }
}

