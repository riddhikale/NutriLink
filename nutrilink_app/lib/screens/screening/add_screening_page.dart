import 'package:flutter/material.dart';
import 'child_screening_page.dart';
import 'pregnant_screening_page.dart';

class AddScreeningPage extends StatelessWidget {
  const AddScreeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Screening")),
      body: Column(
        children: [
          _card(context, "Child Screening", const ChildScreeningPage()),
          _card(context, "Pregnant Screening", const PregnantScreeningPage()),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}