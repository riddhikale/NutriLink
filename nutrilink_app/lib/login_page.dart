import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'home_dashboard.dart';// Import constants and LanguageSwitcherBtn

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Helper for translation shortcut
    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      // Use Stack to place the language switcher on top of the background
      body: Stack(
        children: [
          // 1. The Top Blue Wave Background
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              color: kLightBlueBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          // 2. Main Scrollable Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 100), // Spacing from top

                  // --- Illustration Placeholder ---
                  // Replace this Container with Image.asset or SvgPicture.asset
                  Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: kPrimaryBlue.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10))
                      ],
                    ),
                    // Temporary Icon until you add your illustration asset
                    child: Icon(Icons.family_restroom,
                        size: 80, color: kPrimaryBlue.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 30),

                  // --- Logo & Tagline ---
                  Text(
                    t('title'),
                    style: GoogleFonts.notoSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t('tagline'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- Form Fields ---
                  // Note: Keyboard type ensures numeric pad for mobile
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: t('mobile_label'),
                      prefixIcon: const Icon(Icons.phone_android, color: kPrimaryBlue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: t('pin_label'),
                      prefixIcon: const Icon(Icons.lock_outline, color: kPrimaryBlue),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Login Button ---
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to HomeDashboard
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeDashboard()),
                      );
                    },
                    child: Text(t('login_btn')),
                  ),

                  // --- Help Link ---
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextButton(
                      onPressed: () {
                        // Handle help action
                      },
                      child: Text(
                        t('help_link'),
                        style: GoogleFonts.notoSans(
                            color: kPrimaryBlue, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Bottom padding for scrolling
                ],
              ),
            ),
          ),

          // 3. The Language Switcher positioned at top right
          const Positioned(
            top: 0,
            right: 0,
            child: LanguageSwitcherBtn(),
          ),
        ],
      ),
    );
  }
}