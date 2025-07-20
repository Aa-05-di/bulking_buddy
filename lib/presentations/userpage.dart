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

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                SizedBox(
                  height:
                      kToolbarHeight + MediaQuery.of(context).padding.top + 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.storefront_rounded),
                        label: const Text('Become a Seller'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 320,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
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
                      ItemCard(
                        imagePath: 'assets/bgl.jpg',
                        itemName: 'Energy Snack',
                        price: '₹149.00',
                        protein: 'Protein: 20g',
                      ),
                      ItemCard(
                        imagePath: 'assets/bgl.jpg',
                        itemName: 'Protein Shake',
                        price: '₹299.00',
                        protein: 'Protein: 40g',
                      ),
                      ItemCard(
                        imagePath: 'assets/bgl.jpg',
                        itemName: 'Oats Bar',
                        price: '₹99.00',
                        protein: 'Protein: 15g',
                      ),
                      ItemCard(
                        imagePath: 'assets/bgl.jpg',
                        itemName: 'Muscle Cookies',
                        price: '₹179.00',
                        protein: 'Protein: 18g',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.breakfast_dining_rounded,
                      color: Colors.teal,
                    ),
                    title: Text('Healthy Breakfast'),
                    subtitle: Text('Oats, Protein, & More'),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(
                      Icons.local_drink_rounded,
                      color: Colors.teal,
                    ),
                    title: Text('Smoothies'),
                    subtitle: Text('Protein shakes, Fruit blends'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
