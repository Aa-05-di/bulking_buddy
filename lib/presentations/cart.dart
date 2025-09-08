import 'package:first_pro/core/cartitem.dart';
import 'package:first_pro/presentations/checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

class Cart extends StatefulWidget {
  final List<dynamic> cartItems;
  final Function(String) onItemRemoved;
  final Function(String, int) onQuantityChanged;
  final Future<void> Function() onCheckout;

  const Cart({
    super.key,
    required this.cartItems,
    required this.onItemRemoved,
    required this.onQuantityChanged,
    required this.onCheckout,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Map<String, int> _itemQuantities;
  late List<dynamic> _localCartItems;

  @override
  void initState() {
    super.initState();
    _itemQuantities = _initializeQuantities(widget.cartItems);
    _localCartItems = List.from(widget.cartItems);
  }

  @override
  void didUpdateWidget(covariant Cart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems != oldWidget.cartItems) {
      _itemQuantities = _initializeQuantities(widget.cartItems);
      setState(() {
        _localCartItems = List.from(widget.cartItems);
      });
    }
  }

  Map<String, int> _initializeQuantities(List<dynamic> items) {
    Map<String, int> quantities = {};
    for (var item in items) {
      if (item is Map) {
        final itemId = item['productId']?['_id'] ?? item['_id'];
        if (itemId != null) {
          quantities.putIfAbsent(itemId, () => item['quantity'] ?? 1);
        }
      }
    }
    return quantities;
  }

  void _incrementQuantity(String itemId) {
    setState(() {
      _itemQuantities[itemId] = (_itemQuantities[itemId] ?? 0) + 1;
    });
    widget.onQuantityChanged(itemId, _itemQuantities[itemId]!);
  }

  void _decrementQuantity(String itemId) {
    final currentQuantity = _itemQuantities[itemId] ?? 1;
    if (currentQuantity <= 1) {
      _removeItem(itemId);
    } else {
      setState(() {
        _itemQuantities[itemId] = currentQuantity - 1;
      });
      widget.onQuantityChanged(itemId, _itemQuantities[itemId]!);
    }
  }

  void _removeItem(String itemId) {
    setState(() {
      _localCartItems.removeWhere((item) {
        final itemData = item['productId'] ?? item;
        return itemData['_id'] == itemId;
      });
    });
    widget.onItemRemoved(itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF141A28),
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00CBA9)),
      ),
      body: SafeArea(
        child: _localCartItems.isEmpty
            ? const EmptyCartAnimation()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AnimationLimiter(
                        child: ListView.builder(
                          itemCount: _localCartItems.length,
                          itemBuilder: (context, index) {
                            final item = _localCartItems[index];
                            final itemData = item['productId'] ?? item;
                            final itemId = itemData['_id'] as String;
                            final quantity = _itemQuantities[itemId] ?? 1;

                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: CartItemCard(
                                    imagePath: itemData['photo'] ?? '',
                                    itemName:
                                        itemData['itemname'] ?? 'Unnamed Item',
                                    price: '₹${itemData['price'] ?? 'N/A'}',
                                    protein: itemData['protein'] ?? 'N/A',
                                    quantity: quantity,
                                    onIncrement: () =>
                                        _incrementQuantity(itemId),
                                    onDecrement: () =>
                                        _decrementQuantity(itemId),
                                    onRemove: () => _removeItem(itemId),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    _buildCheckoutButton(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutPage(cartItems: _localCartItems),
              ),
            );

            if (result == 'order_placed') {
              await widget.onCheckout();
              if (mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00CBA9),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: const Text(
            "Proceed to Checkout",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class EmptyCartAnimation extends StatelessWidget {
  const EmptyCartAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/shopping cart.json', width: 250, height: 250),
          const SizedBox(height: 20),
          Text(
            "Your cart is empty!",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Go back to add some delicious items.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
