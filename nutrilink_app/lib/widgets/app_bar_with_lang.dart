import 'package:flutter/material.dart';
import '../main.dart';
import '../../l10n/app_translations.dart';

class AppBarWithLang extends StatelessWidget implements PreferredSizeWidget {
  final String? title;       // static fallback
  final String? titleKey;    // translation key  ← new
  final bool showBackButton;

  const AppBarWithLang({
    super.key,
    this.title,
    this.titleKey,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    // Use translated key if provided, else fall back to raw title
    final label = titleKey != null
        ? AppTranslations.t(context, titleKey!)
        : (title ?? '');

    return AppBar(
      backgroundColor: kLightBlueBg,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      title: Text(
        label,
        style: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.bold),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: LanguageSwitcherBtn(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}