import 'dart:io';
import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';
import '../../../services/voice_service.dart';
import '../../../services/tts_service.dart';
import '../../../services/api_service.dart';
import '../screening/add_screening_page.dart';
import '../screening/child_screening_page.dart';
import '../screening/pregnant_screening_page.dart';
import '../profile/settings_page.dart';
import '../profile/work_history_page.dart';
import 'dashboard_view.dart';
import 'profile_view.dart';
import '../../widgets/app_bar_with_lang.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;

  // ── User data ──────────────────────────────────────────
  String _userName  = '';
  String _userPhone = '';
  String _userRole  = '';

  final AudioService _audioService = AudioService();
  final TTSService _tts = TTSService();

  // ================= LIFECYCLE ================= //

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userName  = ApiService.currentUserName  ?? 'User';
      _userPhone = ApiService.currentUserPhone ?? '';
      _userRole  = ApiService.currentUserRole  ?? 'NGO Worker';
    });
  }

  // ================= INTENT HANDLER ================= //

  void handleIntent(String intent, String language) {
    print("Intent: $intent | Language: $language");

    final Map<String, Map<String, String>> intentSpeech = {
      "add_child_screening": {
        "en": "Opening child screening",
        "hi": "बच्चे की स्क्रीनिंग खोल रहा हूँ",
        "mr": "बाल स्क्रीनिंग उघडत आहे"
      },
      "add_pregnant_screening": {
        "en": "Opening pregnant women screening",
        "hi": "गर्भवती महिला स्क्रीनिंग खोल रहा हूँ",
        "mr": "गर्भवती महिला स्क्रीनिंग उघडत आहे"
      },
      "add_beneficiary": {
        "en": "Opening beneficiary registration",
        "hi": "लाभार्थी पंजीकरण खोल रहा हूँ",
        "mr": "लाभार्थी नोंदणी उघडत आहे"
      },
      "add_screening": {
        "en": "Opening screening page",
        "hi": "स्क्रीनिंग पेज खोल रहा हूँ",
        "mr": "स्क्रीनिंग पेज उघडत आहे"
      },
      "navigation_settings": {
        "en": "Opening settings",
        "hi": "सेटिंग्स खोल रहा हूँ",
        "mr": "सेटिंग्स उघडत आहे"
      },
      "navigation_work_history": {
        "en": "Opening work history",
        "hi": "वर्क हिस्ट्री खोल रहा हूँ",
        "mr": "वर्क हिस्ट्री उघडत आहे"
      },
      "navigation_home": {
        "en": "Opening home",
        "hi": "होम पेज खोल रहा हूँ",
        "mr": "होम पेज उघडत आहे"
      },
      "navigation_profile": {
        "en": "Opening profile",
        "hi": "प्रोफाइल खोल रहा हूँ",
        "mr": "प्रोफाइल उघडत आहे"
      },
    };

    final Map<String, Widget Function()> intentRoutes = {
      "add_child_screening":     () => const ChildScreeningPage(),
      "add_pregnant_screening":  () => const PregnantScreeningPage(),
      "add_beneficiary":         () => const AddScreeningPage(),
      "add_screening":           () => const AddScreeningPage(),
      "navigation_settings":     () => const SettingsPage(),
      "navigation_work_history": () => const WorkHistoryPage(),
    };

    // Speak response in correct language
    if (intentSpeech.containsKey(intent)) {
      final response =
          intentSpeech[intent]![language] ?? intentSpeech[intent]!["en"]!;
      _tts.speak(response, language);
    }

    // Navigation
    if (intentRoutes.containsKey(intent)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => intentRoutes[intent]!()),
      );
    } else if (intent == "navigation_home") {
      setState(() => _selectedIndex = 0);
    } else if (intent == "navigation_profile") {
      setState(() => _selectedIndex = 1);
    } else {
      _tts.speak("Sorry I did not understand", language);
    }
  }

  // ================= MIC HANDLER ================= //

  Future<void> handleMic() async {
    final path = await _audioService.recordAudio();

    if (path != null) {
      try {
        final result = await VoiceService.sendAudio(File(path));
        print("📡 Backend Response: $result");

        if (result.containsKey("intent")) {
          handleIntent(
            result["intent"].toString(),
            result["language"]?.toString() ?? "en",
          );
        } else {
          print("❌ Backend returned error");
          _tts.speak("Voice processing failed", "en");
        }
      } catch (e) {
        print("❌ Voice error: $e");
        _tts.speak("Something went wrong", "en");
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
      ProfileView(
        name: _userName,
        phoneNumber: _userPhone,
        role: _userRole,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      appBar: const AppBarWithLang(titleKey: "app_title", showBackButton: false),

      body: pages[_selectedIndex],

      // 🎤 MIC BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: handleMic,
        child: const Icon(Icons.mic),
      ),

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
                  child: Icon(
                    Icons.home,
                    color: _selectedIndex == 0
                        ? const Color(0xFF2A6DB5)
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Icon(
                    Icons.person,
                    color: _selectedIndex == 1
                        ? const Color(0xFF2A6DB5)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}