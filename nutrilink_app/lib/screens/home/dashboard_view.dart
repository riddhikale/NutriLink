import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final VoidCallback onAddPressed;

  const DashboardView({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onAddPressed,
            child: const Text("Add New"),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _summaryCard("Screened Today", "2")),
              const SizedBox(width: 10),
              Expanded(child: _summaryCard("High Risk", "0")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade200,
      child: Column(
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}