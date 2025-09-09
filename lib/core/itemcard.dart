import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemCard extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final String price;
  final String protein;
  final VoidCallback onTap;
  final int quantity; // <-- Accepts the stock quantity

  const ItemCard({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.price,
    required this.protein,
    required this.onTap,
    required this.quantity, // <-- Accepts the stock quantity
  });

  @override
  Widget build(BuildContext context) {
    // This boolean controls the UI changes
    final bool isOutOfStock = quantity <= 0;

    return SizedBox(
      width: 200,
      child: Card(
        color: const Color(0xFF2A2D3E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                // --- ADDED STACK FOR "OUT OF STOCK" OVERLAY ---
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[800]),
                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                    ),
                    // If the item is out of stock, show a dark overlay with text
                    if (isOutOfStock)
                      Container(
                        color: Colors.black.withOpacity(0.6),
                        child: const Center(
                          child: Text(
                            'OUT OF STOCK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(itemName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(protein, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(price, style: const TextStyle(color: Color(0xFF00CBA9), fontWeight: FontWeight.bold, fontSize: 18)),
                      
                      // --- THIS BUTTON IS NOW CONDITIONAL ---
                      ElevatedButton(
                        // Disable the button's onTap if the item is out of stock
                        onPressed: isOutOfStock ? null : onTap, 
                        style: ElevatedButton.styleFrom(
                          // Change color and text based on stock status
                          backgroundColor: isOutOfStock ? Colors.grey[700] : const Color(0xFF00CBA9),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(isOutOfStock ? "Sold Out" : "Buy"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

