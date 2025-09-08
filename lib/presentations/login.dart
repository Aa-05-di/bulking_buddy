import 'dart:async';
import 'dart:ui'; // Required for BackdropFilter
import 'package:first_pro/api/api.dart';
import 'package:first_pro/presentations/register.dart';
import 'package:first_pro/presentations/userpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final List<Map<String, dynamic>> fontData = [
    // Set the size for English to be slightly smaller
    {'text': 'Bulking Buddy', 'style': GoogleFonts.orbitron, 'size': 38.0},

    // Keep the other languages at the original size
    {'text': 'بولكينج بدي', 'style': GoogleFonts.notoKufiArabic, 'size': 42.0},
    {'text': 'பல்கிங் படி', 'style': GoogleFonts.kavivanar, 'size': 42.0},
    {'text': 'बलकिंग बड्डी', 'style': GoogleFonts.chilanka, 'size': 35.0},
  ];
  int _currentFontIndex = 0;
  Timer? _titleTimer;

  // For the staggered entrance animations
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Timer for the cycling title text
    _titleTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentFontIndex = (_currentFontIndex + 1) % fontData.length;
        });
      }
    });

    // Controller for the staggered entrance animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleTimer?.cancel();
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Animation<double> _createAnimation(double begin, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              // Use a Column with Spacers for responsive layout
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  _buildTitle(),
                  const Spacer(flex: 2),
                  _buildGlassmorphicForm(),
                  const Spacer(flex: 2),
                  _buildRegisterLink(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----- THIS WIDGET HAS BEEN UPDATED -----
  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF141A28),
            Color(0xFF004D40), // Darker Teal
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Image (bgl.jpg)
          Positioned.fill(
            child: Image.asset(
              'assets/bgl.jpg',
              fit: BoxFit.cover,
              alignment: Alignment
                  .bottomCenter, // Keeps the relevant part of the image visible
              opacity: const AlwaysStoppedAnimation(0.2), // Subtle opacity
            ),
          ),
          // A subtle blur over the image to blend it more with the design
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 1.0,
                sigmaY: 2.0,
              ), // Adjust blur as needed
              child: Container(
                color: Colors.transparent, // Required to make the blur visible
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ----- END OF UPDATED WIDGET -----

  // in login.dart

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _createAnimation(0.0, 0.5),
      builder: (context, child) =>
          Opacity(opacity: _animationController.value, child: child),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Text(
          fontData[_currentFontIndex]['text'],
          key: ValueKey<int>(_currentFontIndex),
          style: fontData[_currentFontIndex]['style'](
            textStyle: TextStyle(
              fontSize: fontData[_currentFontIndex]['size'],

              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
              color: Colors.white,
              shadows: const [
                Shadow(blurRadius: 10, color: Color(0xFF00CBA9)),
                Shadow(blurRadius: 20, color: Color(0xFF00CBA9)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicForm() {
    return AnimatedBuilder(
      animation: _createAnimation(0.2, 0.8),
      builder: (context, child) => Opacity(
        opacity: _animationController.value,
        child: Transform.translate(
          offset: Offset(0, 50 * (1 - _animationController.value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: const Color(0xFF00CBA9)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF00CBA9), width: 2),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: _createAnimation(0.5, 1.0),
      builder: (context, child) => Opacity(
        opacity: _animationController.value,
        child: Transform.scale(scale: _animationController.value, child: child),
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00CBA9),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                "Log In",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return AnimatedBuilder(
      animation: _createAnimation(0.6, 1.0),
      builder: (context, child) =>
          Opacity(opacity: _animationController.value, child: child),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Not a User?", style: TextStyle(color: Colors.white70)),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Register()),
              );
            },
            child: const Text(
              "Register Now",
              style: TextStyle(
                color: Color(0xFF00CBA9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(email: user['email']),
          ),
        );
      }
      // in login.dart
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login failed: ${e.toString()}",
            ), // This shows the ugly error
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
