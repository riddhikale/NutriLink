import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';
import 'home_dashboard.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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

          /// 🌐 Language Switch Button
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

                    /// 👩‍👦 Illustration
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
                      "Register",
                      style: GoogleFonts.notoSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: kPrimaryBlue,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// 👤 Name Field
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
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
                        labelText: "Mobile Number",
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
                        labelText: "Create PIN",
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize:
                        const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        "Register",
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔙 Back To Login
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Already have an account? Login",
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: kPrimaryBlue,
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