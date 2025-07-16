import 'package:flutter/material.dart';

class LoginItem extends StatelessWidget {
  final String hinttext;
  final IconData icondata;
  final TextEditingController controller;

  const LoginItem({
    super.key,
    required this.hinttext,
    required this.icondata,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.grey[200],
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              icon: Icon(icondata, color: Colors.teal),
            ),
          ),
        ),
      ),
    );
  }
}
