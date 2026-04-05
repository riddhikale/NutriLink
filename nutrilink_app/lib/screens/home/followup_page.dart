import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'followup_provider.dart';
import 'followup_detail_page.dart';
import '../../widgets/app_bar_with_lang.dart';
import '../../l10n/app_translations.dart';

// formatDate stays non-localized here since it's a utility —
// pass localized 'no_date' / 'invalid_date' strings where needed
String formatDate(dynamic value, {String noDate = 'No Date', String invalidDate = 'Invalid Date'}) {
  if (value == null) return noDate;
  try {
    if (value is Map && value.containsKey('_seconds')) {
      final date = DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
      return "${date.day}/${date.month}/${date.year}";
    }
    if (value is String) {
      final date = DateTime.tryParse(value);
      if (date != null) return "${date.day}/${date.month}/${date.year}";
    }
    return invalidDate;
  } catch (_) {
    return invalidDate;
  }
}

const Color kPrimary     = Color(0xFF1565C0);
const Color kAccent      = Color(0xFF1E88E5);
const Color kAccentLight = Color(0xFFE3F2FD);
const Color kSurface     = Color(0xFFF5F9FF);
const Color kTextDark    = Color(0xFF0D1B2A);
const Color kTextMuted   = Color(0xFF546E7A);

Color _riskColor(String risk) {
  switch (risk.toLowerCase()) {
    case 'high':   return Colors.red.shade600;
    case 'medium': return Colors.orange.shade700;
    default:       return Colors.green.shade700;
  }
}

Color _riskBg(String risk) {
  switch (risk.toLowerCase()) {
    case 'high':   return Colors.red.shade50;
    case 'medium': return Colors.orange.shade50;
    default:       return Colors.green.shade50;
  }
}

IconData _riskIcon(String risk) {
  switch (risk.toLowerCase()) {
    case 'high':   return Icons.warning_amber_rounded;
    case 'medium': return Icons.info_outline_rounded;
    default:       return Icons.check_circle_outline_rounded;
  }
}

class FollowupPage extends StatefulWidget {
  final String? initialRisk;
  const FollowupPage({super.key, this.initialRisk});

  @override
  State<FollowupPage> createState() => _FollowupPageState();
}

class _FollowupPageState extends State<FollowupPage> {
  String _selectedRisk = 'all';

  @override
  void initState() {
    super.initState();
    if (widget.initialRisk != null) {
      _selectedRisk = widget.initialRisk!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FollowUpProvider>().loadFollowups();
    });
  }

  Future<void> _handleComplete(String id, String Function(String) t) async {
    try {
      await context.read<FollowUpProvider>().completeFollowup(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Text(t('followup_done'), style: GoogleFonts.nunito(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t('followup_failed'), style: GoogleFonts.nunito(color: Colors.white)),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Widget _filterChip(String value, String label) {
    final isSelected = _selectedRisk == value;
    final Map<String, Color> bgColors = {
      'all':    kAccentLight,
      'high':   Colors.red.shade50,
      'medium': Colors.orange.shade50,
      'low':    Colors.green.shade50,
    };
    final Map<String, Color> textColors = {
      'all':    kPrimary,
      'high':   Colors.red.shade700,
      'medium': Colors.orange.shade800,
      'low':    Colors.green.shade700,
    };

    return GestureDetector(
      onTap: () => setState(() => _selectedRisk = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? bgColors[value] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? textColors[value]!.withOpacity(0.4)
                : const Color(0xFFDDE3EA),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? textColors[value] : kTextMuted,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Consumer<FollowUpProvider>(
      builder: (context, provider, _) {
        final allFollowups = provider.pendingFollowups;
        final followups = _selectedRisk == 'all'
            ? allFollowups
            : allFollowups.where((f) =>
        f["riskLevel"]?.toString().toLowerCase() == _selectedRisk
        ).toList();
        final isLoading = provider.isLoading;

        return Scaffold(
          backgroundColor: kSurface,
          appBar: const AppBarWithLang(titleKey: 'app_title', showBackButton: false),
          body: CustomScrollView(
            slivers: [
              // ── Gradient Header ──────────────────────────
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
                        right: -20, top: -20,
                        child: Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 18, left: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t('followups_title'),
                                style: GoogleFonts.poppins(
                                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text(t('followups_subtitle'),
                                style: GoogleFonts.nunito(
                                    fontSize: 13, color: Colors.white.withOpacity(0.85))),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              // ── Filter Chips ─────────────────────────────
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _filterChip('all',    t('filter_all')),
                      const SizedBox(width: 8),
                      _filterChip('high',   t('filter_high_risk')),
                      const SizedBox(width: 8),
                      _filterChip('medium', t('filter_medium_risk')),
                      const SizedBox(width: 8),
                      _filterChip('low',    t('filter_low_risk')),
                    ],
                  ),
                ),
              ),

              // ── Body ─────────────────────────────────────
              if (isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: kAccent)),
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
                        Text(
                          _selectedRisk == 'all'
                              ? t('no_followups_scheduled')
                              : t('no_risk_followups').replaceAll('{risk}', _selectedRisk),
                          style: GoogleFonts.poppins(color: kTextMuted, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final f = followups[index];
                        final String name = f["name"]?.toString() ??
                            f["beneficiaryId"]?.toString() ?? "N/A";
                        final String date = formatDate(
                          f["followUpDate"] ?? f["followupDate"],
                          noDate: t('no_date'),
                          invalidDate: t('invalid_date'),
                        );
                        final String risk = f["riskLevel"]?.toString() ?? "low";
                        final String id   = f["id"]?.toString() ?? "";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FollowUpCard(
                            name: name,
                            date: date,
                            risk: risk,
                            followupId: id,
                            data: f,
                            onComplete: () => _handleComplete(id, t),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FollowupDetailPage(
                                  data: f,
                                  onComplete: () async {
                                    await _handleComplete(id, t);
                                    if (context.mounted) Navigator.pop(context);
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

// ── FollowUpCard ──────────────────────────────────────────────────────────────
// This widget is used in other pages too, so it stays simple —
// date and name are already localized before being passed in.

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
              width: 44, height: 44,
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
                          fontWeight: FontWeight.w600, fontSize: 15, color: kTextDark)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _riskBg(risk),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          risk.toUpperCase(),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700, color: _riskColor(risk)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today_outlined, size: 12, color: kTextMuted),
                      const SizedBox(width: 4),
                      Text(date, style: GoogleFonts.nunito(fontSize: 12, color: kTextMuted)),
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