import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class FollowupPage extends StatefulWidget {
  const FollowupPage({super.key});

  @override
  State<FollowupPage> createState() => _FollowupPageState();
}

class _FollowupPageState extends State<FollowupPage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text("All Followups")),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : followups.isEmpty
          ? const Center(child: Text("No followups"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: followups.length,
        itemBuilder: (context, index) {
          final f = followups[index];

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
        },
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