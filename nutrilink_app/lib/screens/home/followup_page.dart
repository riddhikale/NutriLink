import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'followup_provider.dart';
import 'followup_detail_page.dart';

// ─────────────────────────────────────────────────────────────
// Date formatter
// ─────────────────────────────────────────────────────────────
String formatDate(dynamic value) {
  if (value == null) return "No Date";
  try {
    if (value is Map && value.containsKey('_seconds')) {
      final date =
      DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
      return "${date.day}/${date.month}/${date.year}";
    }
    if (value is String) {
      final date = DateTime.tryParse(value);
      if (date != null) return "${date.day}/${date.month}/${date.year}";
    }
    return "Invalid Date";
  } catch (_) {
    return "Invalid Date";
  }
}

// ─────────────────────────────────────────────────────────────
// Colours (shared)
// ─────────────────────────────────────────────────────────────
const Color kPrimary = Color(0xFF1565C0);
const Color kAccent = Color(0xFF1E88E5);
const Color kAccentLight = Color(0xFFE3F2FD);
const Color kSurface = Color(0xFFF5F9FF);
const Color kTextDark = Color(0xFF0D1B2A);
const Color kTextMuted = Color(0xFF546E7A);

Color _riskColor(String risk) {
  switch (risk.toLowerCase()) {
    case 'high':
      return Colors.red.shade600;
    case 'medium':
      return Colors.orange.shade700;
    default:
      return Colors.green.shade700;
  }
}

Color _riskBg(String risk) {
  switch (risk.toLowerCase()) {
    case 'high':
      return Colors.red.shade50;
    case 'medium':
      return Colors.orange.shade50;
    default:
      return Colors.green.shade50;
  }
}

IconData _riskIcon(String risk) {
  switch (risk.toLowerCase()) {
    case 'high':
      return Icons.warning_amber_rounded;
    case 'medium':
      return Icons.info_outline_rounded;
    default:
      return Icons.check_circle_outline_rounded;
  }
}

// ═════════════════════════════════════════════════════════════
// FOLLOWUP LIST PAGE  (now uses FollowUpProvider)
// ═════════════════════════════════════════════════════════════
class FollowupPage extends StatefulWidget {
  const FollowupPage({super.key});

  @override
  State<FollowupPage> createState() => _FollowupPageState();
}

class _FollowupPageState extends State<FollowupPage> {
  @override
  void initState() {
    super.initState();
    // Load on first open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FollowUpProvider>().loadFollowups();
    });
  }

  Future<void> _handleComplete(String id) async {
    try {
      await context.read<FollowUpProvider>().completeFollowup(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text("Follow-up marked as done!",
                    style: GoogleFonts.nunito(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update. Please try again.",
                style: GoogleFonts.nunito(color: Colors.white)),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowUpProvider>(
      builder: (context, provider, _) {
        final followups = provider.pendingFollowups;
        final isLoading = provider.isLoading;

        return Scaffold(
          backgroundColor: kSurface,
          body: CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: kPrimary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                      ),
                    ),
                    child: Stack(children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 18,
                        left: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Follow-ups",
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Text("Scheduled beneficiary visits",
                                style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color: Colors.white.withOpacity(0.85))),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              // ── Body ─────────────────────────────────────
              if (isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: kAccent),
                  ),
                )
              else if (followups.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available_outlined,
                            size: 56, color: kAccent.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        Text("No follow-ups scheduled",
                            style: GoogleFonts.poppins(
                                color: kTextMuted, fontSize: 15)),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final f = followups[index];
                        final String name = f["name"]?.toString() ??
                            f["beneficiaryId"]?.toString() ??
                            "N/A";
                        final String date = formatDate(
                            f["followUpDate"] ?? f["followupDate"]);
                        final String risk =
                            f["riskLevel"]?.toString() ?? "low";
                        final String id = f["id"]?.toString() ?? "";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FollowUpCard(
                            name: name,
                            date: date,
                            risk: risk,
                            followupId: id,
                            data: f,
                            onComplete: () => _handleComplete(id),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FollowupDetailPage(
                                  data: f,
                                  onComplete: () async {
                                    await _handleComplete(id);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: followups.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FOLLOWUP CARD WIDGET  (unchanged from original)
// ─────────────────────────────────────────────────────────────
class FollowUpCard extends StatelessWidget {
  final String name;
  final String date;
  final String risk;
  final String followupId;
  final Map data;
  final VoidCallback onComplete;
  final VoidCallback onTap;

  const FollowUpCard({
    super.key,
    required this.name,
    required this.date,
    required this.risk,
    required this.followupId,
    required this.data,
    required this.onComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _riskBg(risk),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_riskIcon(risk), color: _riskColor(risk), size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: kTextDark)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _riskBg(risk),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          risk.toUpperCase(),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _riskColor(risk)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today_outlined,
                          size: 12, color: kTextMuted),
                      const SizedBox(width: 4),
                      Text(date,
                          style: GoogleFonts.nunito(
                              fontSize: 12, color: kTextMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: kAccent, size: 22),
          ],
        ),
      ),
    );
  }
}