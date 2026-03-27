import 'package:flutter/material.dart';
import '../profile/settings_page.dart';
import '../profile/work_history_page.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F6FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              // Avatar
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFFBDD7F5),
                child: const Text(
                  'VC',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A6DB5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Name
              const Text(
                'Vedant Chaudhari',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A3A5C),
                ),
              ),
              const SizedBox(height: 4),

              // Role
              const Text(
                'Flutter Developer',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6A9FC0),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),

              // Menu items
              _buildMenuItem(
                context,
                icon: Icons.work_outline_rounded,
                title: 'Work History',
                page: const WorkHistoryPage(),
              ),
              const SizedBox(height: 12),
              _buildMenuItem(
                context,
                icon: Icons.settings_outlined,
                title: 'Settings',
                page: const SettingsPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
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