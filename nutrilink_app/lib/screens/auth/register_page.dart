import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../home/home_dashboard.dart';
import '../../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();

  static const String defaultRole = "FIELD_WORKER";

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String pin = pinController.text.trim();

    if (name.isEmpty || phone.isEmpty || pin.isEmpty) {
      showMessage("All fields are required");
      return;
    }

    if (phone.length != 10) {
      showMessage("Enter valid 10-digit mobile number");
      return;
    }

    if (pin.length != 4) {
      showMessage("PIN must be 4 digits");
      return;
    }

    setState(() => isLoading = true);

    try {
      await ApiService.registerUser(
        name: name,
        phone: phone,
        pin: pin,
        role: defaultRole, // Automatically assigned
        assignedAreaId: "AREA01",
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeDashboard(),
        ),
            (route) => false,
      );
    } catch (e) {
      print("Registration error: $e");
      showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
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
                  Align(
                    alignment: Alignment.topRight,
                    child: const LanguageSwitcherBtn(),
                  ),
                  const SizedBox(height: 20),

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
                    controller: nameController,
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

                  /// 🔐 Create PIN
                  TextField(
                    controller: pinController,
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : registerUser,
                      child: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(t("register_btn")),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔙 Back To Login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      t("login_redirect"),
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