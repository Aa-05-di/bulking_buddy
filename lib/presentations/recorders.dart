import 'package:flutter/material.dart';
import 'package:first_pro/api/api.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceivedOrdersPage extends StatefulWidget {
  final String userEmail;

  const ReceivedOrdersPage({super.key, required this.userEmail});

  @override
  State<ReceivedOrdersPage> createState() => _ReceivedOrdersPageState();
}

class _ReceivedOrdersPageState extends State<ReceivedOrdersPage> {
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
      final updatedOrders = await fetchReceivedOrders(widget.userEmail);
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

  Future<void> _acceptOrder(String orderId) async {
    try {
      await acceptOrder(orderId: orderId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order Accepted!'),
          backgroundColor: Color(0xFF00CBA9),
        ),
      );
      await _refreshOrders();
    } catch (e) {
      print("Error accepting order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to accept order.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _launchMaps(String location) async {
    // 1. Check if the location string is valid
    if (location == null || location.isEmpty) {
      print("Location data is null or empty.");
      return;
    }

    final parts = location.split(', ');
    if (parts.length != 2) {
      print("Location format is incorrect.");
      return;
    }

    final lat = parts[0].replaceAll('Lat: ', '');
    final lon = parts[1].replaceAll('Lon: ', '');

    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lon',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      appBar: AppBar(
        title: const Text(
          "Received Orders",
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
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00CBA9)),
            )
          : _orders.isEmpty
          ? const Center(
              child: Text(
                "No orders received yet.",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final orderId = order['_id'] ?? 'N/A';
                final buyer = order['user']['username'] ?? 'Anonymous';
                final totalAmount =
                    order['totalAmount']?.toStringAsFixed(2) ?? 'N/A';
                final status = order['status'] ?? 'Pending';
                final location = order['deliveryLocation'];
                final color = status == 'Accepted'
                    ? Colors.green
                    : Colors.yellow;

                return Card(
                  color: Colors.white.withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                          "Buyer: $buyer",
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
                            if (status == 'Pending')
                              ElevatedButton(
                                onPressed: () => _acceptOrder(orderId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00CBA9),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text("Accept"),
                              ),
                          ],
                        ),
                        if (location != null && location.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                const Text(
                                  "Location: ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _launchMaps(location),
                                  child: Text(
                                    "View on Google Maps",
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                          final itemName =
                              item['productId']['itemname'] ?? 'Unnamed Item';
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
