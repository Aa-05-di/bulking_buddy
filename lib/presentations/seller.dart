import 'package:first_pro/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/api.dart';

class Seller extends StatefulWidget {
  const Seller({super.key});

  @override
  State<Seller> createState() => _SellerState();
}

class _SellerState extends State<Seller> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _sellerEmailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();

  bool _isSubmitting = false;
  bool _isUploading = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _photoController.dispose();
    _itemNameController.dispose();
    _priceController.dispose();
    _proteinController.dispose();
    _sellerEmailController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Animation<double> _createAnimation(double begin, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(begin, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Future<void> _takeAndUploadPicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      const String cloudName = "dhilf7vjy";
      const String uploadPreset = "bulking_buddy_preset";

      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
      );

      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final responseJson = json.decode(responseData);
        final String imageUrl = responseJson['secure_url'];
        if (mounted) setState(() => _photoController.text = imageUrl);
      } else {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image upload failed.'),
              backgroundColor: Colors.red,
            ),
          );
      }
    } catch (e) {
      print("Error uploading image: $e");
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error uploading image.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _submitItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final result = await addItem(
        photo: _photoController.text.trim(),
        itemname: _itemNameController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        protein: _proteinController.text.trim(),
        seller: _sellerEmailController.text.trim(),
        location: _locationController.text.trim(),
        quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: const Color(0xFF00CBA9),
          ),
        );
        _formKey.currentState!.reset();
        _photoController.clear();
        _itemNameController.clear();
        _priceController.clear();
        _proteinController.clear();
        _sellerEmailController.clear();
        _locationController.clear();
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A28),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildGlassmorphicForm(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BackButton(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141A28), Color(0xFF004D40)],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _createAnimation(0.0, 0.4),
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _animationController.value)),
            child: child,
          ),
        );
      },
      child: const Text(
        "Add New Product",
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGlassmorphicForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildAnimatedTextField(
                  animation: _createAnimation(0.2, 0.6),
                  controller: _photoController,
                  label: "Image URL",
                  icon: Icons.image_outlined,
                  suffixIcon: _isUploading
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF00CBA9),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF00CBA9),
                          ),
                          onPressed: _takeAndUploadPicture,
                        ),
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  animation: _createAnimation(0.3, 0.7),
                  controller: _itemNameController,
                  label: "Item Name",
                  icon: Icons.shopping_bag_outlined,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  animation: _createAnimation(0.4, 0.8),
                  controller: _priceController,
                  label: "Price (₹)",
                  icon: Icons.currency_rupee,
                  isNumber: true,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  animation: _createAnimation(0.5, 0.9),
                  controller: _quantityController,
                  label: "Stock Quantity (e.g., 10)",
                  icon: Icons.inventory_2_outlined,
                  isNumber: true,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  animation: _createAnimation(0.6, 1.0),
                  controller: _proteinController,
                  label: "Protein (e.g., 25g)",
                  icon: Icons.fitness_center,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  animation: _createAnimation(0.7, 1.0),
                  controller: _sellerEmailController,
                  label: "Your Email (Seller)",
                  icon: Icons.email_outlined,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                  animation: _createAnimation(0.8, 1.0),
                  controller: _locationController,
                  label: "Location",
                  icon: Icons.location_on_outlined,
                  isRequired: true,
                ),
                const SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required Animation<double> animation,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    bool isRequired = false,
    Widget? suffixIcon,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - animation.value)),
            child: child,
          ),
        );
      },
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        validator: isRequired
            ? (val) =>
                  val == null || val.isEmpty ? 'This field is required' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: const Color(0xFF00CBA9)),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF00CBA9), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedBuilder(
      animation: _createAnimation(0.8, 1.0),
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.scale(
            scale: _animationController.value,
            child: child,
          ),
        );
      },
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitItem,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00CBA9),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                "Submit Product",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
