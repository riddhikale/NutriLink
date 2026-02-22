import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
// Import the other files we will create later
// import 'login_page.dart';
// import 'home_dashboard.dart';

// --- CONSTANTS & THEME ---
const Color kPrimaryBlue = Color(0xFF1976D2);
const Color kLightBlueBg = Color(0xFFE3F2FD);
const Color kTextColor = Color(0xFF2D2D2D);

void main() {
  runApp(const NutriLinkApp());
}

// --- SIMPLE TRANSLATION MOCKUP ---
// In a real app, use flutter_localizations and ARB files.
class AppTranslations {
  static Map<String, Map<String, String>> localizedValues = {
    'en': {
      'title': 'NutriLink',
      'tagline': 'Empowering Health, One Visit at a Time.',
      'mobile_label': 'Mobile Number',
      'pin_label': 'PIN',
      'login_btn': 'Log In',
      'help_link': 'Need Help Logging In?',
      'home_tab': 'Home',
      'profile_tab': 'Profile',
    },
    'hi': {
      'title': 'न्यूट्रिलिंक',
      'tagline': 'स्वास्थ्य को सशक्त बनाना, एक समय में एक यात्रा।',
      'mobile_label': 'मोबाइल नंबर',
      'pin_label': 'पिन',
      'login_btn': 'लॉग इन करें',
      'help_link': 'लॉगिन करने में सहायता चाहिए?',
      'home_tab': 'होम',
      'profile_tab': 'प्रोफ़ाइल',
    },
  };

  static String t(BuildContext context, String key) {
    Locale currentLocale = Localizations.localeOf(context);
    String langCode = currentLocale.languageCode;
    // Default to English if translation not found
    return localizedValues[langCode]?[key] ?? localizedValues['en']![key]!;
  }
}

class NutriLinkApp extends StatefulWidget {
  const NutriLinkApp({super.key});

  // Function to allow changing locale from anywhere
  static void setLocale(BuildContext context, Locale newLocale) {
    _NutriLinkAppState? state =
    context.findAncestorStateOfType<_NutriLinkAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<NutriLinkApp> createState() => _NutriLinkAppState();
}

class _NutriLinkAppState extends State<NutriLinkApp> {
  Locale _locale = const Locale('en', 'US');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriLink',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [Locale('en', 'US'), Locale('hi', 'IN')],
      // Basic localization setup required for text direction etc.
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryBlue),
        textTheme: GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: kTextColor, displayColor: kTextColor),
        // Define standard input style globally
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimaryBlue, width: 2.5)),
        ),
        // Define standard button style globally
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.notoSans(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      // Temporarily pointing to Login Page. Change later.
      home: const LoginPage(),
    );
  }
}

// --- REUSABLE LANGUAGE SWITCHER WIDGET ---
class LanguageSwitcherBtn extends StatelessWidget {
  const LanguageSwitcherBtn({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    bool isEnglish = currentLocale.languageCode == 'en';

    return Container(
      margin: const EdgeInsets.only(top: 50, right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kPrimaryBlue.withOpacity(0.1), // Subtle background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {
          Locale newLocale =
          isEnglish ? const Locale('hi', 'IN') : const Locale('en', 'US');
          NutriLinkApp.setLocale(context, newLocale);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, color: kPrimaryBlue, size: 18),
            const SizedBox(width: 6),
            Text(
              isEnglish ? 'EN' : 'हिंदी',
              style: GoogleFonts.notoSans(
                  color: kPrimaryBlue, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down, color: kPrimaryBlue),
          ],
        ),
      ),
    );
  }
}