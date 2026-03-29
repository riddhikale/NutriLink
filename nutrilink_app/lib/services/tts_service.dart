import 'package:flutter_tts/flutter_tts.dart';

class TTSService {

  final FlutterTts _tts = FlutterTts();

  Future<void> speak(String text, String language) async {
    String langCode = "en-US";

    // Hindi
    if (language == "hi") {
      langCode = "hi-IN";
    }

    // Marathi
    if (language == "mr") {
      langCode = "mr-IN";
    }

    // English
    if (language == "en") {
      langCode = "en-US";
    }

    await _tts.setLanguage(langCode);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.speak(text);
  }
}