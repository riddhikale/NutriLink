import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'home_dashboard.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: Stack(
        children: [

          /// 🔵 Top Curved Blue Background
          Container(
            height: 230,
            decoration: const BoxDecoration(
              color: kLightBlueBg,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60),
              ),
            ),
          ),

          /// 🌐 Language Switch Button (inside header)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: const LanguageSwitcherBtn(),
          ),

          /// 📄 Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [

                    const SizedBox(height: 60),

                    /// 👩‍👦 Illustration Circle
                    Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryBlue.withOpacity(0.15),
                            blurRadius: 25,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/mother_child.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// 🏷 Title
                    Text(
                      t('title'),
                      style: GoogleFonts.notoSans(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: kPrimaryBlue,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// ✏ Tagline
                    Text(
                      t('tagline'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// 📱 Mobile Field
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: t('mobile_label'),
                        prefixIcon: const Icon(
                          Icons.phone_android,
                          color: kPrimaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// 🔐 PIN Field
                    TextField(
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: t('pin_label'),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: kPrimaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// 🔵 Login Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const HomeDashboard(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize:
                        const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        t('login_btn'),
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ❓ Help Text
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        t('help_link'),
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}