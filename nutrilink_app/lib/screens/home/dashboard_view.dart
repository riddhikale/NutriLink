import 'package:flutter/material.dart';
import '../screening/add_screening_page.dart';

class DashboardView extends StatelessWidget {
  final VoidCallback? onAddPressed;

  const DashboardView({
    super.key,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Quick Add Screening
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quick Add Screening",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  "No hot followed",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F6EDB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddScreeningPage(),
                        ),
                      );
                    },
                    child: const Text("Add New"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 🔹 Dashboard Summary
          const Text(
            "Dashboard Summary",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _summaryCard(Icons.check_box, "Screened Today", "2"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(Icons.warning, "High Risk Cases", "0"),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 🔹 Follow-ups
          const Text(
            "Upcoming Follow-ups",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          _followUpCard("ABCD"),
          const SizedBox(height: 12),
          _followUpCard("XYZ"),
        ],
      ),
    );
  }

  Widget _summaryCard(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _followUpCard(String name) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Medium Risk",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Nov 15, 2023",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}