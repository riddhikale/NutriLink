import 'dart:io';
import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';
import '../../../services/voice_service.dart';
import '../../../services/tts_service.dart';

import '../screening/add_screening_page.dart';
import '../screening/child_screening_page.dart';
import '../screening/pregnant_screening_page.dart';

import '../profile/settings_page.dart';
import '../profile/work_history_page.dart';

import 'dashboard_view.dart';
import 'profile_view.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;
  final AudioService _audioService = AudioService();
  final TTSService _tts = TTSService();

  // ================= 🎯 INTENT HANDLER ================= //

  void handleIntent(String intent) {
    print("🧠 Detected Intent: $intent");
    final Map<String, String> intentSpeech = {
      "add_child_screening": "Opening child screening",
      "add_pregnant_screening": "Opening pregnant women screening",
      "add_beneficiary": "Opening beneficiary registration",
      "add_screening": "Opening screening page",
      "navigation_settings": "Opening settings",
      "navigation_work_history": "Opening work history",
      "navigation_home": "Opening home",
      "navigation_profile": "Opening profile",
    };

    final Map<String, Widget Function()> intentRoutes = {
      "add_child_screening": () => const ChildScreeningPage(),
      "add_pregnant_screening": () => const PregnantScreeningPage(),
      "add_beneficiary": () => const AddScreeningPage(),
      "add_screening": () => const AddScreeningPage(),
      "navigation_settings": () => const SettingsPage(),
      "navigation_work_history": () => const WorkHistoryPage(),
    };
    // Speak response
    if (intentSpeech.containsKey(intent)) {
      _tts.speak(intentSpeech[intent]!);
    }
    // Navigate
    if (intentRoutes.containsKey(intent)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => intentRoutes[intent]!(),
        ),
      );
    }
    else if (intent == "navigation_home") {
      setState(() => _selectedIndex = 0);
    }
    else if (intent == "navigation_profile") {
      setState(() => _selectedIndex = 1);
    }
    else {
      _tts.speak("Sorry, I did not understand the command");
    }
  }

  Future<void> handleMic() async {
    final path = await _audioService.recordAudio();
    if (path != null) {
      try {
        var result = await VoiceService.sendAudio(File(path));
        print("📡 Backend Response: $result");
        if (result.containsKey("intent")) {
          handleIntent(result["intent"]);
        } else {
          print("❌ Backend returned error");
          _tts.speak("Sorry, voice processing failed");
        }
      } catch (e) {
        print("❌ Voice error: $e");
        _tts.speak("Something went wrong");
      }
    }
  }

  // ================= UI ================= //

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardView(
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddScreeningPage()),
          );
        },
      ),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      appBar: AppBar(
        title: const Text("Dashboard"),
      ),

      body: pages[_selectedIndex],

      // 🎤 MIC BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: handleMic,
        child: const Icon(Icons.mic),
      ),

      //TTS TESTING
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _tts.speak("Hello, NutriLink voice assistant is working");
      //   },
      //   child: const Icon(Icons.mic),
      // ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔻 BOTTOM NAV
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: const Icon(Icons.home),
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: const Icon(Icons.person),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}