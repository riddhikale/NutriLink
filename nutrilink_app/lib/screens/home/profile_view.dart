import 'package:flutter/material.dart';
import '../profile/settings_page.dart';
import '../profile/work_history_page.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        const Text("Vedant Chaudhari"),

        _btn(context, "Settings", const SettingsPage()),
        _btn(context, "Work History", const WorkHistoryPage()),
      ],
    );
  }

  Widget _btn(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}