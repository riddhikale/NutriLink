import 'package:flutter/material.dart';
import '../main.dart'; // adjust import path as needed

class AppBarWithLang extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const AppBarWithLang({
    super.key,
    this.title = '',
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kLightBlueBg,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      title: Text(
        title,
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