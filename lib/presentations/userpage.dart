import 'package:first_pro/api/api.dart';
import 'package:flutter/material.dart';
import '../core/itemcard.dart';

class UserPage extends StatefulWidget {
  final String email;

  const UserPage({super.key, required this.email});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final userData = await fetchProfileData(widget.email);
      setState(() {
        items = userData['nearbyItems'];
        isLoading = false;
      });
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Local Market",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                blurRadius: 6.0,
                color: Colors.black26,
                offset: Offset(1.5, 1.5),
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00897B), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Optional faded image background
          Opacity(
            opacity: 0.1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/bgl.jpg', fit: BoxFit.cover),
            ),
          ),

          // Content
          SafeArea(
  child: isLoading
      ? const Center(child: CircularProgressIndicator())
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80), // To offset from AppBar
                const Text(
                  "Nearby Items",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                items.isEmpty
                    ? const Expanded( // Use Expanded so that it takes remaining space
                        child: Center(
                          child: Text(
                            "No nearby items found.",
                            style: TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ItemCard(
                              imagePath: item['photo'] ?? '',
                              itemName: item['itemname'] ?? 'Unnamed Item',
                              price: '₹${item['price'] ?? 'N/A'}',
                              protein: 'Protein: ${item['protein'] ?? 'N/A'}',
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
)

        ],
      ),
    );
  }
}
