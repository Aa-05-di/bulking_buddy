import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final String price;
  final String protein;

  const ItemCard({
    super.key,
    required this.imagePath,
    required this.itemName,
    required this.price,
    required this.protein,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                imagePath,
                height: 90, // Reduced for better content visibility
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 90,
                  child: Center(child: Text('Image not available')),
                ),
              ),
            ),

            // Text + Buy Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(price, style: const TextStyle(fontSize: 15, color: Colors.green)),
                  const SizedBox(height: 2),
                  Text(protein, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Add your "Buy" logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Buy", style: TextStyle(fontSize: 13, color: Colors.white)),
                    ),
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
