import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'home_dashboard.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {

    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔵 HEADER SECTION (Same as Login)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 40,
                left: 20,
                right: 20,
              ),
              decoration: const BoxDecoration(
                color: kLightBlueBg,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [

                  /// 🌐 Language Button (Scrollable + Works)
                  Align(
                    alignment: Alignment.topRight,
                    child: const LanguageSwitcherBtn(),
                  ),

                  const SizedBox(height: 20),

                  /// 👩‍👦 Illustration
                  Container(
                    height: 140,
                    width: 140,
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

                  const SizedBox(height: 25),

                  /// 🏷 Title
          /// 🏷 Title (Same as Login)
          Text(
            t('title'),
            style: GoogleFonts.notoSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
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
              color: Colors.grey[700],
            ),
          ),
                ],
              ),
            ),

            /// 🔽 FORM SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [

                  const SizedBox(height: 40),

                  /// 👤 Name Field
                  TextField(
                    decoration: InputDecoration(
                      labelText: t('full_name'),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: kPrimaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

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

                  /// 🔐 Create PIN
                  TextField(
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: t('create_pin'),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: kPrimaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔵 Register Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const HomeDashboard(),
                        ),
                            (route) => false,
                      );
                    },
                    child: Text(t("register_btn")),
                  ),

                  const SizedBox(height: 20),

                  /// 🔙 Back To Login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(t("login_redirect"),
                      style: TextStyle(
                        color: kPrimaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}