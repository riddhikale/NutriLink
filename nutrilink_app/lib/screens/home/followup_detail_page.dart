import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../../widgets/app_bar_with_lang.dart';
import '../../l10n/app_translations.dart';

// ─────────────────────────────────────────────────────────────
// Date formatter
// ─────────────────────────────────────────────────────────────
String formatDate(dynamic value,
    {String noDate = "No Date", String invalidDate = "Invalid Date"}) {
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

// ─────────────────────────────────────────────────────────────
// Colours
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

class FollowupDetailPage extends StatelessWidget {
  final Map data;
  final VoidCallback onComplete;

  const FollowupDetailPage({
    super.key,
    required this.data,
    required this.onComplete,
  });

  // ─────────────────────────────────────────────────────────────
  // Translation helper — mirrors the pattern used across the app
  // ─────────────────────────────────────────────────────────────
  String t(BuildContext context, String key) =>
      AppTranslations.t(context, key);

  // ─────────────────────────────────────────────────────────────
  // Localised risk label
  // ─────────────────────────────────────────────────────────────
  String _riskLabel(BuildContext context, String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return t(context, 'risk_high_overall');
      case 'medium':
        return t(context, 'risk_moderate_overall');
      default:
        return t(context, 'risk_low_overall');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Info row widget
  // ─────────────────────────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────────────
  // Fetch meal plan
  // ─────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> _fetchMealPlan() async {
    final beneficiaryId = data["beneficiaryId"]?.toString();
    final screeningId = data["screeningId"]?.toString();

    if (beneficiaryId == null || screeningId == null) {
      throw Exception("Missing beneficiaryId or screeningId");
    }

    final screening =
    await ApiService.getScreening(beneficiaryId, screeningId);

    final mealPlan = screening["mealPlan"];
    if (mealPlan == null) throw Exception("No meal plan found");

    return Map<String, dynamic>.from(mealPlan);
  }

  // ─────────────────────────────────────────────────────────────
  // Build meal plan widgets
  // ─────────────────────────────────────────────────────────────
  List<Widget> _buildMealWidgets(Map<String, dynamic> mealPlan) {
    final List<Widget> widgets = [];

    mealPlan.forEach((key, value) {
      final label = key
          .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
          .trim()
          .split(' ')
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join(' ');

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600, color: kPrimary),
          ),
        ),
      );

      if (value is List) {
        for (final item in value) {
          widgets.add(_bulletItem(item.toString()));
        }
      } else if (value is Map) {
        value.forEach((subKey, subValue) {
          widgets.add(_bulletItem("$subKey: $subValue"));
        });
      } else {
        widgets.add(_bulletItem(value.toString()));
      }
    });

    return widgets;
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration:
            const BoxDecoration(color: kAccent, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.nunito(
                  fontSize: 13, color: kTextDark, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Bottom sheet
  // ─────────────────────────────────────────────────────────────
  void _showMealPlan(BuildContext context, String name, String risk) {
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
                          Text(
                            t(context, 'meal_plan_title'),
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: kTextDark),
                          ),
                          Text(
                            "${t(context, 'meal_plan_recommended_for')} $name",
                            style: GoogleFonts.nunito(
                                fontSize: 12, color: kTextMuted),
                          ),
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
                        _riskLabel(context, risk),
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
              // Async meal content
              Expanded(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _fetchMealPlan(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: kPrimary),
                            const SizedBox(height: 16),
                            Text(t(context, 'loading_meal_plan')),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Colors.red, size: 40),
                              const SizedBox(height: 12),
                              Text(
                                t(context, 'meal_plan_error'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                    fontSize: 14, color: kTextMuted),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final mealPlan = snapshot.data!;
                    return ListView(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: _buildMealWidgets(mealPlan),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Translation shorthand ──────────────────────────────────
    String t(String key) => AppTranslations.t(context, key);

    // ── Data ──────────────────────────────────────────────────
    final String name = data["name"]?.toString() ??
        data["beneficiaryId"]?.toString() ??
        "N/A";
    final String risk = data["riskLevel"]?.toString() ?? "low";
    final String date = formatDate(
      data["followUpDate"] ?? data["followupDate"],
      noDate: t('no_date'),
      invalidDate: t('invalid_date'),
    );
    final String address = data["address"]?.toString() ?? "—";

    return Scaffold(
      backgroundColor: kSurface,
      appBar:
      const AppBarWithLang(titleKey: "app_title", showBackButton: false),
      body: CustomScrollView(
        slivers: [
          // ── Sliver App Bar ──────────────────────────────────
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
                child: Stack(
                  children: [
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
                            name,
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
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
                                  _riskLabel(context, risk),
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
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // ── Detail Body ─────────────────────────────────────
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
                        Row(
                          children: [
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
                            Text(
                              t('follow_up_details'),
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kPrimary),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 1,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF90CAF9),
                                    Colors.transparent,
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _infoRow(
                            Icons.badge_outlined, t('woman_name'), name),
                        _infoRow(Icons.calendar_today_outlined,
                            t('follow_up_date'), date),
                        _infoRow(Icons.warning_amber_rounded, t('risk_level'),
                            _riskLabel(context, risk)),
                        _infoRow(
                            Icons.home_outlined, t('address'), address),
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
                                Text(
                                  t('view_meal_plan'),
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                Text(
                                  t('recommended_diet_prefix'),
                                  style: GoogleFonts.nunito(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.8)),
                                ),
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
                            t('mark_as_done'),
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