import 'package:first_pro/presentations/history.dart';
import 'package:first_pro/presentations/recorders.dart';
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
  int _pendingOrderCount = 0;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      final results = await Future.wait([
        fetchProfileData(widget.email),
        fetchPendingOrderCount(widget.email),
      ]);

      final userData = results[0] as Map<String, dynamic>;
      items = userData['nearbyItems'] ?? [];
      cart = userData['cart'] ?? [];
      userName = userData['username'] ?? 'User';

      _pendingOrderCount = results[1] as int;
    } catch (e) {
      print("Error loading all data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadUserData() async {
    try {
      final userData = await fetchProfileData(widget.email);
      if (!mounted) return;
      setState(() {
        items = userData['nearbyItems'] ?? [];
        cart = userData['cart'] ?? [];
        userName = userData['username'] ?? 'User';
      });
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> addToCart(dynamic product) async {
    try {
      final String itemId = product['_id'];
      await addToUserCart(userEmail: widget.email, itemId: itemId);
      await loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['itemname']} added to cart!'),
          backgroundColor: const Color(0xFF00CBA9),
        ),
      );
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }

  Future<void> _removeItemFromCart(String itemId) async {
    try {
      await removeFromUserCart(userEmail: widget.email, itemId: itemId);
      await loadUserData();
    } catch (e) {
      print("Error removing item from cart: $e");
    }
  }

  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cart(
          cartItems: cart,
          onItemRemoved: (itemId) async {
            await _removeItemFromCart(itemId);
          },
          onQuantityChanged: (itemId, newCount) async {
            await updateCartQuantity(
                userEmail: widget.email,
                itemId: itemId,
                newQuantity: newCount);
            await loadUserData();
          },
          onCheckout: () async {
            await placeOrderAndClearCart(userEmail: widget.email);
            await loadUserData();
          },
        ),
      ),
    );
  }

  void onMyOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderHistoryPage(userEmail: widget.email),
      ),
    );
  }

  void onReceivedOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceivedOrdersPage(userEmail: widget.email),
      ),
    ).then((_) {
      loadAllData();
    });
  }

  void becomeSeller() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Seller()),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'logout',
          child: const Row(
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
      backgroundColor: const Color(0xFF141A28),
      // ----- THIS IS THE FINAL AND CORRECTED FLOATING ACTION BUTTON -----
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Received Orders Button
          Badge(
            label: Text(_pendingOrderCount.toString()),
            isLabelVisible: _pendingOrderCount > 0,
            backgroundColor: const Color(0xFF00CBA9),
            child: FloatingActionButton(
              heroTag: 'receivedOrdersBtn', // Prevents hero tag clash
              onPressed: onReceivedOrders,
              backgroundColor: const Color(0xFF00CBA9).withOpacity(0.8),
              child: const Icon(Icons.inventory_2_outlined, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          // Become a Seller Button
          FloatingActionButton.extended(
            heroTag: 'becomeSellerBtn', // Prevents hero tag clash
            onPressed: becomeSeller,
            label: const Text(
              "Become a Seller",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.store, color: Colors.white),
            backgroundColor: const Color(0xFF00CBA9),
          ),
        ],
      ),
      // ----- END OF THE CORRECTED SECTION -----
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF00CBA9)))
            : RefreshIndicator(
                onRefresh: loadAllData,
                color: const Color(0xFF00CBA9),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildSearchBar(),
                      ),
                      const SizedBox(height: 32),
                      _buildNearbyItemsSection(filteredItems),
                      const SizedBox(height: 100), // Space for the FABs
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${userName.toUpperCase()} 👋",
                  style: const TextStyle(
                    fontSize: 28,
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
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // ----- ICONS REMOVED FROM HERE FOR CLEANLINESS -----
              IconButton( // This is your "My Orders" button
                icon: const Icon(Icons.history, color: Colors.white, size: 28),
                onPressed: onMyOrders,
              ),
              Badge(
                label: Text(cart.length.toString()),
                isLabelVisible: cart.isNotEmpty,
                backgroundColor: Colors.redAccent,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white, size: 28),
                  onPressed: goToCartPage,
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.account_circle, color: Colors.white, size: 28),
                onPressed: () => _showProfileMenu(context),
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
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextField(
        onChanged: (val) => setState(() => searchQuery = val),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          hintText: "Search items...",
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nearby Items",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(
                      color: Color(0xFF00CBA9), fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.7)),
                  ),
                ),
              )
            : SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: ItemCard(
                        imagePath: item['photo'] ?? '',
                        itemName: item['itemname'] ?? 'Unnamed',
                        price: '₹${item['price'] ?? 'N/A'}',
                        protein: item['protein'] ?? 'N/A',
                        onTap: () => addToCart(item),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}