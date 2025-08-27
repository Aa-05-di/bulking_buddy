import 'package:flutter/material.dart';
import 'package:first_pro/api/api.dart';
import 'package:first_pro/presentations/cart.dart';
import 'package:first_pro/presentations/seller.dart';
import 'package:first_pro/presentations/login.dart';
import '../core/itemcard.dart';

class UserPage extends StatefulWidget {
  final String email;

  const UserPage({super.key, required this.email});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<dynamic> items = [];
  List<dynamic> cart = [];
  bool isLoading = true;
  String userName = '';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final userData = await fetchProfileData(widget.email);
      setState(() {
        items = userData['nearbyItems'] ?? [];
        userName = userData['name'] ?? 'User';
        isLoading = false;
      });
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  void addToCart(dynamic product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['itemname']} added to cart!'),
        backgroundColor: const Color(0xFF00897B),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Cart()),
    );
  }

  void becomeSeller() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Seller()),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: Color(0xFF00897B)),
              SizedBox(width: 8),
              Text('My Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text('Log Out'),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'logout') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> filteredItems = items.where((item) {
      final itemName = item['itemname']?.toLowerCase() ?? '';
      return itemName.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: becomeSeller,
        label: const Text(
          "Become a Seller",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.store, color: Colors.white),
        backgroundColor: const Color(0xFF00897B),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF00897B)))
              : RefreshIndicator(
                  onRefresh: loadUserData,
                  color: const Color(0xFF00897B),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: _buildSearchBar(),
                        ),
                        const SizedBox(height: 20),
                        _buildNearbyItemsSection(filteredItems),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: const BoxDecoration(
        color: Color(0xFF00897B),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${widget.email.split('@')[0]} 👋",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Find the best products nearby!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
                        onPressed: goToCartPage,
                      ),
                      if (cart.isNotEmpty)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                            child: Text(
                              cart.length.toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
                    onPressed: () => _showProfileMenu(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (val) => setState(() => searchQuery = val),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          hintText: "Search items...",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildNearbyItemsSection(List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nearby Items",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(color: Color(0xFF00897B), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        items.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    "No nearby items found.",
                    style: TextStyle(fontSize: 18, color: Colors.black54.withOpacity(0.7)),
                  ),
                ),
              )
            : SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ItemCard(
                        imagePath: item['photo'] ?? '',
                        itemName: item['itemname'] ?? 'Unnamed',
                        price: '₹${item['price'] ?? 'N/A'}',
                        protein: item['protein'] ?? 'N/A',
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
