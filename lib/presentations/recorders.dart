import 'package:first_pro/utils/error_handler.dart';
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
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final updatedOrders = await fetchReceivedOrders(widget.userEmail);
      if (mounted) setState(() => _orders = updatedOrders);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _acceptOrder(String orderId) async {
    try {
      await acceptOrder(orderId: orderId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order Accepted!'), backgroundColor: Color(0xFF00CBA9)),
        );
      }
      await _refreshOrders();
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _markAsDelivered(String orderId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2D3E),
        title: const Text('Confirm Action', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure this order is delivered? It will be removed from your list.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirm', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await deleteOrder(orderId);
      setState(() {
        _orders.removeWhere((order) => order['_id'] == orderId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order marked as delivered!'), backgroundColor: Color(0xFF00CBA9)),
        );
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _launchMaps(String location) async {
    if (location.isEmpty) return;
    final parts = location.split(', ');
    if (parts.length != 2) return;
    final lat = parts[0].replaceAll('Lat: ', '');
    final lon = parts[1].replaceAll('Lon: ', '');
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      appBar: AppBar(
        title: const Text("Received Orders", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00CBA9)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00CBA9)))
          : _orders.isEmpty
              ? const Center(child: Text("No orders received yet.", style: TextStyle(fontSize: 18, color: Colors.white70)))
              : RefreshIndicator(
                  onRefresh: _refreshOrders,
                  color: const Color(0xFF00CBA9),
                  backgroundColor: const Color(0xFF141A28),
                  child: ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      final orderId = order['_id'] ?? 'N/A';
                      final buyer = order['user']?['username'] ?? 'Anonymous';
                      final totalAmount = order['totalAmount']?.toStringAsFixed(2) ?? 'N/A';
                      final status = order['status'] ?? 'Pending';
                      final location = order['deliveryLocation'];
                      final deliveryMethod = order['deliveryMethod'] ?? 'Delivery';
                      final statusColor = status == 'Accepted' ? Colors.green : Colors.yellow;

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
                              Text("Order #$orderId", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("Buyer: $buyer", style: const TextStyle(color: Colors.white70, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text("Total: ₹$totalAmount", style: const TextStyle(color: Color(0xFF00CBA9), fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Method: $deliveryMethod", style: const TextStyle(color: Colors.white70, fontSize: 16)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Status: $status", style: TextStyle(color: statusColor, fontSize: 16, fontWeight: FontWeight.bold)),
                                  if (status == 'Pending')
                                    ElevatedButton(
                                      onPressed: () => _acceptOrder(orderId),
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00CBA9)),
                                      child: const Text("Accept"),
                                    ),
                                  if (status == 'Accepted')
                                    ElevatedButton(
                                      onPressed: () => _markAsDelivered(orderId),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                      child: const Text("Delivered"),
                                    ),
                                ],
                              ),
                              if (location != null && location.isNotEmpty && deliveryMethod == 'Delivery')
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: InkWell(
                                    onTap: () => _launchMaps(location),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.location_on_outlined, color: Colors.blueAccent, size: 16),
                                        SizedBox(width: 8),
                                        Text("View on Google Maps", style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline)),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

