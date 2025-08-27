import 'package:http/http.dart' as http;
import 'dart:convert';

var baseurl = "http://10.0.2.2:2000";

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
    return 'Registration failed: ${jsonDecode(response.body)['message']}';
  }
}

Future<Map<String, dynamic>> loginUser({required String email, required String password}) async {
  final response = await http.post(
    Uri.parse('$baseurl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(jsonDecode(response.body)['message']);
  }
}


Future<Map<String, dynamic>> getUserProfile(String userId) async {
  final url = Uri.parse('$baseurl/user/$userId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load user profile');
  }
}

Future<Map<String, dynamic>> fetchProfileData(String email) async {
  final response = await http.get(Uri.parse('$baseurl/profile/$email'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to fetch profile");
  }
}

Future<String>addItem({
  required String photo,
  required String itemname,
  required String price,
  required String protein,
  required String seller,
  required String location
})async{
  final url = Uri.parse("$baseurl/additem");
  final response = await http.post(
    url,
    headers: {'Content-Type':'application/json'},
    body:jsonEncode({
      'photo':photo,
      'itemname':itemname,
      'price':price,
      'protein':protein,
      'seller':seller,
      'location':location
    })
  );

  if (response.statusCode == 200) {
    return 'Item added successfully';
  } else {
    final error = jsonDecode(response.body)['message'] ?? 'Something went wrong!';
    throw Exception('Failed to add item: $error');
  }

}

