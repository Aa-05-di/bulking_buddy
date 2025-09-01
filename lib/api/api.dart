import 'package:http/http.dart' as http;
import 'dart:convert';


const String baseurl = "https://backend-bulkbuddy.onrender.com";

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

// ---------- Orders ----------
// ----- ADDED FOR PENDING COUNT -----
Future<int> fetchPendingOrderCount(String sellerEmail) async {
  final url = Uri.parse('$baseurl/receivedorders/pending-count/$sellerEmail');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['count'] ?? 0;
  } else {
    throw Exception('Failed to fetch pending order count: ${_msg(response.body)}');
  }
}
// ----- END OF ADDED SECTION -----

Future<List<dynamic>> fetchReceivedOrders(String sellerEmail) async {
  final url = Uri.parse('$baseurl/receivedorders/$sellerEmail');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch received orders: ${_msg(response.body)}');
  }
}

Future<List<dynamic>> fetchUserOrders(String userEmail) async {
  final url = Uri.parse('$baseurl/userorders/$userEmail');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch user orders: ${_msg(response.body)}');
  }
}

Future<void> acceptOrder({required String orderId}) async {
  final url = Uri.parse('$baseurl/acceptorder');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'orderId': orderId}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to accept order: ${_msg(response.body)}');
  }
}

Future<void> sendLocation({
  required String orderId,
  required String location,
}) async {
  final url = Uri.parse('$baseurl/sendlocation');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'orderId': orderId,
      'location': location,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to send location: ${_msg(response.body)}');
  }
}

// ----- ADDED FOR AI WORKOUT PLANNER -----
Future<int> fetchTotalProteinToday(String userEmail) async {
  final url = Uri.parse('$baseurl/orders/proteintoday/$userEmail');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    // Use tryParse to handle potential nulls or non-integer values gracefully
    return int.tryParse(data['totalProteinToday'].toString()) ?? 0;
  } else {
    throw Exception('Failed to fetch today\'s protein intake: ${_msg(response.body)}');
  }
}

// in api.dart

Future<Map<String, dynamic>> generateWorkoutPlan({
  required double weight,
  required int proteinToday,
  required String userEmail, // <-- ADD THIS
}) async {
  final url = Uri.parse('$baseurl/generate-workout');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'weight': weight,
      'proteinToday': proteinToday,
      'userEmail': userEmail, // <-- AND THIS
    }),
  );
  // ... (rest of the function is the same)
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to generate AI workout plan: ${_msg(response.body)}');
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