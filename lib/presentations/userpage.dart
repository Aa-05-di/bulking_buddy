import 'package:first_pro/presentations/history.dart';
import 'package:first_pro/presentations/recorders.dart';
import 'package:flutter/material.dart';
import 'package:first_pro/api/api.dart';
import 'package:first_pro/presentations/cart.dart';
import 'package:first_pro/presentations/seller.dart';
import 'package:first_pro/presentations/login.dart';
import '../core/itemcard.dart';
import 'dart:ui';

class UserPage extends StatefulWidget {
  final String email;

  const UserPage({super.key, required this.email});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  List<dynamic> items = [];
  List<dynamic> cart = [];
  bool isLoading = true;
  String userName = '';
  String searchQuery = '';
  int _pendingOrderCount = 0;
  late AnimationController _animationController;

  final _weightController = TextEditingController();
  int _totalProteinToday = 0;
  Map<String, dynamic>? _workoutPlan;
  bool _isGeneratingPlan = false;
  // ----- END OF NEW STATE -----

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    loadAllData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _weightController.dispose();
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

  Future<void> loadAllData() async {
    if (!mounted) return;
    if (_animationController.status != AnimationStatus.completed) {
      setState(() => isLoading = true);
    }
    try {
      final results = await Future.wait([
        fetchProfileData(widget.email),
        fetchPendingOrderCount(widget.email),
        fetchTotalProteinToday(widget.email),
      ]);

      final userData = results[0] as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          items = userData['nearbyItems'] ?? [];
          cart = userData['cart'] ?? [];
          userName = userData['username'] ?? 'User';
          _pendingOrderCount = results[1] as int;
          _totalProteinToday = results[2] as int;
        });
      }
    } catch (e) {
      print("Error loading all data: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
        _animationController.forward();
      }
    }
  }

  void _generateWorkoutPlan() async {
    final double? weight = double.tryParse(_weightController.text);

    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid weight."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isGeneratingPlan = true);

    try {
      final plan = await generateWorkoutPlan(
        weight: weight,
        proteinToday: _totalProteinToday,
        userEmail: widget.email,
      );
      if (mounted) {
        setState(() {
          _workoutPlan = plan;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to generate plan: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPlan = false);
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
        const SnackBar(
          content: Text('Item added to cart!'),
          backgroundColor: Color(0xFF00CBA9),
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
              newQuantity: newCount,
            );
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
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
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
      backgroundColor: const Color(0xFF141A28),
      floatingActionButton: _buildAnimatedFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00CBA9)),
            )
          : Stack(
              children: [
                _buildAnimatedBackground(),
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: loadAllData,
                    color: const Color(0xFF00CBA9),
                    backgroundColor: const Color(0xFF141A28),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildSearchBar(),
                          const SizedBox(height: 32),
                          _buildNearbyItemsSection(filteredItems),
                          const SizedBox(height: 32),
                          _buildAiWorkoutPlanner(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141A28), Color(0xFF004D40)],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _createAnimation(0.0, 0.5),
      builder: (context, child) => Opacity(
        opacity: _animationController.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - _animationController.value)),
          child: child,
        ),
      ),
      child: Container(
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
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: onMyOrders,
                ),
                Badge(
                  label: Text(cart.length.toString()),
                  isLabelVisible: cart.isNotEmpty,
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: goToCartPage,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => _showProfileMenu(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedBuilder(
      animation: _createAnimation(0.2, 0.7),
      builder: (context, child) => Opacity(
        opacity: _animationController.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - _animationController.value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  hintText: "Search items...",
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyItemsSection(List<dynamic> items) {
    return AnimatedBuilder(
      animation: _createAnimation(0.4, 0.9),
      builder: (context, child) => Opacity(
        opacity: _animationController.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - _animationController.value)),
          child: child,
        ),
      ),
      child: Column(
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
                      color: Color(0xFF00CBA9),
                      fontWeight: FontWeight.bold,
                    ),
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
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                      ),
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
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return AnimatedBuilder(
      animation: _createAnimation(0.6, 1.0),
      builder: (context, child) => Transform.scale(
        scale: _animationController.value,
        child: Opacity(opacity: _animationController.value, child: child),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Badge(
            label: Text(_pendingOrderCount.toString()),
            isLabelVisible: _pendingOrderCount > 0,
            backgroundColor: const Color(0xFF00CBA9),
            child: FloatingActionButton(
              heroTag: 'receivedOrdersBtn',
              onPressed: onReceivedOrders,
              backgroundColor: const Color(0xFF00CBA9).withOpacity(0.8),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton.extended(
            heroTag: 'becomeSellerBtn',
            onPressed: becomeSeller,
            label: const Text(
              "Become a Seller",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: const Icon(Icons.store, color: Colors.white),
            backgroundColor: const Color(0xFF00CBA9),
          ),
        ],
      ),
    );
  }

  Widget _buildAiWorkoutPlanner() {
    return AnimatedBuilder(
      animation: _createAnimation(0.5, 1.0),
      builder: (context, child) => Opacity(
        opacity: _animationController.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - _animationController.value)),
          child: child,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF00CBA9),
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "AI Workout Planner",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Based on your protein purchased today: ${_totalProteinToday}g",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Your Current Weight (kg)",
                      labelStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(
                        Icons.monitor_weight_outlined,
                        color: Color(0xFF00CBA9),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFF00CBA9),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isGeneratingPlan ? null : _generateWorkoutPlan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00CBA9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isGeneratingPlan
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            "Generate Today's Plan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  if (_workoutPlan != null) _buildPlanResult(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanResult() {
    final exercisesList = _workoutPlan!['exercises'] as List;

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            _workoutPlan!['fact'],
            style: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          ...exercisesList.map((exercise) {
            final exerciseMap = exercise as Map<String, dynamic>;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.fitness_center,
                color: Color(0xFF00CBA9),
              ),
              title: Text(
                exerciseMap['name'].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Sets: ${exerciseMap['sets']} | Reps: ${exerciseMap['reps']}",
                style: const TextStyle(color: Colors.white70),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
