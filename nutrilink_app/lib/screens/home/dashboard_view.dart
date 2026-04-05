import 'package:flutter/material.dart';
import '../../l10n/app_translations.dart';
import '../screening/add_screening_page.dart';
import '../../services/api_service.dart';
import 'followup_page.dart';
import 'followup_detail_page.dart';

String formatDate(dynamic value) {
  if (value == null) return "No Date";
  try {
    if (value is Map && value.containsKey('_seconds')) {
      final date = DateTime.fromMillisecondsSinceEpoch(
          value['_seconds'] * 1000);
      return "${date.day}/${date.month}/${date.year}";
    }
    if (value is String) {
      final date = DateTime.tryParse(value);
      if (date != null) return "${date.day}/${date.month}/${date.year}";
    }
    return "Invalid Date";
  } catch (e) {
    return "Invalid Date";
  }
}

class DashboardView extends StatefulWidget {
  final VoidCallback? onAddPressed;
  const DashboardView({super.key, this.onAddPressed});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List followups = [];
  bool isLoading = true;

  List alerts = [];

  int screenedToday = 0;
  int highRiskCases = 0;

  @override
  void initState() {
    super.initState();
    loadFollowups();
    loadAlerts();
  }

  void loadFollowups() async {
    try {
      final data = await ApiService.getFollowups();
      data.sort((a, b) {
        try {
          final sA = (a["followUpDate"] ?? a["followupDate"])?["_seconds"] ?? 0;
          final sB = (b["followUpDate"] ?? b["followupDate"])?["_seconds"] ?? 0;
          return sA.compareTo(sB);
        } catch (e) {
          return 0;
        }
      });
      setState(() {
        followups = data;
        isLoading = false;
      });
      loadSummaryStats(); // called AFTER setState, so followups is populated
    } catch (e) {
      print("Error fetching followups: $e");
      setState(() => isLoading = false);
    }
  }

  void loadAlerts() async {
  try {
    final data = await ApiService.getAlerts();

    setState(() {
      alerts = data;
    });

  } catch (e) {
    print("Error fetching alerts: $e");
  }
}

  void loadSummaryStats() {
    final today = DateTime.now();
    final currentPhone = ApiService.currentUserPhone;

    final myFollowups = followups.where((f) {
      return f["workerId"]?.toString() == currentPhone;
    }).toList();

    final todayDate = DateTime(today.year, today.month, today.day);

    final todayCount = myFollowups.where((f) {
      final raw = f["createdAt"];
      DateTime? date;

      if (raw is Map && raw.containsKey('_seconds')) {
        date = DateTime.fromMillisecondsSinceEpoch(
          raw['_seconds'] * 1000,
          isUtc: true,
        ).toLocal();
      } else if (raw is String) {
        date = DateTime.tryParse(raw)?.toLocal();
      }

      if (date == null) return false;

      final itemDate = DateTime(date.year, date.month, date.day);

      return itemDate == todayDate;
    }).length;

    final highRiskCount = myFollowups.where((f) {
      final raw = f["createdAt"];
      DateTime? date;

      if (raw is Map && raw.containsKey('_seconds')) {
        date = DateTime.fromMillisecondsSinceEpoch(
          raw['_seconds'] * 1000,
          isUtc: true,
        ).toLocal();
      } else if (raw is String) {
        date = DateTime.tryParse(raw)?.toLocal();
      }

      if (date == null) return false;

      final itemDate = DateTime(date.year, date.month, date.day);

      return itemDate == todayDate &&
          f["riskLevel"]?.toString().toLowerCase() == "high";
    }).length;

    setState(() {
      screenedToday = todayCount;
      highRiskCases = highRiskCount;
    });
  }

  Future<void> completeFollowup(String id) async {
    await ApiService.completeFollowup(id);
    loadFollowups();
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);
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
                 Text(t("quick_add_screening"),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                 Text(t("add_new_screening"),
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F6EDB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AddScreeningPage()),
                      ).then((_) {
                        loadFollowups(); // this already calls loadSummaryStats() internally
                      });
                    },
                    child: Text(t("add_new")),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(t("dashboard_summary"),
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  Icons.check_box,
                  t("screened_today"),
                  screenedToday.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  Icons.warning,
                  t("high_risk_cases"),
                  highRiskCases.toString(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          if (alerts.isNotEmpty) ...[
            const Text(
              "🚨 Alerts",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...alerts.map((a) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  a["message"] ?? "High risk detected",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }).toList(),
          ],

          isLoading
              ? const Center(child: CircularProgressIndicator())
              : followups.isEmpty
              ? Text(t("no_followups_found"))
              : Column(
            children: [
              ...displayedFollowups.map((f) {
                final String name = f["name"]?.toString() ??
                    f["beneficiaryId"]?.toString() ?? "N/A";
                final String date = formatDate(f["followUpDate"] ?? f["followupDate"]);
                final String risk =
                    f["riskLevel"]?.toString() ?? "low";
                final String id = f["id"]?.toString() ?? "";

                return Column(
                  children: [
                    FollowUpCard(
                      name: name,
                      date: date,
                      risk: risk,
                      followupId: id,
                      data: f,
                      onComplete: () => completeFollowup(id),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FollowupDetailPage(
                            data: f,
                            onComplete: () async {
                              await completeFollowup(id);
                              if (context.mounted)
                                Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FollowupPage()),
                    ),
                    child: Text(t("view_all_followups")),
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
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}