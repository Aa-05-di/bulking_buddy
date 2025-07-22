import 'dart:async';
import 'package:first_pro/api/api.dart';
import 'package:first_pro/core/log.dart';
import 'package:first_pro/core/submit.dart';
import 'package:first_pro/presentations/register.dart';
import 'package:first_pro/presentations/userpage.dart';
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
    {'text': 'Bulking Buddy', 'style': GoogleFonts.orbitron},
    {'text': 'بولكينج بدي', 'style': GoogleFonts.notoKufiArabic},
    {'text': 'பல்கிங் படி', 'style': GoogleFonts.kavivanar},
    {'text': 'बलकिंग बड्डी', 'style': GoogleFonts.chilanka},
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
                fontSize: 42.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade300, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Opacity(
            opacity: 0.2,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ClipRect(
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1.3,
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/bgl.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 450),
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 135,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            final user = await loginUser(
                              email: usernameController.text,
                              password: passwordController.text,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UserPage(email: user['email']),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login failed: ${e.toString()}"),
                              ),
                            );
                          }
                        },
                        child: Submit(
                          data: "Login",
                          x: 100,
                          y: 60,
                          colour: Colors.grey[300],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 100,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: const Text(
                          "Not a User? Register Now",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
