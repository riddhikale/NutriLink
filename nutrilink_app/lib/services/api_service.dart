import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://192.168.0.222:8080";

  static String? authToken;
  static String? currentUserPhone;
  static String? currentUserName;
  static String? currentUserRole;

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
        "name": name, "phone": phone, "pin": pin,
        "role": role, "assignedAreaId": assignedAreaId,
      }),
    );

    final data = jsonDecode(response.body);
    authToken        = data["token"];
    currentUserName  = data["user"]?["name"]  ?? name;
    currentUserPhone = data["user"]?["phone"] ?? phone;
    currentUserRole  = data["user"]?["role"]  ?? role;

    return data;
  }

  static Future<Map<String, dynamic>> loginUser({
    required String phone,
    required String pin,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login-test"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone, "pin": pin}),
    );

    final data = jsonDecode(response.body);
    authToken        = data["token"];
    currentUserName  = data["user"]?["name"];
    currentUserRole  = data["user"]?["role"];
    currentUserPhone = phone;

    return data;
  }

  static Future<Map<String, dynamic>> submitChildScreening({
    required String name, required int ageMonths, required String gender,
    required String parentName, required double weight, required double height,
    required double muac, required bool weakness, required bool lowAppetite,
    required bool frequentIllness, required bool diarrhea,
    required String address, required String wardNo, required String notes,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/screening/child"),
      headers: _headers,
      body: jsonEncode({
        "name": name, "ageMonths": ageMonths, "gender": gender,
        "parentName": parentName, "weight": weight, "height": height,
        "muac": muac, "weakness": weakness, "lowAppetite": lowAppetite,
        "frequentIllness": frequentIllness, "diarrhea": diarrhea,
        "address": address, "wardNo": wardNo, "notes": notes,
      }),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed to calculate risk");
  }

  static Future<Map<String, dynamic>> submitPregnantScreening({
    required String name, required String husbandName, required int age,
    required String trimester, required double weight, required double hemoglobin,
    required int systolicBP, required int diastolicBP, required bool dizziness,
    required bool fatigue, required bool swelling, required bool lowAppetite,
    required bool pastAnemia, required String address,
    required String wardNo, required String notes,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/screening/pregWomen"),
      headers: _headers,
      body: jsonEncode({
        "name": name, "husbandName": husbandName, "age": age,
        "trimester": trimester, "weight": weight, "hemoglobin": hemoglobin,
        "systolicBP": systolicBP, "diastolicBP": diastolicBP,
        "dizziness": dizziness, "fatigue": fatigue, "swelling": swelling,
        "lowAppetite": lowAppetite, "pastAnemia": pastAnemia,
        "address": address, "wardNo": wardNo, "notes": notes,
      }),
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed to submit screening");
  }

  static Future<List<dynamic>> getFollowups() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/followups/due"),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> getCompletedFollowups() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/followups/completed"),
      headers: _headers,
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  static Future completeFollowup(String id) async {
    await http.patch(
      Uri.parse("$baseUrl/api/followup/complete/$id"),
      headers: _headers,
    );
  }

  static Future<List<dynamic>> getAlerts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/alerts/pending"),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getScreeningByBeneficiary(String id) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/screening/$id"),
      headers: _headers,
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed to fetch screening");
  }

  static Future<Map<String, dynamic>> getScreening(
      String beneficiaryId, String screeningId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/beneficiaries/$beneficiaryId/screenings/$screeningId"),
      headers: _headers,
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception("Failed to fetch screening");
  }

  static Future<void> deleteAccount() async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/auth/user/account"),
      headers: _headers,
    );
    if (response.statusCode != 200) throw Exception("Failed to delete account");
  }
}