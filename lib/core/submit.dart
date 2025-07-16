import 'package:flutter/material.dart';

class Submit extends StatelessWidget {
  final String data;
  final double x;
  final double y;
  final Color? colour;
  const Submit({
    super.key,
    required this.data,
    required this.x,
    required this.y,
    required this.colour,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: x,
      height: y,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Colors.teal, width: 2),
        ),
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              data,
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
