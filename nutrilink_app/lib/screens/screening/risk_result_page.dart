import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class RiskResultPage extends StatelessWidget {
  final String risk;

  const RiskResultPage({super.key, required this.risk});

  Color getRiskColor() {
    if (risk == "High") return Colors.red;
    if (risk == "Moderate") return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Risk Result"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      backgroundColor: const Color(0xFFF5F6F8),

      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Icon(
                  Icons.health_and_safety,
                  size: 60,
                  color: getRiskColor(),
                ),

                const SizedBox(height: 15),

                Text(
                  "Risk Level",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  risk,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: getRiskColor(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Meal Plan feature coming soon"),
                        ),
                      );
                    },
                    child: const Text("Generate Meal Plan"),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}