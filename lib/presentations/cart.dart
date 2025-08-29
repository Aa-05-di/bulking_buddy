import 'package:first_pro/core/cartitem.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final List<dynamic> cartItems;
  final Function(String) onItemRemoved;
  final Function(String, int) onQuantityChanged;

  const Cart({
    super.key,
    required this.cartItems,
    required this.onItemRemoved,
    required this.onQuantityChanged,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Map<String, int> _itemQuantities;

  @override
  void initState() {
    super.initState();
    _itemQuantities = _initializeQuantities(widget.cartItems);
  }

  @override
  void didUpdateWidget(covariant Cart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cartItems != oldWidget.cartItems) {
      _itemQuantities = _initializeQuantities(widget.cartItems);
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
    setState(() {
      final currentQuantity = _itemQuantities[itemId] ?? 1;
      if (currentQuantity > 1) {
        _itemQuantities[itemId] = currentQuantity - 1;
      }
    });
    widget.onQuantityChanged(itemId, _itemQuantities[itemId]!);
  }

  void _removeItem(String itemId) {
    widget.onItemRemoved(itemId);
  }

  @override
  Widget build(BuildContext context) {
    final validCartItems = widget.cartItems.where((item) => item is Map && (item['productId'] is Map || item['itemname'] is String)).toList();

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
        child: validCartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        size: 100, color: Color(0xFF00CBA9)),
                    const SizedBox(height: 20),
                    Text(
                      "Your cart is empty!",
                      style: TextStyle(
                          fontSize: 20, color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Go back to add some delicious items.",
                      style: TextStyle(
                          fontSize: 16, color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: validCartItems.length,
                        itemBuilder: (context, index) {
                          final item = validCartItems[index];
                          final itemData = item['productId'] ?? item;
                          final itemId = itemData['_id'] as String;
                          final quantity = _itemQuantities[itemId] ?? 1;
                          
                          return CartItemCard(
                            imagePath: itemData['photo'] ?? '',
                            itemName: itemData['itemname'] ?? 'Unnamed Item',
                            price: '₹${itemData['price'] ?? 'N/A'}',
                            protein: itemData['protein'] ?? 'N/A',
                            quantity: quantity,
                            onIncrement: () => _incrementQuantity(itemId),
                            onDecrement: () => _decrementQuantity(itemId),
                            onRemove: () => _removeItem(itemId),
                          );
                        },
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
          onPressed: () {
            // Add checkout logic here
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
