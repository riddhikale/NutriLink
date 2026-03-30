import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';

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
// FOLLOWUP LIST PAGE
// ═════════════════════════════════════════════════════════════
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
        final sA = (a["followUpDate"] ?? a["followupDate"])?["_seconds"] ?? 0;
        final sB = (b["followUpDate"] ?? b["followupDate"])?["_seconds"] ?? 0;
        return sA.compareTo(sB);
      });
      setState(() {
        followups = data;
        isLoading = false;
      });
    } catch (e) {
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
      backgroundColor: kSurface,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────────
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

          // ── Body ────────────────────────────────────────────
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
                        f["beneficiaryId"]?.toString() ?? "N/A";
                    final String date = formatDate(f["followUpDate"] ?? f["followupDate"]);
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
                        onComplete: () => completeFollowup(id),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FollowupDetailPage(
                              data: f,
                              onComplete: () async {
                                await completeFollowup(id);
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
  }
}

// ─────────────────────────────────────────────────────────────
// FOLLOWUP CARD WIDGET
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
              child:
              Icon(_riskIcon(risk), color: _riskColor(risk), size: 22),
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

// ═════════════════════════════════════════════════════════════
// FOLLOWUP DETAIL PAGE
// ═════════════════════════════════════════════════════════════
class FollowupDetailPage extends StatelessWidget {
  final Map data;
  final VoidCallback onComplete;

  const FollowupDetailPage({
    super.key,
    required this.data,
    required this.onComplete,
  });

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kAccentLight,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: kPrimary, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style:
                    GoogleFonts.nunito(fontSize: 12, color: kTextMuted)),
                const SizedBox(height: 2),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMealPlan(BuildContext context, String name, String risk) {
    final String meal = _generateMealPlan(risk);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: kAccentLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.restaurant_menu_rounded,
                          color: kPrimary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Meal Plan",
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: kTextDark)),
                          Text("Recommended for $name",
                              style: GoogleFonts.nunito(
                                  fontSize: 12, color: kTextMuted)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _riskBg(risk),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        risk.toUpperCase(),
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _riskColor(risk)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              // Meal content
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: meal
                      .split('\n')
                      .where((line) => line.trim().isNotEmpty)
                      .map((line) {
                    final isHeader = line.startsWith('##');
                    final isItem = line.startsWith('-');
                    if (isHeader) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Text(
                          line.replaceAll('##', '').trim(),
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: kPrimary),
                        ),
                      );
                    } else if (isItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                  color: kAccent, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                line.replaceFirst('-', '').trim(),
                                style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    color: kTextDark,
                                    height: 1.5),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(line,
                            style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: kTextMuted,
                                height: 1.5)),
                      );
                    }
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _generateMealPlan(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return '''
## Breakfast
- Iron-rich porridge with jaggery and groundnuts
- Boiled egg or dal
- Fresh fruit (banana or papaya)
- Warm milk with turmeric

## Mid-Morning Snack
- Roasted chana or peanuts
- Fresh coconut water

## Lunch
- 2 rotis with green leafy vegetable sabzi (palak/methi)
- Rice with dal (protein-rich)
- Curd / buttermilk
- Seasonal vegetables (cooked with ghee)

## Evening Snack
- Sprouted moong chaat
- Fruit with a handful of nuts

## Dinner
- Khichdi (rice + moong dal) with ghee
- Steamed vegetables or soup
- Warm milk before bed

## Key Nutrients to Focus On
- Iron, Protein, Calcium, Vitamin C, Zinc
''';
      case 'medium':
        return '''
## Breakfast
- Upma or poha with vegetables
- Boiled egg (optional)
- Fresh fruit

## Mid-Morning Snack
- Buttermilk or lassi
- Handful of mixed nuts

## Lunch
- 2 rotis with sabzi
- Rice with dal or sambar
- Salad with lemon dressing

## Evening Snack
- Fruits or roasted snacks
- Herbal tea

## Dinner
- Khichdi or light rice with dal
- Vegetable soup
- Warm milk

## Key Nutrients to Focus On
- Balanced macros, Vitamin A, Iron, Calcium
''';
      default:
        return '''
## Breakfast
- Idli / dosa with sambar
- Fresh fruit or juice
- Milk

## Mid-Morning Snack
- Seasonal fruit
- Nuts

## Lunch
- Rice, dal, sabzi, curd
- Salad

## Evening Snack
- Sprouts or fruit
- Buttermilk

## Dinner
- Roti with dal or vegetable curry
- Warm milk

## Key Nutrients to Focus On
- General balanced diet, Hydration, Fiber
''';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name =
        data["name"]?.toString() ?? data["beneficiaryId"]?.toString() ?? "N/A";
    final String risk = data["riskLevel"]?.toString() ?? "low";
    final String date = formatDate(data["followUpDate"] ?? data["followupDate"]);
    final String address = data["address"]?.toString() ?? "—";

    return Scaffold(
      backgroundColor: kSurface,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
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
                        Text(name,
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_riskIcon(risk),
                                  color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                "${risk.toUpperCase()} RISK",
                                style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ],
                          ),
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

          // ── Detail Body ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Info Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: kAccentLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.event_note_outlined,
                                color: kPrimary, size: 17),
                          ),
                          const SizedBox(width: 10),
                          Text("Follow-up Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimary)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF90CAF9),
                                  Colors.transparent
                                ]),
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        _infoRow(Icons.badge_outlined, "Name", name),
                        _infoRow(Icons.calendar_today_outlined,
                            "Follow-up Date", date),
                        _infoRow(Icons.warning_amber_rounded, "Risk Level",
                            risk.toUpperCase()),
                        _infoRow(Icons.home_outlined, "Address", address),
                      ],
                    ),
                  ),

                  // Meal Plan Button
                  GestureDetector(
                    onTap: () => _showMealPlan(context, name, risk),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.restaurant_menu_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("View Meal Plan",
                                    style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white)),
                                Text(
                                    "Recommended diet for ${risk.toLowerCase()} risk",
                                    style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color:
                                        Colors.white.withOpacity(0.8))),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mark Done Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kPrimary,
                        elevation: 2,
                        shadowColor: kPrimary.withOpacity(0.15),
                        side: const BorderSide(color: kAccent, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onComplete,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              size: 20),
                          const SizedBox(width: 10),
                          Text(
                            "Mark as Done",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}