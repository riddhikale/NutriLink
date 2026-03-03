import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://10.0.2.2:8080";
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String phone,
    required String pin,
    required String role,
    required String assignedAreaId,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "phone": phone,
        "pin": pin,
        "role": role,
        "assignedAreaId": assignedAreaId,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser({
  required String phone,
  required String pin,
}) async {

  final response = await http.post(
    Uri.parse("$baseUrl/api/auth/login-test"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "phone": phone,
      "pin": pin,
    }),
  );

  print("Response body:");
  print(response.body);
  return jsonDecode(response.body);
}
}
