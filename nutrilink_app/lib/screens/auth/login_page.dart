import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../../l10n/app_translations.dart';
import '../home/home_dashboard.dart';
import 'register_page.dart';
import '../../services/api_service.dart';
import '../../widgets/app_bar_with_lang.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: const AppBarWithLang(titleKey: "app_title", showBackButton: false),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔵 HEADER SECTION
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

                  const SizedBox(height: 20),

                  /// 👩‍👦 Mother-Child Image
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

                  /// 🏷 Title (Below Image)
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

                  /// 📱 Mobile Field
                  TextField(
                    controller: phoneController,
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
                    controller: pinController,
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
                    onPressed: () async {
                      final result = await ApiService.loginUser(
                        phone: phoneController.text,
                        pin: pinController.text,
                      );
                      ApiService.authToken = result["token"];

                      print(result);

                      if (result["success"] == true) {

                        String token = result["token"];

                        // You can store token later

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeDashboard(),
                          ),
                        );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result["message"] ?? "Login failed")),
                        );
                      }
                    },
                    child: Text(t('login_btn')),
                  ),

                  const SizedBox(height: 20),

                  /// ❓ Register Redirect
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      t('register_redirect'),
                      style: const TextStyle(
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