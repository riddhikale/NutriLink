import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_bar_with_lang.dart';
import '../../l10n/app_translations.dart';

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

  ({String labelKey, Color color, Color bg, IconData icon}) _planMeta() {
    switch (nutritionNeed) {
      case 'energy_dense':   return (labelKey: 'plan_energy_dense',   color: const Color(0xFF854F0B), bg: const Color(0xFFFAEEDA), icon: Icons.bolt_rounded);
      case 'iron_rich':      return (labelKey: 'plan_iron_rich',       color: const Color(0xFF791F1F), bg: const Color(0xFFFCEBEB), icon: Icons.bloodtype_outlined);
      case 'immunity_boost': return (labelKey: 'plan_immunity_boost',  color: const Color(0xFF0F6E56), bg: const Color(0xFFE1F5EE), icon: Icons.shield_outlined);
      case 'light_meals':    return (labelKey: 'plan_light_meals',     color: const Color(0xFF3B6D11), bg: const Color(0xFFEAF3DE), icon: Icons.eco_outlined);
      case 'protein_rich':   return (labelKey: 'plan_protein_rich',    color: const Color(0xFF534AB7), bg: const Color(0xFFEEEDFE), icon: Icons.fitness_center_rounded);
      case 'low_sodium':     return (labelKey: 'plan_low_sodium',      color: const Color(0xFF185FA5), bg: const Color(0xFFE6F1FB), icon: Icons.water_drop_outlined);
      default:               return (labelKey: 'plan_balanced',        color: const Color(0xFF27500A), bg: const Color(0xFFEAF3DE), icon: Icons.balance_outlined);
    }
  }

  String _tipKey() {
    switch (nutritionNeed) {
      case 'energy_dense':   return 'tip_energy_dense';
      case 'iron_rich':      return 'tip_iron_rich';
      case 'immunity_boost': return 'tip_immunity_boost';
      case 'light_meals':    return 'tip_light_meals';
      case 'protein_rich':   return 'tip_protein_rich';
      case 'low_sodium':     return 'tip_low_sodium';
      default:               return 'tip_balanced';
    }
  }

  List<String> _parseItems(dynamic value, String notSpecified) {
    if (value == null) return [notSpecified];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    return [value.toString()];
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    final meta = _planMeta();
    final translatedLabel = t(meta.labelKey);

    final meals = [
      _MealSection(title: t('meal_breakfast'), icon: Icons.wb_sunny_outlined,    iconColor: const Color(0xFFBA7517), iconBg: const Color(0xFFFAEEDA), timeLabel: t('time_morning'),   items: _parseItems(mealPlan['breakfast'], t('not_specified'))),
      _MealSection(title: t('meal_lunch'),     icon: Icons.lunch_dining_outlined, iconColor: const Color(0xFF185FA5), iconBg: const Color(0xFFE6F1FB), timeLabel: t('time_afternoon'), items: _parseItems(mealPlan['lunch'],      t('not_specified'))),
      _MealSection(title: t('meal_snacks'),    icon: Icons.cookie_outlined,       iconColor: const Color(0xFF0F6E56), iconBg: const Color(0xFFE1F5EE), timeLabel: t('time_midday'),   items: _parseItems(mealPlan['snack'],      t('not_specified'))),
      _MealSection(title: t('meal_dinner'),    icon: Icons.nightlight_outlined,   iconColor: const Color(0xFF534AB7), iconBg: const Color(0xFFEEEDFE), timeLabel: t('time_evening'),  items: _parseItems(mealPlan['dinner'],     t('not_specified'))),
    ];

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: const AppBarWithLang(titleKey: 'app_title', showBackButton: false),
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
                Text(t('meal_plan_title'),
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                Text(t('meal_plan_subtitle'),
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
                  _PlanHeroCard(
                    meta: (label: translatedLabel, color: meta.color, bg: meta.bg, icon: meta.icon),
                    mealPlan: mealPlan,
                    recommendedPlanLabel: t('recommended_plan'),
                  ),
                  const SizedBox(height: 20),
                  _SectionLabel(text: t('daily_meal_schedule')),
                  const SizedBox(height: 10),
                  ...meals.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MealCard(section: m),
                  )),
                  const SizedBox(height: 8),
                  _TipsBanner(
                    tip: t(_tipKey()),
                    nutritionTipLabel: t('nutrition_tip'),
                  ),
                  const SizedBox(height: 8),
                  _ReturnToDashboard(label: t('return_to_dashboard')),
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
  final String label;
  const _ReturnToDashboard({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
          '/dashboard', (route) => false,
        ),
        icon: const Icon(Icons.home_outlined, size: 16, color: _blue400),
        label: Text(
          label,
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
  final String recommendedPlanLabel;

  const _PlanHeroCard({
    required this.meta,
    required this.mealPlan,
    required this.recommendedPlanLabel,
  });

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
                Text(recommendedPlanLabel,
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
  final String tip;
  final String nutritionTipLabel;

  const _TipsBanner({required this.tip, required this.nutritionTipLabel});

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
                Text(nutritionTipLabel,
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: _blue800)),
                const SizedBox(height: 4),
                Text(tip,
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