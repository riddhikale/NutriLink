import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Palette ───────────────────────────────────────────────────────────────────
const _blue900 = Color(0xFF042C53);
const _blue800 = Color(0xFF0C447C);
const _blue600 = Color(0xFF185FA5);
const _blue400 = Color(0xFF378ADD);
const _blue100 = Color(0xFFB5D4F4);
const _blue50  = Color(0xFFE6F1FB);
const _pageBg  = Color(0xFFEAF2FB);

// ── Risk level ────────────────────────────────────────────────────────────────
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

// ── Field risk model ──────────────────────────────────────────────────────────
class FieldRisk {
  final String label;
  final String detail;
  final IconData icon;
  final RiskLevel level;
  const FieldRisk({required this.label, required this.detail, required this.icon, required this.level});
}

// ── Risk logic (mirrors JS exactly) ──────────────────────────────────────────
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

RiskLevel _overall(List<RiskLevel> list) {
  if (list.contains(RiskLevel.high)) return RiskLevel.high;
  if (list.contains(RiskLevel.medium)) return RiskLevel.medium;
  return RiskLevel.low;
}

// ── Page ──────────────────────────────────────────────────────────────────────
class RiskResultPage extends StatelessWidget {
  final Map<String, dynamic>? childData;
  final Map<String, dynamic>? womenData;

  const RiskResultPage({super.key, this.childData, this.womenData})
      : assert(childData != null || womenData != null);

  (RiskLevel, List<FieldRisk>) _buildChild() {
    final d = childData!;
    final age    = (d['ageMonths'] as num).toDouble();
    final muac   = (d['muac']     as num).toDouble();
    final weight = (d['weight']   as num).toDouble();
    final height = (d['height']   as num).toDouble();

    final rMuac   = _muacRisk(age, muac);
    final rWeight = _weightChild(age, weight);
    final rHeight = _heightChild(age, height);

    final ageLabel = age < 24 ? '≤24 months' : '>24 months';

    return (
    _overall([rMuac, rWeight, rHeight]),
    [
      FieldRisk(label: 'MUAC',   detail: '${muac.toStringAsFixed(1)} cm · ${age.round()} mo',   icon: Icons.straighten_rounded,         level: rMuac),
      FieldRisk(label: 'Weight', detail: '${weight.toStringAsFixed(1)} kg · $ageLabel',          icon: Icons.monitor_weight_outlined,    level: rWeight),
      FieldRisk(label: 'Height', detail: '${height.toStringAsFixed(1)} cm · $ageLabel',          icon: Icons.height_rounded,             level: rHeight),
    ],
    );
  }

  (RiskLevel, List<FieldRisk>) _buildWomen() {
    final d = womenData!;
    final hb     = (d['hemoglobin']  as num).toDouble();
    final sys    = (d['systolicBP']  as num).toDouble();
    final dia    = (d['diastolicBP'] as num).toDouble();
    final weight = (d['weight']      as num).toDouble();

    final rHb     = _hemoglobin(hb);
    final rBp     = _bp(sys, dia);
    final rWeight = _weightWomen(weight);

    return (
    _overall([rHb, rBp, rWeight]),
    [
      FieldRisk(label: 'Hemoglobin',     detail: '${hb.toStringAsFixed(1)} g/dL',               icon: Icons.water_drop_outlined,        level: rHb),
      FieldRisk(label: 'Blood pressure', detail: '${sys.round()}/${dia.round()} mmHg',           icon: Icons.favorite_border_rounded,    level: rBp),
      FieldRisk(label: 'Weight',         detail: '${weight.toStringAsFixed(1)} kg',              icon: Icons.monitor_weight_outlined,    level: rWeight),
    ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final (overall, fields) = childData != null ? _buildChild() : _buildWomen();
    final counts = {
      RiskLevel.high:   fields.where((f) => f.level == RiskLevel.high).length,
      RiskLevel.medium: fields.where((f) => f.level == RiskLevel.medium).length,
      RiskLevel.low:    fields.where((f) => f.level == RiskLevel.low).length,
    };
    final isChild = childData != null;

    return Scaffold(
      backgroundColor: _pageBg,
      body: CustomScrollView(
        slivers: [
          // ── Collapsible blue header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: _blue600,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 14),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Risk Assessment',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
                  Text(isChild ? 'Child profile' : 'Women\'s profile',
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
                ],
              ),
              background: Container(color: _blue600),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Hero card (overlaps the AppBar bottom) ────────────────
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: _HeroCard(level: overall),
                  ),

                  // ── Score summary chips ───────────────────────────────────
                  Transform.translate(
                    offset: const Offset(0, -12),
                    child: Row(
                      children: [
                        _ScoreChip(count: counts[RiskLevel.high]!,   label: 'High',     color: const Color(0xFFA32D2D), bg: const Color(0xFFFCEBEB)),
                        const SizedBox(width: 8),
                        _ScoreChip(count: counts[RiskLevel.medium]!, label: 'Moderate', color: const Color(0xFF633806), bg: const Color(0xFFFAEEDA)),
                        const SizedBox(width: 8),
                        _ScoreChip(count: counts[RiskLevel.low]!,    label: 'Normal',   color: const Color(0xFF27500A), bg: const Color(0xFFEAF3DE)),
                      ],
                    ),
                  ),

                  // ── Fields ───────────────────────────────────────────────
                  _SectionLabel(text: 'Metrics breakdown'),
                  const SizedBox(height: 8),
                  _FieldsCard(fields: fields),
                  const SizedBox(height: 20),

                  // ── Actions ──────────────────────────────────────────────
                  _BlueButton(
                    label: 'Generate meal plan',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Meal plan coming soon')),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _OutlineButton(label: 'View recommendations', onTap: () {}),
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
          decoration: BoxDecoration(
            color: level.background,
            borderRadius: BorderRadius.circular(20),
          ),
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
  final Color color, bg;
  const _ScoreChip({required this.count, required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _blue100)),
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
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600,
            color: _blue400, letterSpacing: 0.6));
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
            if (i < fields.length - 1)
              Divider(height: 0, thickness: 0.5, color: _blue50),
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

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: _blue600,
          side: const BorderSide(color: _blue400, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: onTap,
        child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      ),
    );
  }
}