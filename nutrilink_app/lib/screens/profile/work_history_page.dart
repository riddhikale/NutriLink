import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_translations.dart';
import '../home/followup_provider.dart';
import '../../widgets/app_bar_with_lang.dart';

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────
String formatDate(dynamic value,
    {String noDate = 'No Date', String invalidDate = 'Invalid Date'}) {
  if (value == null) return noDate;
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
    return invalidDate;
  } catch (_) {
    return invalidDate;
  }
}

DateTime? _toDateTime(dynamic value) {
  try {
    if (value is Map && value.containsKey('_seconds')) {
      return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
    }
    if (value is String) return DateTime.tryParse(value);
  } catch (_) {}
  return null;
}

Map<String, List> _groupByMonth(List followups) {
  final Map<String, List> grouped = {};
  for (final f in followups) {
    final rawDate = f["completedAt"] ?? f["followUpDate"] ?? f["followupDate"];
    final dt = _toDateTime(rawDate) ?? DateTime.now();
    final key = "${_monthName(dt.month)} ${dt.year}";
    grouped.putIfAbsent(key, () => []).add(f);
  }
  for (final key in grouped.keys) {
    grouped[key]!.sort((a, b) {
      final dA = _toDateTime(
          a["completedAt"] ?? a["followUpDate"] ?? a["followupDate"]);
      final dB = _toDateTime(
          b["completedAt"] ?? b["followUpDate"] ?? b["followupDate"]);
      return (dB ?? DateTime(0)).compareTo(dA ?? DateTime(0));
    });
  }
  return grouped;
}

String _monthName(int month) {
  const months = [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month];
}

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

const Color kPrimary     = Color(0xFF1565C0);
const Color kAccent      = Color(0xFF1E88E5);
const Color kAccentLight = Color(0xFFE3F2FD);
const Color kSurface     = Color(0xFFF5F9FF);
const Color kTextDark    = Color(0xFF0D1B2A);
const Color kTextMuted   = Color(0xFF546E7A);

// ═════════════════════════════════════════════════════════════
// WORK HISTORY PAGE
// ═════════════════════════════════════════════════════════════
class WorkHistoryPage extends StatefulWidget {
  const WorkHistoryPage({super.key});

  @override
  State<WorkHistoryPage> createState() => _WorkHistoryPageState();
}

class _WorkHistoryPageState extends State<WorkHistoryPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FollowUpProvider>().loadFollowups();
    });
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Consumer<FollowUpProvider>(
      builder: (context, provider, _) {
        final allCompleted = provider.completedFollowups;
        final filtered = _searchQuery.isEmpty
            ? allCompleted
            : allCompleted.where((f) {
          final name = (f["name"]?.toString() ??
              f["beneficiaryId"]?.toString() ??
              "")
              .toLowerCase();
          return name.contains(_searchQuery.toLowerCase());
        }).toList();

        final grouped   = _groupByMonth(filtered);
        final monthKeys = grouped.keys.toList();

        return Scaffold(
          backgroundColor: kSurface,
          appBar:
          const AppBarWithLang(titleKey: 'app_title', showBackButton: false),
          body: CustomScrollView(
            slivers: [
              // ── Sliver App Bar ──────────────────────────
              SliverAppBar(
                expandedHeight: 150,
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
                        bottom: 20,
                        left: 20,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('work_history'),
                              style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              t('completed_followups'),
                              style: GoogleFonts.nunito(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.85)),
                            ),
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

              // ── Stats ────────────────────────────────────
              SliverToBoxAdapter(
                child: _StatsRow(allCompleted: allCompleted),
              ),

              // ── Search ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (val) =>
                        setState(() => _searchQuery = val),
                    style: GoogleFonts.nunito(
                        fontSize: 14, color: kTextDark),
                    decoration: InputDecoration(
                      hintText: t('search_hint'),
                      hintStyle: GoogleFonts.nunito(
                          fontSize: 14, color: kTextMuted),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: kAccent),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        const BorderSide(color: Color(0xFFD6E8F8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        const BorderSide(color: Color(0xFFD6E8F8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: kAccent, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Loading ──────────────────────────────────
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(
                      child: CircularProgressIndicator(color: kAccent)),
                )

              // ── Empty ────────────────────────────────────
              else if (filtered.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history_rounded,
                            size: 60,
                            color: kAccent.withOpacity(0.3)),
                        const SizedBox(height: 14),
                        Text(
                          _searchQuery.isEmpty
                              ? t('no_completed_followups')
                              : '${t('no_search_results')} "$_searchQuery"',
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: kTextMuted),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            t('mark_done_hint'),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 13, color: kTextMuted),
                          ),
                        ],
                      ],
                    ),
                  ),
                )

              // ── List ─────────────────────────────────────
              else
                SliverPadding(
                  padding:
                  const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final monthKey = monthKeys[index];
                        final items = grouped[monthKey]!;
                        return _MonthSection(
                            monthKey: monthKey, items: items);
                      },
                      childCount: monthKeys.length,
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
// Stats Row
// ─────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final List allCompleted;
  const _StatsRow({required this.allCompleted});

  int _countThisMonth(List items) {
    final now = DateTime.now();
    return items.where((f) {
      final dt = _toDateTime(
          f["completedAt"] ?? f["followUpDate"] ?? f["followupDate"]);
      return dt != null &&
          dt.month == now.month &&
          dt.year == now.year;
    }).length;
  }

  int _countThisWeek(List items) {
    final now = DateTime.now();
    final weekStart =
    now.subtract(Duration(days: now.weekday - 1));
    return items.where((f) {
      final dt = _toDateTime(
          f["completedAt"] ?? f["followUpDate"] ?? f["followupDate"]);
      return dt != null &&
          dt.isAfter(
              weekStart.subtract(const Duration(days: 1)));
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        children: [
          _StatCard(
              label: t('stat_total'),
              value: allCompleted.length.toString(),
              icon: Icons.check_circle_rounded,
              color: kPrimary),
          const SizedBox(width: 10),
          _StatCard(
              label: t('stat_this_month'),
              value: _countThisMonth(allCompleted).toString(),
              icon: Icons.calendar_month_rounded,
              color: Colors.teal.shade600),
          const SizedBox(width: 10),
          _StatCard(
              label: t('stat_this_week'),
              value: _countThisWeek(allCompleted).toString(),
              icon: Icons.today_rounded,
              color: Colors.deepPurple.shade400),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
        required this.value,
        required this.icon,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD6E8F8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: kTextDark)),
            Text(label,
                style:
                GoogleFonts.nunito(fontSize: 11, color: kTextMuted)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Month Section
// ─────────────────────────────────────────────────────────────
class _MonthSection extends StatelessWidget {
  final String monthKey;
  final List items;
  const _MonthSection({required this.monthKey, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Row(
            children: [
              Text(monthKey,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kPrimary)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: kAccentLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Text("${items.length}",
                    style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: kAccent)),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Container(
                      height: 1,
                      color: const Color(0xFFD6E8F8))),
            ],
          ),
        ),
        ...items.map((f) => _WorkHistoryCard(followup: f)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Work History Card
// ─────────────────────────────────────────────────────────────
class _WorkHistoryCard extends StatelessWidget {
  final Map followup;
  const _WorkHistoryCard({required this.followup});

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    final String name = followup["name"]?.toString() ??
        followup["beneficiaryId"]?.toString() ??
        "N/A";
    final String risk =
        followup["riskLevel"]?.toString() ?? "low";
    final String followupDate = formatDate(
      followup["followUpDate"] ?? followup["followupDate"],
      noDate: t('no_date'),
      invalidDate: t('invalid_date'),
    );
    final String completedDate = formatDate(
      followup["completedAt"],
      noDate: t('no_date'),
      invalidDate: t('invalid_date'),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6E8F8)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.check_circle_rounded,
                color: Colors.green.shade600, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kTextDark)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                          color: _riskBg(risk),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(risk.toUpperCase(),
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: _riskColor(risk))),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.event_available_outlined,
                        size: 12, color: kTextMuted),
                    const SizedBox(width: 3),
                    Text(followupDate,
                        style: GoogleFonts.nunito(
                            fontSize: 11, color: kTextMuted)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  t('status_done'),
                  style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700),
                ),
              ),
              if (completedDate != t('no_date')) ...[
                const SizedBox(height: 4),
                Text(completedDate,
                    style: GoogleFonts.nunito(
                        fontSize: 10, color: kTextMuted)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}