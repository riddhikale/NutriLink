import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'login_page.dart';

// --- CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF1976D2);
const Color kLightBlueBg = Color(0xFFE3F2FD);
const Color kTextColor = Color(0xFF2D2D2D);

void main() {
  runApp(const NutriLinkApp());
}

// --- SIMPLE TRANSLATION MAP ---
class AppTranslations {
  static Map<String, Map<String, String>> localizedValues = {
    'en': {
      'title': 'NutriLink',
      'tagline': 'Empowering Health, One Visit at a Time.',
      'mobile_label': 'Mobile Number',
      'pin_label': 'PIN',
      'login_btn': 'Log In',
      'register_redirect': 'Not a User? Register',
      'full_name': 'Full Name',
      'create_pin': 'Create Pin',
      'login_redirect': 'Already have an account?Login',
      'register_btn': 'Register',
      'home_tab': 'Home',
      'profile_tab': 'Profile',
      'home_content': 'Dashboard Home Content',
      'profile_content': 'Profile Settings Content',
      'child_module': 'Child Screening',
      'pregnant_module': 'Pregnant Women',
    },
    'hi': {
      'title': 'न्यूट्रिलिंक',
      'tagline': 'स्वास्थ्य को सशक्त बनाना, एक समय में एक यात्रा।',
      'mobile_label': 'मोबाइल नंबर',
      'pin_label': 'पिन',
      'login_btn': 'लॉग इन करें',
      'register_redirect': 'उपयोगकर्ता नहीं? पंजीकरण करवाना',
      'full_name': 'पूरा नाम',
      'create_pin': 'पिन बनाएं',
      'login_redirect': 'क्या आपके पास पहले से ही खाता है?लॉग इन करें',
      'register_btn': 'पंजीकरण करवाना',
      'home_tab': 'होम',
      'profile_tab': 'प्रोफ़ाइल',
      'home_content': 'डैशबोर्ड होम सामग्री',
      'profile_content': 'प्रोफ़ाइल सेटिंग सामग्री',
      'child_module': 'बाल स्क्रीनिंग',
      'pregnant_module': 'गर्भवती महिला',
    },
    'mr': {
      'title': 'न्यूट्रिलिंक',
      'tagline': 'आरोग्य सशक्त बनवणे, प्रत्येक भेटीसोबत.',
      'mobile_label': 'मोबाईल क्रमांक',
      'pin_label': 'पिन',
      'login_btn': 'लॉग इन करा',
      'register_redirect': 'वापरकर्ता नाही? नोंदणी करा',
      'full_name': 'पूर्ण नाव',
      'create_pin': 'पिन तयार करा',
      'login_redirect': 'आधीच खाते आहे?लॉगिन',
      'register_btn': 'नोंदणी करा',
      'home_tab': 'मुख्यपृष्ठ',
      'profile_tab': 'प्रोफाइल',
      'home_content': 'डॅशबोर्ड मुख्य सामग्री',
      'profile_content': 'प्रोफाइल सेटिंग सामग्री',
      'child_module': 'बाल तपासणी',
      'pregnant_module': 'गर्भवती महिला',
    },
  };

  static String t(BuildContext context, String key) {
    Locale currentLocale = Localizations.localeOf(context);
    String langCode = currentLocale.languageCode;
    return localizedValues[langCode]?[key] ??
        localizedValues['en']![key]!;
  }
}

class NutriLinkApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _NutriLinkAppState? state =
    context.findAncestorStateOfType<_NutriLinkAppState>();
    state?.setLocale(newLocale);
  }

  const NutriLinkApp({super.key});

  @override
  State<NutriLinkApp> createState() => _NutriLinkAppState();
}

class _NutriLinkAppState extends State<NutriLinkApp> {
  Locale _locale = const Locale('en');

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

      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
        home: LoginPage(
          key: ValueKey(_locale.languageCode),
        ),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme:
        ColorScheme.fromSeed(seedColor: kPrimaryBlue),
        textTheme: GoogleFonts.notoSansTextTheme()
            .apply(bodyColor: kTextColor, displayColor: kTextColor),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.grey.shade300, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: kPrimaryBlue, width: 2.5)),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryBlue,
            foregroundColor: Colors.white,
            minimumSize:
            const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12)),
            textStyle: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

// --- LANGUAGE SWITCHER ---
class LanguageSwitcherBtn extends StatelessWidget {
  const LanguageSwitcherBtn({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale =
    Localizations.localeOf(context);
    print("Login rebuilt: ${Localizations.localeOf(context)}");

    String label;
    if (currentLocale.languageCode == 'en') {
      label = 'EN';
    } else if (currentLocale.languageCode == 'hi') {
      label = 'हिंदी';
    } else {
      label = 'मराठी';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Locale current = Localizations.localeOf(context);

          Locale newLocale;

          if (current.languageCode == 'en') {
            newLocale = const Locale('hi');
          } else if (current.languageCode == 'hi') {
            newLocale = const Locale('mr');
          } else {
            newLocale = const Locale('en');
          }

          NutriLinkApp.setLocale(context, newLocale);
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: kPrimaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kPrimaryBlue.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.translate, color: kPrimaryBlue, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.notoSans(
                  color: kPrimaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: kPrimaryBlue),
            ],
          ),
        ),
      ),
    );  }
}