import 'dart:async';
import 'package:first_pro/core/log.dart';
import 'package:first_pro/core/submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<Map<String, dynamic>> fontData = [
    {
      'text': 'Bulking Buddy', 
      'style': GoogleFonts.orbitron,
    },
    {
      'text': 'بولكينج بدي', 
      'style': GoogleFonts.notoKufiArabic,
    },
    {
      'text': 'பல்கிங் படி', 
      'style': GoogleFonts.kavivanar,
    },
    {
      'text': 'बलकिंग बड्डी', 
      'style': GoogleFonts.chilanka,
    },
  ];

  int currentFontIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentFontIndex = (currentFontIndex + 1) % fontData.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 200,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Text(
            fontData[currentFontIndex]['text'],
            key: ValueKey<int>(currentFontIndex),
            style: fontData[currentFontIndex]['style'](
              textStyle: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 250),
                LoginItem(
                  hinttext: "Enter Username",
                  icondata: Icons.person,
                  controller: usernameController,
                ),
                const SizedBox(height: 25),
                LoginItem(
                  hinttext: "Enter Password",
                  icondata: Icons.key,
                  controller: passwordController,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:20 ,horizontal:135 ),
                  child: Submit(data: "Login", x: 100, y: 60, colour: Colors.grey[300]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
