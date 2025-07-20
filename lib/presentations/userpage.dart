import 'package:flutter/material.dart';
import '../core/itemcard.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black26,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal,
                  Colors.white,
                  Colors.tealAccent,
                  Colors.white,
                  Colors.teal,
                  Colors.white,
                  Colors.tealAccent,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: kToolbarHeight +
                          MediaQuery.of(context).padding.top +
                          10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ItemCard(
                          imagePath: 'assets/bgl.jpg',
                          itemName: 'Item Name',
                          price: '₹249.00',
                          protein: 'Protein: 30g',
                        ),
                        ItemCard(
                          imagePath: 'assets/bgl.jpg',
                          itemName: 'Item 2',
                          price: '₹199.00',
                          protein: 'Protein: 25g',
                        ),
                      ],
                    ),
                  ],
                ),
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
        ],
      ),
    );
  }
}
