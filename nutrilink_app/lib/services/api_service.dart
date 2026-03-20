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

static Future<Map<String, dynamic>> submitChildScreening({
  required String beneficiaryId,
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
  required String notes,
}) async {

  final response = await http.post(
    Uri.parse("$baseUrl/api/screening/child"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "beneficiaryId": beneficiaryId,
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
      "notes": notes
    }),
  );

  return jsonDecode(response.body);
}

static Future<Map<String, dynamic>> submitPregnantScreening({
  required String beneficiaryId,
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
  required String notes,
}) async {

  final response = await http.post(
    Uri.parse("$baseUrl/api/screening/pregWomen"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "beneficiaryId": beneficiaryId,
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
      "notes": notes
    }),
  );

  return jsonDecode(response.body);
}

static Future<List<dynamic>> getFollowups() async {
  final response = await http.get(
    Uri.parse("$baseUrl/api/followups/due"),
    headers: {"Content-Type": "application/json"},
  );

  return jsonDecode(response.body);
}

static Future completeFollowup(String id) async {
  final response = await http.patch(
    Uri.parse("$baseUrl/api/followup/complete/$id"),
    headers: {"Content-Type": "application/json"},
  );

  print(response.body);
}
}
