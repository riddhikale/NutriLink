import 'package:flutter/material.dart';
import '../screening/add_screening_page.dart';
import '../../services/api_service.dart';
import 'followup_page.dart';

class DashboardView extends StatefulWidget {
  final VoidCallback? onAddPressed;

  const DashboardView({super.key, this.onAddPressed});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List followups = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFollowups();
  }

  void loadFollowups() async {
    try {
      final data = await ApiService.getFollowups();

      data.sort((a, b) {
        try {
          final dateA = DateTime.parse(a["followUpDate"].toString());
          final dateB = DateTime.parse(b["followUpDate"].toString());
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

      setState(() {
        followups = data;
        isLoading = false;
      });

    } catch (e) {
      print("Error fetching followups: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> completeFollowup(String id) async {
    await ApiService.completeFollowup(id);
    loadFollowups();
  }

  @override
  Widget build(BuildContext context) {
    final displayedFollowups = followups.take(4).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      ).then((_) {
                        loadFollowups();
                      });
                    },

                    child: const Text("Add New"),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

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

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : followups.isEmpty
              ? const Text("No followups")
              : Column(
                  children: [
                      ...displayedFollowups.map((f) {
                        return Column(
                          children: [
                            _followUpCard(
                              f["beneficiaryId"]?.toString() ?? "N/A",
                              f["followUpDate"]?.toString() ?? "No Date",
                              f["riskLevel"]?.toString() ?? "No Risk",
                              f["id"]?.toString() ?? "",
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }).toList(),

                      if (followups.length > 4) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FollowupPage(),
                                ),
                              );
                            },
                            child: const Text("View All Followups"),
                          ),
                        ),
                      ],
                    ],
                ),
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
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _followUpCard(String beneficiaryId,
      String date,
      String status,
      String followupId,) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// LEFT SIDE (ALL TEXT STACKED)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ID
                Text(
                  "ID: $beneficiaryId",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 6),

                /// STATUS + DATE (UNDER ID)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: status == "pending"
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          color: status == "pending"
                              ? Colors.orange.shade800
                              : Colors.green.shade800,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RIGHT SIDE (BUTTON ONLY)
          TextButton(
            onPressed: () => completeFollowup(followupId),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "Done",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}