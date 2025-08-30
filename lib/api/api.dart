import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseurl = "http://10.0.2.2:8000";

// ---------- Auth ----------
Future<String> registerUser({
  required String username,
  required String email,
  required String password,
  required String location,
}) async {
  final url = Uri.parse('$baseurl/register');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'email': email,
      'password': password,
      'location': location,
    }),
  );

  if (response.statusCode == 200) {
    return 'Registration successful';
  } else {
    return 'Registration failed: ${_msg(response.body)}';
  }
}

Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('$baseurl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(_msg(response.body));
  }
}

// ---------- Profile ----------
Future<Map<String, dynamic>> fetchProfileData(String email) async {
  final response = await http.get(Uri.parse('$baseurl/profile/$email'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to fetch profile");
  }
}

// ---------- Items ----------
Future<String> addItem({
  required String photo,
  required String itemname,
  required dynamic price,
  required String protein,
  required String seller,
  required String location,
}) async {
  final url = Uri.parse("$baseurl/additem");
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'photo': photo,
      'itemname': itemname,
      'price': price,
      'protein': protein,
      'seller': seller,
      'location': location,
    }),
  );

  if (response.statusCode == 200) {
    return 'Item added successfully';
  } else {
    throw Exception('Failed to add item: ${_msg(response.body)}');
  }
}

// ---------- Cart (compat versions: return only message) ----------
Future<String> addToUserCart({
  required String userEmail,
  required String itemId,
}) async {
  final res = await addToUserCartAndCart(userEmail: userEmail, itemId: itemId);
  return res['message'] ?? 'OK';
}

Future<String> removeFromUserCart({
  required String userEmail,
  required String itemId,
}) async {
  final res = await removeFromUserCartAndCart(userEmail: userEmail, itemId: itemId);
  return res['message'] ?? 'OK';
}

Future<String> updateCartQuantity({
  required String userEmail,
  required String itemId,
  required int newQuantity,
}) async {
  final res = await updateCartQuantityAndCart(
    userEmail: userEmail,
    itemId: itemId,
    newQuantity: newQuantity,
  );
  return res['message'] ?? 'OK';
}

// ---------- Cart (preferred versions: return message + updated cart) ----------
Future<Map<String, dynamic>> addToUserCartAndCart({
  required String userEmail,
  required String itemId,
}) async {
  if (itemId.isEmpty) throw Exception('Invalid Item ID');

  final url = Uri.parse('$baseurl/addtocart');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': userEmail, 'itemId': itemId}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to add item to cart: ${_msg(response.body)}');
  }
}

Future<Map<String, dynamic>> removeFromUserCartAndCart({
  required String userEmail,
  required String itemId,
}) async {
  if (itemId.isEmpty) throw Exception('Invalid Item ID');

  final url = Uri.parse('$baseurl/removefromcart');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': userEmail, 'itemId': itemId}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to remove item from cart: ${_msg(response.body)}');
  }
}

Future<Map<String, dynamic>> updateCartQuantityAndCart({
  required String userEmail,
  required String itemId,
  required int newQuantity,
}) async {
  if (itemId.isEmpty) throw Exception('Invalid Item ID');

  final url = Uri.parse('$baseurl/updatecartquantity');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': userEmail,
      'itemId': itemId,
      'newQuantity': newQuantity,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception('Failed to update quantity: ${_msg(response.body)}');
  }
}

// ---------- Checkout ----------
Future<void> placeOrderAndClearCart({required String userEmail}) async {
  final url = Uri.parse('$baseurl/placeorder');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': userEmail}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to place order: ${_msg(response.body)}');
  }
}


// ---------- Utils ----------
String _msg(String body) {
  try {
    final m = jsonDecode(body);
    return (m['message'] ?? 'Unknown error').toString();
  } catch (_) {
    return body;
  }
}