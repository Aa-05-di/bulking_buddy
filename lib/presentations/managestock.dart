import 'package:first_pro/api/api.dart';
import 'package:first_pro/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ManageStockPage extends StatefulWidget {
  final String sellerEmail;
  const ManageStockPage({super.key, required this.sellerEmail});

  @override
  State<ManageStockPage> createState() => _ManageStockPageState();
}

class _ManageStockPageState extends State<ManageStockPage> {
  List<dynamic> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final items = await fetchSellerItems(widget.sellerEmail);
      if (mounted) setState(() => _items = items);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStock(String itemId, int newQuantity) async {
    try {
      await updateItemStock(itemId: itemId, newQuantity: newQuantity);
      // Visually update the item in the list instantly
      setState(() {
        final index = _items.indexWhere((item) => item['_id'] == itemId);
        if (index != -1) {
          _items[index]['quantity'] = newQuantity;
        }
      });
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF141A28), Color(0xFF004D40)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFF00CBA9)))
                      : _items.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _fetchItems,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final item = _items[index];
                                  return _buildStockItemCard(item);
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          BackButton(color: Colors.white),
          const Text("Manage Your Stock", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("You haven't listed any items yet.", style: TextStyle(color: Colors.white70, fontSize: 18)),
    );
  }

  Widget _buildStockItemCard(Map<String, dynamic> item) {
    final String itemId = item['_id'];
    int currentQuantity = item['quantity'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['itemname'], style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Current Stock: $currentQuantity", style: TextStyle(color: currentQuantity > 0 ? Colors.white70 : Colors.orangeAccent)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: Colors.white70),
                      onPressed: () {
                        if (currentQuantity > 0) {
                          _updateStock(itemId, currentQuantity - 1);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFF00CBA9)),
                      onPressed: () {
                         _updateStock(itemId, currentQuantity + 1);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
