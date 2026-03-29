import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://192.168.0.222:8080";

  // ── Stored after login ──────────────────────────────────
  static String? authToken;
  static String? currentUserPhone;

  // ── Attach token to every protected request ─────────────
  static Map<String, String> get _headers => {
    "Content-Type": "application/json",
    if (authToken != null) "Authorization": "Bearer $authToken",
  };

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
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "pin": pin,
      }),
    );

    print("Response body:");
    print(response.body);

    final data = jsonDecode(response.body);

    // ── Save token and phone from login response ────────────
    authToken = data["token"];
    currentUserPhone = data["user"]?["phone"];

    return data;
  }

  static Future<Map<String, dynamic>> submitChildScreening({
    required String name,
    required int ageMonths,
    required String gender,
    required String parentName,
    required double weight,
    required double height,
    required double muac,
    required bool weakness,
    required bool lowAppetite,
    required bool frequentIllness,
    required bool diarrhea,
    required String address,   // ← added
    required String notes,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/screening/child"),
      headers: _headers,
      body: jsonEncode({
        "name": name,
        "ageMonths": ageMonths,
        "gender": gender,
        "parentName": parentName,
        "weight": weight,
        "height": height,
        "muac": muac,
        "weakness": weakness,
        "lowAppetite": lowAppetite,
        "frequentIllness": frequentIllness,
        "diarrhea": diarrhea,
        "address": address,    // ← added
        "notes": notes,
      }),
    );
    print("=== SCREENING DEBUG ===");
    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("HEADERS SENT: $_headers");
    print("======================");


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to calculate risk");
    }
  }

  static Future<Map<String, dynamic>> submitPregnantScreening({
    required String name,
    required String husbandName,
    required int age,
    required String trimester,
    required double weight,
    required double hemoglobin,
    required int systolicBP,
    required int diastolicBP,
    required bool dizziness,
    required bool fatigue,
    required bool swelling,
    required bool lowAppetite,
    required bool pastAnemia,
    required String address,   // ← added
    required String notes,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/screening/pregWomen"),
      headers: _headers,
      body: jsonEncode({
        "name": name,
        "husbandName": husbandName,
        "age": age,
        "trimester": trimester,
        "weight": weight,
        "hemoglobin": hemoglobin,
        "systolicBP": systolicBP,
        "diastolicBP": diastolicBP,
        "dizziness": dizziness,
        "fatigue": fatigue,
        "swelling": swelling,
        "lowAppetite": lowAppetite,
        "pastAnemia": pastAnemia,
        "address": address,    // ← added
        "notes": notes,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getFollowups() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/followups/due"),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  static Future completeFollowup(String id) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/api/followup/complete/$id"),
      headers: _headers,
    );
    print(response.body);
  }
}