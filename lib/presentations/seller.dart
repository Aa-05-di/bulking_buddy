import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = "http://10.0.2.2:2000";

class Seller extends StatefulWidget {
  const Seller({super.key});

  @override
  State<Seller> createState() => _SellerState();
}

class _SellerState extends State<Seller> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _sellerEmailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final url = Uri.parse('$baseUrl/additem');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'photo': _photoController.text.trim(),
        'itemname': _itemNameController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'protein': _proteinController.text.trim(),
        'seller': _sellerEmailController.text.trim(),
        'location': _locationController.text.trim(),
      }),
    );

    setState(() => _isSubmitting = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully!'), backgroundColor: Colors.tealAccent),
      );
      _formKey.currentState!.reset();
      _photoController.clear();
      _itemNameController.clear();
      _priceController.clear();
      _proteinController.clear();
      _sellerEmailController.clear();
      _locationController.clear();
    } else {
      final msg = jsonDecode(response.body)['message'] ?? 'Error occurred';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $msg'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildTextField(
      {required String label,
      required IconData icon,
      required TextEditingController controller,
      bool isNumber = false,
      bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: isRequired
            ? (val) => val == null || val.isEmpty ? 'Enter $label' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //title: const Text("Add Product"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white,Colors.teal,Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    "Enter Product Details",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  _buildTextField(
                    label: "Image URL",
                    icon: Icons.image,
                    controller: _photoController,
                  ),
                  _buildTextField(
                    label: "Item Name",
                    icon: Icons.shopping_bag,
                    controller: _itemNameController,
                    isRequired: true,
                  ),
                  _buildTextField(
                    label: "Price (₹)",
                    icon: Icons.currency_rupee,
                    controller: _priceController,
                    isRequired: true,
                    isNumber: true,
                  ),
                  _buildTextField(
                    label: "Protein (e.g. 3g)",
                    icon: Icons.local_dining,
                    controller: _proteinController,
                  ),
                  _buildTextField(
                    label: "Your Email (Seller)",
                    icon: Icons.email,
                    controller: _sellerEmailController,
                    isRequired: true,
                  ),
                  _buildTextField(
                    label: "Location",
                    icon: Icons.location_on,
                    controller: _locationController,
                    isRequired: true,
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitItem,
                    icon: const Icon(Icons.send),
                    label: Text(_isSubmitting ? "Submitting..." : "Submit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
