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
          "E-MARKET",
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            shadows: [Shadow(blurRadius: 10.0, color: Colors.black26, offset: Offset(2.0, 2.0))],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal, Colors.white, Colors.tealAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('assets/bgl.jpg', fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top + 10),
                      const SizedBox(height: 12),
                      const Text(
                        "Nearby Items",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 320,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ItemCard(
                              imagePath: "https://picsum.photos/id/237/200/300", 
                              itemName: item['itemname'] ?? 'No name',
                              price: '₹${item['price'] ?? 'N/A'}',
                              protein: 'Protein: ${item['protein'] ?? 'N/A'}',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
