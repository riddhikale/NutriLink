import 'package:flutter/material.dart';
import '../profile/settings_page.dart';
import '../profile/work_history_page.dart';

class ProfileView extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String role;

  const ProfileView({
    super.key,
    required this.name,
    required this.phoneNumber,
    this.role = 'NGO Worker',
  });

  @override
  Widget build(BuildContext context) {
    // Generate initials dynamically from name
    final initials = name
        .trim()
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0].toUpperCase())
        .take(2)
        .join();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFFBDD7F5),
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A6DB5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3A5C),
                ),
              ),
              const SizedBox(height: 4),

              // Phone number
              Text(
                phoneNumber,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A90C4),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),

              // Role
              Text(
                role,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6A9FC0),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),

              // Menu items — stretched to full width
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildMenuItem(
                      context,
                      icon: Icons.work_outline_rounded,
                      title: 'Work History',
                      page: const WorkHistoryPage(),
                    ),
                    const SizedBox(height: 12),
                    buildMenuItem(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      page: const SettingsPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget page,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD6E8F8), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4A90C4), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A3A5C),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFABC8E2),
            ),
          ],
        ),
      ),
    );
  }
}