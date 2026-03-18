import 'dart:io';
import 'package:flutter/material.dart';
import '../../../services/audio_service.dart';
import '../../../services/voice_service.dart';
import '../screening/add_screening_page.dart';
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

  void handleIntent(String intent) {
    switch (intent) {
      case "add_beneficiary":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddScreeningPage()),
        );
        break;

      case "view_followups":
        print("Open followups page");
        break;

      case "generate_meal_plan":
        print("Open meal plan page");
        break;

      default:
        print("Unknown command");
    }
  }

  Future<void> handleMic() async {
    final path = await _audioService.recordAudio();

    if (path != null) {
      var result = await VoiceService.sendAudio(File(path));
      handleIntent(result["intent"]);
    }
  }

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

      floatingActionButton: FloatingActionButton(
        onPressed: handleMic,
        child: const Icon(Icons.mic),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

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