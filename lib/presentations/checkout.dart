import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final List<dynamic> cartItems;

  const CheckoutPage({
    super.key,
    required this.cartItems,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _deliveryMethod = 'Delivery'; // Default to Delivery

  double _calculateSubtotal() {
    double subtotal = 0.0;
    for (var item in widget.cartItems) {
      final itemData = item['productId'] ?? item;
      final price = double.tryParse(itemData['price']?.toString() ?? '0') ?? 0;
      final quantity = item['quantity'] as int? ?? 1;
      subtotal += price * quantity;
    }
    return subtotal;
  }

  @override
  Widget build(BuildContext context) {
    const double deliveryCharge = 20.0;
    final subtotal = _calculateSubtotal();
    final totalAmount = _deliveryMethod == 'Delivery' ? subtotal + deliveryCharge : subtotal;

    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00CBA9)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Order Summary", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    final itemData = item['productId'] ?? item;
                    final quantity = item['quantity'] as int? ?? 1;
                    return ListTile(
                      title: Text(itemData['itemname'] ?? 'Unnamed Item', style: const TextStyle(color: Colors.white)),
                      trailing: Text('₹${itemData['price'] ?? 'N/A'} x $quantity', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text("Select Option", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildChoiceChip('Delivery', Icons.delivery_dining)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildChoiceChip('Pickup', Icons.storefront)),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              _buildPriceRow(title: "Subtotal", amount: subtotal),
              const SizedBox(height: 8),
              if (_deliveryMethod == 'Delivery')
                _buildPriceRow(title: "Delivery Charge", amount: deliveryCharge),
              const SizedBox(height: 8),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              _buildPriceRow(title: "Total Amount", amount: totalAmount, isTotal: true),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'result': 'order_placed', 'method': _deliveryMethod});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CBA9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Place Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, IconData icon) {
    final bool isSelected = _deliveryMethod == label;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF00CBA9)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _deliveryMethod = label);
      },
      backgroundColor: Colors.white.withOpacity(0.1),
      selectedColor: const Color(0xFF00CBA9),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildPriceRow({required String title, required double amount, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: isTotal ? Colors.white : Colors.white70, fontSize: isTotal ? 22 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text('₹${amount.toStringAsFixed(2)}', style: TextStyle(color: isTotal ? const Color(0xFF00CBA9) : Colors.white, fontSize: isTotal ? 22 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}

