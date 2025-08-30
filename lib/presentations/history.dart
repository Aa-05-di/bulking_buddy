import 'package:flutter/material.dart';
import 'package:first_pro/api/api.dart';
import 'package:geolocator/geolocator.dart';

class OrderHistoryPage extends StatefulWidget {
  final String userEmail;

  const OrderHistoryPage({
    super.key,
    required this.userEmail,
  });

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
    setState(() {
      _isLoading = true;
    });
    try {
      final updatedOrders = await fetchUserOrders(widget.userEmail);
      setState(() {
        _orders = updatedOrders;
      });
    } catch (e) {
      print("Error refreshing orders: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendLocation(String orderId) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are denied.'),
          ),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String location = "Lat: ${position.latitude}, Lon: ${position.longitude}";
      await sendLocation(orderId: orderId, location: location);
      await _refreshOrders();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location sent successfully!'),
          backgroundColor: Color(0xFF00CBA9),
        ),
      );
    } catch (e) {
      print("Error sending location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send location.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                    final sellerName = order['items'][0]['productId']['seller'] ?? 'N/A';
                    final totalAmount = order['totalAmount']?.toStringAsFixed(2) ?? 'N/A';
                    final status = order['status'] ?? 'Pending';
                    final color = status == 'Accepted' ? Colors.green : Colors.yellow;

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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Seller: $sellerName",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Total: ₹$totalAmount",
                              style: const TextStyle(
                                color: Color(0xFF00CBA9),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Status: $status",
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (status == 'Accepted')
                                  ElevatedButton(
                                    onPressed: () => _sendLocation(orderId),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    ),
                                    child: const Text("Send Location"),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Items:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...order['items'].map<Widget>((item) {
                              final itemName = item['productId']['itemname'] ?? 'Unnamed Item';
                              final quantity = item['quantity'] ?? 1;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "  - $itemName (x$quantity)",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}