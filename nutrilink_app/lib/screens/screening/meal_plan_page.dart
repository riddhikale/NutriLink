import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _blue800 = Color(0xFF0C447C);
const _blue600 = Color(0xFF185FA5);
const _blue400 = Color(0xFF378ADD);
const _blue100 = Color(0xFFB5D4F4);
const _blue50  = Color(0xFFE6F1FB);
const _pageBg  = Color(0xFFEAF2FB);

class MealPlanPage extends StatelessWidget {
  final Map<String, dynamic> mealPlan;
  final String nutritionNeed;

  const MealPlanPage({
    super.key,
    required this.mealPlan,
    required this.nutritionNeed,
  });

  ({String label, Color color, Color bg, IconData icon}) _planMeta() {
    switch (nutritionNeed) {
      case 'energy_dense':   return (label: 'Energy Dense',   color: const Color(0xFF854F0B), bg: const Color(0xFFFAEEDA), icon: Icons.bolt_rounded);
      case 'iron_rich':      return (label: 'Iron Rich',       color: const Color(0xFF791F1F), bg: const Color(0xFFFCEBEB), icon: Icons.bloodtype_outlined);
      case 'immunity_boost': return (label: 'Immunity Boost',  color: const Color(0xFF0F6E56), bg: const Color(0xFFE1F5EE), icon: Icons.shield_outlined);
      case 'light_meals':    return (label: 'Light Meals',     color: const Color(0xFF3B6D11), bg: const Color(0xFFEAF3DE), icon: Icons.eco_outlined);
      case 'protein_rich':   return (label: 'Protein Rich',    color: const Color(0xFF534AB7), bg: const Color(0xFFEEEDFE), icon: Icons.fitness_center_rounded);
      case 'low_sodium':     return (label: 'Low Sodium',      color: const Color(0xFF185FA5), bg: const Color(0xFFE6F1FB), icon: Icons.water_drop_outlined);
      default:               return (label: 'Balanced',        color: const Color(0xFF27500A), bg: const Color(0xFFEAF3DE), icon: Icons.balance_outlined);
    }
  }

  List<String> _parseItems(dynamic value) {
    if (value == null) return ['Not specified'];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    return [value.toString()];
  }

  @override
  Widget build(BuildContext context) {
    final meta = _planMeta();

    final meals = [
      _MealSection(title: 'Breakfast', icon: Icons.wb_sunny_outlined,    iconColor: const Color(0xFFBA7517), iconBg: const Color(0xFFFAEEDA), timeLabel: 'Morning',   items: _parseItems(mealPlan['breakfast'])),
      _MealSection(title: 'Lunch',     icon: Icons.lunch_dining_outlined, iconColor: const Color(0xFF185FA5), iconBg: const Color(0xFFE6F1FB), timeLabel: 'Afternoon', items: _parseItems(mealPlan['lunch'])),
      _MealSection(title: 'Snacks',    icon: Icons.cookie_outlined,       iconColor: const Color(0xFF0F6E56), iconBg: const Color(0xFFE1F5EE), timeLabel: 'Mid-day',   items: _parseItems(mealPlan['snack'])),
      _MealSection(title: 'Dinner',    icon: Icons.nightlight_outlined,   iconColor: const Color(0xFF534AB7), iconBg: const Color(0xFFEEEDFE), timeLabel: 'Evening',   items: _parseItems(mealPlan['dinner'])),
    ];

    return Scaffold(
      backgroundColor: _pageBg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            toolbarHeight: 56,
            backgroundColor: _blue600,
            foregroundColor: Colors.white,
            centerTitle: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Meal Plan',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                Text('Personalised nutrition guide',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PlanHeroCard(meta: meta, mealPlan: mealPlan),
                  const SizedBox(height: 20),
                  _SectionLabel(text: 'Daily meal schedule'),
                  const SizedBox(height: 10),
                  ...meals.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MealCard(section: m),
                  )),
                  const SizedBox(height: 8),
                  _TipsBanner(nutritionNeed: nutritionNeed),
                  const SizedBox(height: 8),
                  // ── Return to dashboard ───────────────────────────────
                  const _ReturnToDashboard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared widget ─────────────────────────────────────────────────────────────

class _ReturnToDashboard extends StatelessWidget {
  const _ReturnToDashboard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
          '/dashboard',
              (route) => false,
        ),
        icon: const Icon(Icons.home_outlined, size: 16, color: _blue400),
        label: Text(
          'Return to dashboard',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: _blue400,
            decoration: TextDecoration.underline,
            decorationColor: _blue400,
          ),
        ),
      ),
    );
  }
}
// ── Data model ────────────────────────────────────────────────────────────────

class _MealSection {
  final String title;
  final String timeLabel;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<String> items;

  const _MealSection({
    required this.title,
    required this.timeLabel,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.items,
  });
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _PlanHeroCard extends StatelessWidget {
  final ({String label, Color color, Color bg, IconData icon}) meta;
  final Map<String, dynamic> mealPlan;
  const _PlanHeroCard({required this.meta, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    final planName = mealPlan['name']?.toString() ?? meta.label;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _blue100),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(color: meta.bg, borderRadius: BorderRadius.circular(18)),
            child: Icon(meta.icon, size: 32, color: meta.color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recommended plan',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 2),
                Text(planName,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: _blue800)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: meta.bg, borderRadius: BorderRadius.circular(20)),
                  child: Text(meta.label,
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: meta.color)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final _MealSection section;
  const _MealCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _blue100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: section.iconBg, borderRadius: BorderRadius.circular(11)),
                  child: Icon(section.icon, size: 18, color: section.iconColor),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section.title,
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: _blue800)),
                    Text(section.timeLabel,
                        style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 0, thickness: 0.5, color: _blue50),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: section.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: 6, height: 6,
                      decoration: BoxDecoration(color: section.iconColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(item,
                          style: GoogleFonts.nunito(fontSize: 14, color: const Color(0xFF0D1B2A))),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsBanner extends StatelessWidget {
  final String nutritionNeed;
  const _TipsBanner({required this.nutritionNeed});

  String get _tip {
    switch (nutritionNeed) {
      case 'energy_dense':   return 'Offer small frequent meals every 2–3 hours. Add healthy fats like ghee or peanut butter to increase calorie density.';
      case 'iron_rich':      return 'Pair iron-rich foods with vitamin C sources like lemon or tomato to improve absorption. Avoid tea/coffee around mealtimes.';
      case 'immunity_boost': return 'Include colourful fruits and vegetables daily. Zinc-rich foods like lentils and seeds help fight infections.';
      case 'light_meals':    return 'Serve smaller portions more often. Avoid strongly spiced or fried foods. Keep meals simple and easy to digest.';
      case 'protein_rich':   return 'Include a protein source in every meal — eggs, dal, paneer or meat. Adequate protein supports both mother and baby.';
      case 'low_sodium':     return 'Avoid adding extra salt. Choose fresh foods over packaged ones. Drink plenty of water to help reduce swelling.';
      default:               return 'Maintain a varied diet with all food groups. Stay hydrated and follow regular meal timings.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _blue50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _blue100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: _blue100, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.lightbulb_outline_rounded, size: 18, color: _blue600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nutrition tip',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: _blue800)),
                const SizedBox(height: 4),
                Text(_tip,
                    style: GoogleFonts.nunito(fontSize: 13, color: _blue800, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: _blue400, letterSpacing: 0.6));
  }
}