import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'screens/home/followup_provider.dart';
import 'screens/home/home_dashboard.dart';
import 'l10n/app_translations.dart'; // ← new import

// --- CONSTANTS ---
const Color kPrimaryBlue = Color(0xFF1976D2);
const Color kLightBlueBg = Color(0xFFE3F2FD);
const Color kTextColor = Color(0xFF2D2D2D);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FollowUpProvider()),
      ],
      child: const NutriLinkApp(),
    ),
  );
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
      routes: {
        '/dashboard': (context) => const HomeDashboard(),
      },
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
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryBlue),
        textTheme: GoogleFonts.notoSansTextTheme()
            .apply(bodyColor: kTextColor, displayColor: kTextColor),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1.5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              const BorderSide(color: kPrimaryBlue, width: 2.5)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.notoSans(
                fontSize: 18, fontWeight: FontWeight.w700),
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
    Locale currentLocale = Localizations.localeOf(context);

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
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
    );
  }
}