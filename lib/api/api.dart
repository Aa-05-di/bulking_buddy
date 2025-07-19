import 'package:http/http.dart' as http;
import 'dart:convert';

var baseurl = "http://10.0.2.2:8000";


Future<String> registerUser({
  required String username,
  required String email,
  required String password,
})async {
  final url = Uri.parse("$baseurl/register");

  final response = await http.post(
    url,
    headers: {"Content-Type":"application/json"},
    body:jsonEncode({
      "username": username,
      "email": email,
      "password": password,
    })
  );

  if (response.statusCode == 200) {
    return "Registration successful";
  } else {
    return jsonDecode(response.body)['message'];
  }
}

Future<String>loginUser({
  required String email,
  required String password
})async{
  final url = Uri.parse("$baseurl/login");

  final response = await http.post(
    url,
    headers: {"Content-Type":"application/json"},
    body:jsonEncode({
      "username":email,
      "password":password,
    })
  );
  try {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'];
    } else {
      final data = jsonDecode(response.body);
      return data['message'] ?? "Login failed";
    }
  } catch (e) {
    return "Unexpected error: ${response.body}";
  }
}