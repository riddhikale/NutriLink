import 'package:flutter/material.dart';

class WorkHistoryPage extends StatelessWidget {
  const WorkHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Work History")),
      body: const ListTile(title: Text("History data")),
    );
  }
}