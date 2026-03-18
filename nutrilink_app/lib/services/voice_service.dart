import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class VoiceService {

  static Future<Map<String, dynamic>> sendAudio(File audioFile) async {

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://172.18.0.89:8080/api/voice'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('audio', audioFile.path),
    );

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    return jsonDecode(responseData.body);
  }
}