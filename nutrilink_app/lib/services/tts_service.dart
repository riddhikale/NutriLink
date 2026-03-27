import 'package:flutter_tts/flutter_tts.dart';

class TTSService {

  final FlutterTts _tts = FlutterTts();

  Future speak(String text) async {

    await _tts.setLanguage("en-US");

    await _tts.setSpeechRate(0.45);

    await _tts.setVolume(1.0);

    await _tts.speak(text);

  }

}