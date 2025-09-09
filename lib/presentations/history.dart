import 'package:first_pro/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:first_pro/api/api.dart';
import 'package:geolocator/geolocator.dart';

class OrderHistoryPage extends StatefulWidget {
  final String userEmail;

  const OrderHistoryPage({super.key, required this.userEmail});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late List<dynamic> _orders;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _orders = [];
    _refreshOrders();
  }

  Future<void> _refreshOrders() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final updatedOrders = await fetchUserOrders(widget.userEmail);
      if (mounted) {
        setState(() {
          _orders = updatedOrders;
        });
      }
    } catch (e) {
      print("Error refreshing orders: $e");
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendLocation(String orderId) async {
    // This function can be simplified as it's already robust
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled && mounted) {
        showErrorSnackBar(context, Exception('Location services are disabled.'));
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied && mounted) {
          showErrorSnackBar(context, Exception('Location permissions are denied.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever && mounted) {
        showErrorSnackBar(context, Exception('Location permissions are permanently denied.'));
        return;
      }

      setState(() => _isLoading = true);
      
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String location = "Lat: ${position.latitude}, Lon: ${position.longitude}";
      
      await sendLocation(orderId: orderId, location: location);
      await _refreshOrders();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location sent successfully!'),
            backgroundColor: Color(0xFF00CBA9),
          ),
        );
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      appBar: AppBar(
        title: const Text(
          "My Orders",
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00CBA9)))
          : _orders.isEmpty
              ? const Center(
                  child: Text(
                    "You have not placed any orders yet.",
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    final orderId = order['_id'] ?? 'N/A';
                    
                    // ----- THIS IS THE FIX: Replaced complex ternary with a clearer, safer block -----
                    final itemsList = order['items'] as List?;
                    String sellerName = 'N/A'; // Start with a default value
                    if (itemsList != null && itemsList.isNotEmpty) {
                      // Safely access the first item and its properties
                      final firstItem = itemsList[0];
                      if (firstItem != null && firstItem['productId'] != null) {
                        sellerName = firstItem['productId']['seller'] ?? 'Unknown Seller';
                      }
                    }
                    // ----- END OF FIX -----
                    
                    final totalAmount = order['totalAmount']?.toStringAsFixed(2) ?? 'N/A';
                    final status = order['status'] ?? 'Pending';
                    final deliveryMethod = order['deliveryMethod'] ?? 'Delivery';

                    final Color color;
                    switch (status) {
                      case 'Accepted':
                        color = Colors.green;
                        break;
                      case 'Delivered':
                        color = Colors.blueAccent;
                        break;
                      default: // Pending
                        color = Colors.yellow;
                        break;
                    }

                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #$orderId",
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text("Seller: $sellerName", style: const TextStyle(color: Colors.white70, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("Total: ₹$totalAmount", style: const TextStyle(color: Color(0xFF00CBA9), fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("Method: $deliveryMethod", style: const TextStyle(color: Colors.white70, fontSize: 16)),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Status: $status", style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
                                if (status == 'Accepted' && deliveryMethod == 'Delivery')
                                  ElevatedButton(
                                    onPressed: () => _sendLocation(orderId),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    ),
                                    child: const Text("Send Location"),
                                  ),
                              ],
                            ),
                            if (itemsList != null && itemsList.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Text(
                                "Items:",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...itemsList.map<Widget>((item) {
                                final itemName = item['productId']?['itemname'] ?? 'Unnamed Item';
                                final quantity = item['quantity'] ?? 1;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    "  - $itemName (x$quantity)",
                                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

