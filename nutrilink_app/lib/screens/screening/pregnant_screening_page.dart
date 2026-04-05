import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import 'risk_result_page.dart';
import '../../widgets/app_bar_with_lang.dart';
import '../../l10n/app_translations.dart';

class PregnantScreeningPage extends StatefulWidget {
  const PregnantScreeningPage({super.key});

  @override
  State<PregnantScreeningPage> createState() => _PregnantScreeningPageState();
}

class _PregnantScreeningPageState extends State<PregnantScreeningPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController      = TextEditingController();
  final husbandController   = TextEditingController();
  final ageController       = TextEditingController();
  final weightController    = TextEditingController();
  final hbController        = TextEditingController();
  final systolicController  = TextEditingController();
  final diastolicController = TextEditingController();
  final notesController     = TextEditingController();
  final addressController   = TextEditingController();
  final wardController      = TextEditingController();

  String? trimester;
  String dizziness   = "No";
  String fatigue     = "No";
  String swelling    = "No";
  String lowAppetite = "No";
  String pastAnemia  = "No";

  static const Color primary      = Color(0xFF1565C0);
  static const Color accent       = Color(0xFF1E88E5);
  static const Color accentLight  = Color(0xFFE3F2FD);
  static const Color surface      = Color(0xFFF5F9FF);
  static const Color textDark     = Color(0xFF0D1B2A);
  static const Color textMuted    = Color(0xFF546E7A);

  // ── Field decoration ──────────────────────────────────────
  InputDecoration fieldDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.nunito(color: textMuted, fontSize: 14),
      prefixIcon:
      icon != null ? Icon(icon, color: accent, size: 20) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBBDEFB), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBBDEFB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ── Yes / No dropdown ─────────────────────────────────────
  // Receives already-translated yes/no labels so the widget
  // stays stateless with respect to context.
  Widget yesNoDropdown(
      String title,
      String value,
      Function(String?) onChanged, {
        IconData? icon,
        required String yesLabel,
        required String noLabel,
      }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: fieldDecoration(title, icon: icon),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: accent),
      style: GoogleFonts.nunito(color: textDark, fontSize: 15),
      items: [
        DropdownMenuItem(
          value: "Yes",
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline,
                  color: accent, size: 18),
              const SizedBox(width: 8),
              Text(yesLabel),
            ],
          ),
        ),
        DropdownMenuItem(
          value: "No",
          child: Row(
            children: [
              const Icon(Icons.cancel_outlined,
                  color: Colors.redAccent, size: 18),
              const SizedBox(width: 8),
              Text(noLabel),
            ],
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }

  // ── Section header ────────────────────────────────────────
  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accentLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF90CAF9), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Form card ─────────────────────────────────────────────
  Widget _formCard(List<Widget> children) {
    return Container(
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
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => AppTranslations.t(context, key);

    return Scaffold(
      backgroundColor: surface,
      appBar:
      const AppBarWithLang(titleKey: 'app_title', showBackButton: false),
      body: CustomScrollView(
        slivers: [
          // ── Gradient App Bar ────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: primary,
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
                      right: -30,
                      top: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      bottom: -30,
                      child: Container(
                        width: 100,
                        height: 100,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            t('pregnant_screening_header'),
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            t('pregnant_screening_sub'),
                            style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85)),
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

          // ── Form Body ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── Basic Info ────────────────────────────
                    _formCard([
                      _sectionHeader(
                          t('basic_info'), Icons.person_outline_rounded),
                      TextFormField(
                        controller: nameController,
                        style: GoogleFonts.nunito(
                            fontSize: 15, color: textDark),
                        decoration: fieldDecoration(t('woman_name'),
                            icon: Icons.face_outlined),
                        validator: (v) =>
                        v!.isEmpty ? t('name_error') : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: husbandController,
                        style: GoogleFonts.nunito(
                            fontSize: 15, color: textDark),
                        decoration: fieldDecoration(t('husband_name'),
                            icon: Icons.people_outline_rounded),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.nunito(
                            fontSize: 15, color: textDark),
                        decoration: fieldDecoration(t('age'),
                            icon: Icons.cake_outlined),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: trimester,
                        decoration: fieldDecoration(t('trimester'),
                            icon: Icons.pregnant_woman_outlined),
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: accent),
                        style: GoogleFonts.nunito(
                            color: textDark, fontSize: 15),
                        items: [
                          DropdownMenuItem(
                              value: "1st Trimester",
                              child: Text(t('trimester_1'))),
                          DropdownMenuItem(
                              value: "2nd Trimester",
                              child: Text(t('trimester_2'))),
                          DropdownMenuItem(
                              value: "3rd Trimester",
                              child: Text(t('trimester_3'))),
                        ],
                        onChanged: (val) =>
                            setState(() => trimester = val),
                      ),
                    ]),

                    // ── Address ───────────────────────────────
                    _formCard([
                      _sectionHeader(
                          t('address'), Icons.location_on_outlined),
                      TextFormField(
                        controller: addressController,
                        maxLines: 3,
                        style: GoogleFonts.nunito(
                            fontSize: 15, color: textDark),
                        decoration: InputDecoration(
                          labelText: t('full_address'),
                          alignLabelWithHint: true,
                          labelStyle: GoogleFonts.nunito(
                              color: textMuted, fontSize: 14),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 44),
                            child: Icon(Icons.home_outlined,
                                color: accent, size: 20),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFBBDEFB), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFBBDEFB), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: accent, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        validator: (v) =>
                        v!.isEmpty ? t('address_error') : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: wardController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.nunito(
                            fontSize: 15, color: textDark),
                        decoration: fieldDecoration(t('ward_no'),
                            icon: Icons.map_outlined),
                        validator: (v) =>
                        v!.isEmpty ? t('ward_no_error') : null,
                      ),
                    ]),

                    // ── Measurements ──────────────────────────
                    _formCard([
                      _sectionHeader(t('measurements'),
                          Icons.monitor_weight_outlined),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.nunito(
                                  fontSize: 15, color: textDark),
                              decoration: fieldDecoration(t('weight_kg'),
                                  icon: Icons.fitness_center_rounded),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: hbController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.nunito(
                                  fontSize: 15, color: textDark),
                              decoration: fieldDecoration(t('hb'),
                                  icon: Icons.bloodtype_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: systolicController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.nunito(
                                  fontSize: 15, color: textDark),
                              decoration: fieldDecoration(t('systolic_bp'),
                                  icon: Icons.favorite_border_rounded),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: diastolicController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.nunito(
                                  fontSize: 15, color: textDark),
                              decoration: fieldDecoration(t('diastolic_bp'),
                                  icon: Icons.favorite_border_rounded),
                            ),
                          ),
                        ],
                      ),
                    ]),

                    // ── Symptoms ──────────────────────────────
                    _formCard([
                      _sectionHeader(
                          t('symptoms'), Icons.medical_services_outlined),
                      yesNoDropdown(
                        t('dizziness'),
                        dizziness,
                            (val) => setState(() => dizziness = val!),
                        icon: Icons.blind_outlined,
                        yesLabel: t('yes'),
                        noLabel: t('no'),
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        t('fatigue'),
                        fatigue,
                            (val) => setState(() => fatigue = val!),
                        icon: Icons.battery_alert_outlined,
                        yesLabel: t('yes'),
                        noLabel: t('no'),
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        t('swelling'),
                        swelling,
                            (val) => setState(() => swelling = val!),
                        icon: Icons.water_outlined,
                        yesLabel: t('yes'),
                        noLabel: t('no'),
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        t('low_appetite'),
                        lowAppetite,
                            (val) => setState(() => lowAppetite = val!),
                        icon: Icons.no_food_outlined,
                        yesLabel: t('yes'),
                        noLabel: t('no'),
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        t('past_anemia'),
                        pastAnemia,
                            (val) => setState(() => pastAnemia = val!),
                        icon: Icons.history_outlined,
                        yesLabel: t('yes'),
                        noLabel: t('no'),
                      ),
                    ]),

                    // ── Notes ─────────────────────────────────
                    _formCard([
                      _sectionHeader(
                          t('additional_notes'), Icons.notes_rounded),
                      TextFormField(
                        controller: notesController,
                        maxLines: 4,
                        style: GoogleFonts.nunito(
                            fontSize: 15, color: textDark),
                        decoration: InputDecoration(
                          labelText: t('notes_label'),
                          alignLabelWithHint: true,
                          hintText: t('notes_hint'),
                          hintStyle: GoogleFonts.nunito(
                              color: textMuted.withOpacity(0.6),
                              fontSize: 13),
                          labelStyle: GoogleFonts.nunito(
                              color: textMuted, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFBBDEFB), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFBBDEFB), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: accent, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ]),

                    // ── Submit Button ─────────────────────────
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: primary.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final result =
                              await ApiService.submitPregnantScreening(
                                name: nameController.text,
                                husbandName: husbandController.text,
                                age: int.tryParse(ageController.text) ?? 0,
                                trimester: trimester ?? "1st Trimester",
                                weight: double.tryParse(
                                    weightController.text) ??
                                    0,
                                address: addressController.text,
                                wardNo: wardController.text,
                                hemoglobin:
                                double.tryParse(hbController.text) ?? 0,
                                systolicBP: int.tryParse(
                                    systolicController.text) ??
                                    0,
                                diastolicBP: int.tryParse(
                                    diastolicController.text) ??
                                    0,
                                dizziness: dizziness == "Yes",
                                fatigue: fatigue == "Yes",
                                swelling: swelling == "Yes",
                                lowAppetite: lowAppetite == "Yes",
                                pastAnemia: pastAnemia == "Yes",
                                notes: notesController.text,
                              );

                              if (!context.mounted) return;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RiskResultPage(
                                    womenData: {
                                      'hemoglobin': double.tryParse(
                                          hbController.text) ??
                                          0,
                                      'systolicBP': double.tryParse(
                                          systolicController.text) ??
                                          0,
                                      'diastolicBP': double.tryParse(
                                          diastolicController.text) ??
                                          0,
                                      'weight': double.tryParse(
                                          weightController.text) ??
                                          0,
                                      'dizziness': dizziness == "Yes",
                                      'fatigue': fatigue == "Yes",
                                      'swelling': swelling == "Yes",
                                      'lowAppetite': lowAppetite == "Yes",
                                      'pastAnemia': pastAnemia == "Yes",
                                      'wardNo': wardController.text,
                                      'mealPlan': result['mealPlan'],
                                      'nutritionNeed':
                                      result['nutritionNeed'],
                                    },
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "${t('submission_failed')}$e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded,
                                size: 20),
                            const SizedBox(width: 10),
                            Text(
                              t('submit_screening'),
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
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
          ),
        ],
      ),
    );
  }
}