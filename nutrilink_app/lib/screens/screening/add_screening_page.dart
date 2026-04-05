import 'package:flutter/material.dart';
import '../../l10n/app_translations.dart';
import 'child_screening_page.dart';
import 'pregnant_screening_page.dart';
import '../../widgets/app_bar_with_lang.dart';


class AddScreeningPage extends StatelessWidget {
  const AddScreeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),


      appBar: const AppBarWithLang(titleKey: "add_screening_title"),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t("choose_screening_type"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            _card(
              context,
              title: t("child_screening_header"),
              subtitle: t("child_screening_sub"),
              icon: Icons.child_care,
              color: Colors.blue,
              page: const ChildScreeningPage(),
            ),

            const SizedBox(height: 16),

            _card(
              context,
              title: t("pregnant_screening_header"),
              subtitle: t("pregnant_screening_sub"),
              icon: Icons.pregnant_woman,
              color: Colors.pink,
              page: const PregnantScreeningPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required Widget page,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            // 🔹 Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(width: 16),

            // 🔹 Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Arrow
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}