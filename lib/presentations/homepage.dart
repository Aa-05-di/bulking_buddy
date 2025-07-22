import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageTestPage extends StatelessWidget {
  const ImageTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    const testImageUrl = 'https://picsum.photos/id/237/200/300'; // Using the test URL

    return Scaffold(
      appBar: AppBar(title: const Text('Image Test (Simplified)')),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: testImageUrl,
          // Placeholder while the image is loading
          placeholder: (context, url) => const CircularProgressIndicator(),
          // Widget to show if there's an error loading the image
          errorWidget: (context, url, error) {
            print('CachedNetworkImage Error: $error'); // Print the actual error to console
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, color: Colors.red, size: 40),
                SizedBox(height: 8),
                Text("Image failed to load."),
                Text("Check your internet connection."),
              ],
            );
          },
          // Set explicit width/height for visibility if it loads
          width: 300,
          height: 200,
          fit: BoxFit.cover, // Ensures the image fills the space
        ),
      ),
    );
  }
}