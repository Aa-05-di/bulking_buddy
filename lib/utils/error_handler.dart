import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

// This function translates the raw error into a user-friendly message.
String _translateException(Object e) {
  // Handle specific network errors
  if (e is SocketException) {
    return "Connection error. Please check your internet.";
  }
  if (e is TimeoutException) {
    return "The server took too long to respond. Please try again.";
  }

  // Handle our custom API exceptions
  // Your api.dart throws errors like "Exception: Login failed: User not found"
  // We just want the part after "Exception: "
  final message = e.toString();
  if (message.startsWith("Exception: ")) {
    return message.substring(11); // Removes "Exception: " prefix
  }

  // Fallback for any other unexpected errors
  return "An unexpected error occurred. Please try again.";
}

// This is the public function you will call from your pages.
void showErrorSnackBar(BuildContext context, Object error) {
  // First, translate the error into a clean message.
  final friendlyMessage = _translateException(error);

  // Then, show the styled SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // --- STYLING TO MATCH YOUR APP PALETTE ---
      backgroundColor: Colors.redAccent.withOpacity(0.9),
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              friendlyMessage,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(16),
    ),
  );
}