import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'meal_plan_page.dart';
import '../../widgets/app_bar_with_lang.dart';

const _blue900 = Color(0xFF042C53);
const _blue800 = Color(0xFF0C447C);
const _blue600 = Color(0xFF185FA5);
const _blue400 = Color(0xFF378ADD);
const _blue100 = Color(0xFFB5D4F4);
const _blue50  = Color(0xFFE6F1FB);
const _pageBg  = Color(0xFFEAF2FB);

enum RiskLevel { high, medium, low }

extension RiskLevelX on RiskLevel {
  Color get foreground {
    switch (this) {
      case RiskLevel.high:   return const Color(0xFFA32D2D);
      case RiskLevel.medium: return const Color(0xFF633806);
      case RiskLevel.low:    return const Color(0xFF27500A);
    }
  }
  Color get background {
    switch (this) {
      case RiskLevel.high:   return const Color(0xFFFCEBEB);
      case RiskLevel.medium: return const Color(0xFFFAEEDA);
      case RiskLevel.low:    return const Color(0xFFEAF3DE);
    }
  }
  String get label {
    switch (this) {
      case RiskLevel.high:   return 'High';
      case RiskLevel.medium: return 'Moderate';
      case RiskLevel.low:    return 'Normal';
    }
  }
  String get overallLabel {
    switch (this) {
      case RiskLevel.high:   return 'High risk';
      case RiskLevel.medium: return 'Moderate risk';
      case RiskLevel.low:    return 'Low risk';
    }
  }
  String get subtitle {
    switch (this) {
      case RiskLevel.high:   return 'Immediate attention needed';
      case RiskLevel.medium: return 'Monitor closely';
      case RiskLevel.low:    return 'Within safe range';
    }
  }
  IconData get icon {
    switch (this) {
      case RiskLevel.high:   return Icons.warning_amber_rounded;
      case RiskLevel.medium: return Icons.info_outline_rounded;
      case RiskLevel.low:    return Icons.check_circle_outline_rounded;
    }
  }
}

class FieldRisk {
  final String label;
  final String detail;
  final IconData icon;
  final RiskLevel level;
  const FieldRisk({required this.label, required this.detail, required this.icon, required this.level});
}

class SymptomResult {
  final String label;
  final bool present;
  final IconData icon;
  const SymptomResult({required this.label, required this.present, required this.icon});
}

int _riskScore(RiskLevel r) => r == RiskLevel.high ? 3 : r == RiskLevel.medium ? 2 : 1;

RiskLevel _scoreToRisk(double avg) {
  if (avg >= 2.5) return RiskLevel.high;
  if (avg >= 1.5) return RiskLevel.medium;
  return RiskLevel.low;
}

RiskLevel _muacRisk(double ageMonths, double muac) {
  final y = ageMonths / 12;
  if (ageMonths >= 6 && ageMonths <= 59) {
    if (muac < 11) return RiskLevel.high;
    if (muac < 13) return RiskLevel.medium;
    return RiskLevel.low;
  }
  if (y >= 5 && y <= 9) {
    if (muac < 13.5) return RiskLevel.high;
    if (muac < 14.5) return RiskLevel.medium;
    return RiskLevel.low;
  }
  if (y >= 10 && y <= 14) {
    if (muac < 16) return RiskLevel.high;
    if (muac < 18) return RiskLevel.medium;
    return RiskLevel.low;
  }
  return RiskLevel.low;
}

RiskLevel _weightChild(double ageMonths, double weight) {
  if (ageMonths <= 24) {
    if (weight < 6) return RiskLevel.high;
    if (weight < 8) return RiskLevel.medium;
    return RiskLevel.low;
  }
  if (weight < 8) return RiskLevel.high;
  if (weight < 10) return RiskLevel.medium;
  return RiskLevel.low;
}

RiskLevel _heightChild(double ageMonths, double height) {
  if (ageMonths <= 24) {
    if (height < 70) return RiskLevel.high;
    if (height < 80) return RiskLevel.medium;
    return RiskLevel.low;
  }
  if (height < 80) return RiskLevel.high;
  if (height < 90) return RiskLevel.medium;
  return RiskLevel.low;
}

RiskLevel _hemoglobin(double hb) {
  if (hb < 7) return RiskLevel.high;
  if (hb < 10) return RiskLevel.medium;
  return RiskLevel.low;
}

RiskLevel _bp(double sys, double dia) {
  if (sys > 140 || dia > 90) return RiskLevel.high;
  if (sys > 130 || dia > 85) return RiskLevel.medium;
  return RiskLevel.low;
}

RiskLevel _weightWomen(double weight) {
  if (weight < 45) return RiskLevel.high;
  if (weight < 50) return RiskLevel.medium;
  return RiskLevel.low;
}

RiskLevel _weightedOverall(List<({RiskLevel level, int weight})> entries) {
  final totalWeight = entries.fold(0, (s, e) => s + e.weight);
  final weightedSum = entries.fold(0.0, (s, e) => s + _riskScore(e.level) * e.weight);
  return _scoreToRisk(weightedSum / totalWeight);
}

class RiskResultPage extends StatelessWidget {
  final Map<String, dynamic>? childData;
  final Map<String, dynamic>? womenData;

  const RiskResultPage({super.key, this.childData, this.womenData})
      : assert(childData != null || womenData != null);

  (RiskLevel, List<FieldRisk>, List<SymptomResult>) _buildChild() {
    final d = childData!;
    final age    = (d['ageMonths'] as num).toDouble();
    final muac   = (d['muac']     as num).toDouble();
    final weight = (d['weight']   as num).toDouble();
    final height = (d['height']   as num).toDouble();
    final weakness        = d['weakness']        == true;
    final lowAppetite     = d['lowAppetite']     == true;
    final frequentIllness = d['frequentIllness'] == true;
    final diarrhea        = d['diarrhea']        == true;

    final rMuac   = _muacRisk(age, muac);
    final rWeight = _weightChild(age, weight);
    final rHeight = _heightChild(age, height);

    final symptomCount = [weakness, lowAppetite, frequentIllness, diarrhea].where((s) => s).length;
    final rSymptom = symptomCount >= 3 ? RiskLevel.high : symptomCount >= 1 ? RiskLevel.medium : RiskLevel.low;

    final overall = _weightedOverall([
      (level: rMuac,    weight: 2),
      (level: rWeight,  weight: 2),
      (level: rHeight,  weight: 2),
      (level: rSymptom, weight: 1),
    ]);

    final ageLabel = age <= 24 ? '≤24 months' : '>24 months';

    return (
    overall,
    [
      FieldRisk(label: 'MUAC',   detail: '${muac.toStringAsFixed(1)} cm · ${age.round()} mo', icon: Icons.straighten_rounded,      level: rMuac),
      FieldRisk(label: 'Weight', detail: '${weight.toStringAsFixed(1)} kg · $ageLabel',        icon: Icons.monitor_weight_outlined, level: rWeight),
      FieldRisk(label: 'Height', detail: '${height.toStringAsFixed(1)} cm · $ageLabel',        icon: Icons.height_rounded,          level: rHeight),
    ],
    [
      SymptomResult(label: 'Weakness',        present: weakness,        icon: Icons.battery_alert_outlined),
      SymptomResult(label: 'Low appetite',     present: lowAppetite,     icon: Icons.no_food_outlined),
      SymptomResult(label: 'Frequent illness', present: frequentIllness, icon: Icons.sick_outlined),
      SymptomResult(label: 'Diarrhea',         present: diarrhea,        icon: Icons.water_drop_outlined),
    ],
    );
  }

  (RiskLevel, List<FieldRisk>, List<SymptomResult>) _buildWomen() {
    final d = womenData!;
    final hb     = (d['hemoglobin']  as num).toDouble();
    final sys    = (d['systolicBP']  as num).toDouble();
    final dia    = (d['diastolicBP'] as num).toDouble();
    final weight = (d['weight']      as num).toDouble();
    final dizziness   = d['dizziness']   == true;
    final fatigue     = d['fatigue']     == true;
    final swelling    = d['swelling']    == true;
    final lowAppetite = d['lowAppetite'] == true;
    final pastAnemia  = d['pastAnemia']  == true;

    final rHb     = _hemoglobin(hb);
    final rBp     = _bp(sys, dia);
    final rWeight = _weightWomen(weight);

    final symptomCount = [dizziness, fatigue, swelling, lowAppetite, pastAnemia].where((s) => s).length;
    final rSymptom = symptomCount >= 3 ? RiskLevel.high : symptomCount >= 1 ? RiskLevel.medium : RiskLevel.low;

    final overall = _weightedOverall([
      (level: rHb,      weight: 2),
      (level: rBp,      weight: 2),
      (level: rWeight,  weight: 2),
      (level: rSymptom, weight: 1),
    ]);

    return (
    overall,
    [
      FieldRisk(label: 'Hemoglobin',     detail: '${hb.toStringAsFixed(1)} g/dL',     icon: Icons.water_drop_outlined,     level: rHb),
      FieldRisk(label: 'Blood pressure', detail: '${sys.round()}/${dia.round()} mmHg', icon: Icons.favorite_border_rounded, level: rBp),
      FieldRisk(label: 'Weight',         detail: '${weight.toStringAsFixed(1)} kg',    icon: Icons.monitor_weight_outlined, level: rWeight),
    ],
    [
      SymptomResult(label: 'Dizziness',    present: dizziness,   icon: Icons.blind_outlined),
      SymptomResult(label: 'Fatigue',      present: fatigue,     icon: Icons.battery_alert_outlined),
      SymptomResult(label: 'Swelling',     present: swelling,    icon: Icons.water_outlined),
      SymptomResult(label: 'Low appetite', present: lowAppetite, icon: Icons.no_food_outlined),
      SymptomResult(label: 'Past anemia',  present: pastAnemia,  icon: Icons.history_outlined),
    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final (overall, fields, symptoms) = childData != null ? _buildChild() : _buildWomen();
    final counts = {
      RiskLevel.high:   fields.where((f) => f.level == RiskLevel.high).length,
      RiskLevel.medium: fields.where((f) => f.level == RiskLevel.medium).length,
      RiskLevel.low:    fields.where((f) => f.level == RiskLevel.low).length,
    };
    final isChild = childData != null;

    return Scaffold(
      backgroundColor: _pageBg,
      appBar: const AppBarWithLang(title: "NutriLink", showBackButton: false),
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
                Text('Risk Assessment',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                Text(isChild ? 'Child profile' : 'Women\'s profile',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroCard(level: overall),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ScoreChip(count: counts[RiskLevel.high]!,   label: 'High',     color: const Color(0xFFA32D2D)),
                      const SizedBox(width: 8),
                      _ScoreChip(count: counts[RiskLevel.medium]!, label: 'Moderate', color: const Color(0xFF633806)),
                      const SizedBox(width: 8),
                      _ScoreChip(count: counts[RiskLevel.low]!,    label: 'Normal',   color: const Color(0xFF27500A)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(text: 'Metrics breakdown'),
                  const SizedBox(height: 8),
                  _FieldsCard(fields: fields),
                  const SizedBox(height: 20),
                  const _SectionLabel(text: 'Symptoms reported'),
                  const SizedBox(height: 8),
                  _SymptomsCard(symptoms: symptoms),
                  const SizedBox(height: 24),

                  // ── Actions ───────────────────────────────────────────
                  _BlueButton(
                    label: 'Generate meal plan',
                    onTap: () {
                      final data = childData ?? womenData!;
                      final mealPlan      = data['mealPlan']      as Map<String, dynamic>?;
                      final nutritionNeed = data['nutritionNeed'] as String?;

                      if (mealPlan == null || nutritionNeed == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meal plan not available')),
                        );
                        return;
                      }

                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => MealPlanPage(
                          mealPlan: mealPlan,
                          nutritionNeed: nutritionNeed,
                        ),
                      ));
                    },
                  ),
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

// ── Sub-widgets ───────────────────────────────────────────────────────────────

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
class _HeroCard extends StatelessWidget {
  final RiskLevel level;
  const _HeroCard({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _blue100),
      ),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      child: Column(children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(color: _blue50, borderRadius: BorderRadius.circular(18)),
          child: const Icon(Icons.health_and_safety_rounded, size: 30, color: _blue600),
        ),
        const SizedBox(height: 12),
        Text('Overall risk level',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(level.overallLabel,
            style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w600, color: level.foreground)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(color: level.background, borderRadius: BorderRadius.circular(20)),
          child: Text(level.subtitle,
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: level.foreground)),
        ),
      ]),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _ScoreChip({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _blue100),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          Text('$count', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: color)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500])),
        ]),
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

class _FieldsCard extends StatelessWidget {
  final List<FieldRisk> fields;
  const _FieldsCard({required this.fields});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _blue100),
      ),
      child: Column(
        children: [
          for (int i = 0; i < fields.length; i++) ...[
            _FieldRow(field: fields[i]),
            if (i < fields.length - 1) Divider(height: 0, thickness: 0.5, color: _blue50),
          ],
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final FieldRisk field;
  const _FieldRow({required this.field});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: field.level.background, borderRadius: BorderRadius.circular(11)),
          child: Icon(field.icon, size: 18, color: field.level.foreground),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label,
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: _blue800)),
            Text(field.detail,
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500])),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: field.level.background, borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(field.level.icon, size: 13, color: field.level.foreground),
            const SizedBox(width: 4),
            Text(field.level.label,
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: field.level.foreground)),
          ]),
        ),
      ]),
    );
  }
}

class _SymptomsCard extends StatelessWidget {
  final List<SymptomResult> symptoms;
  const _SymptomsCard({required this.symptoms});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _blue100),
      ),
      child: Column(
        children: [
          for (int i = 0; i < symptoms.length; i++) ...[
            _SymptomRow(symptom: symptoms[i]),
            if (i < symptoms.length - 1) Divider(height: 0, thickness: 0.5, color: _blue50),
          ],
        ],
      ),
    );
  }
}

class _SymptomRow extends StatelessWidget {
  final SymptomResult symptom;
  const _SymptomRow({required this.symptom});

  @override
  Widget build(BuildContext context) {
    final color       = symptom.present ? const Color(0xFFA32D2D) : const Color(0xFF27500A);
    final bgColor     = symptom.present ? const Color(0xFFFCEBEB) : const Color(0xFFEAF3DE);
    final statusLabel = symptom.present ? 'Yes' : 'No';
    final statusIcon  = symptom.present ? Icons.check_rounded : Icons.close_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: _blue50, borderRadius: BorderRadius.circular(11)),
          child: Icon(symptom.icon, size: 18, color: _blue600),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(symptom.label,
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: _blue800)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(statusIcon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(statusLabel,
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
          ]),
        ),
      ]),
    );
  }
}

class _BlueButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _BlueButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _blue600,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child: Text(label, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500)),
      ),
    );
  }
}