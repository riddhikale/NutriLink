import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import 'risk_result_page.dart';

class PregnantScreeningPage extends StatefulWidget {
  const PregnantScreeningPage({super.key});

  @override
  State<PregnantScreeningPage> createState() => _PregnantScreeningPageState();
}

class _PregnantScreeningPageState extends State<PregnantScreeningPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final husbandController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final hbController = TextEditingController();
  final systolicController = TextEditingController();
  final diastolicController = TextEditingController();
  final notesController = TextEditingController();
  final addressController = TextEditingController();

  String? trimester;
  String dizziness = "No";
  String fatigue = "No";
  String swelling = "No";
  String lowAppetite = "No";
  String pastAnemia = "No";

  static const Color primary = Color(0xFF1565C0);
  static const Color accent = Color(0xFF1E88E5);
  static const Color accentLight = Color(0xFFE3F2FD);
  static const Color surface = Color(0xFFF5F9FF);
  static const Color textDark = Color(0xFF0D1B2A);
  static const Color textMuted = Color(0xFF546E7A);

  InputDecoration fieldDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.nunito(color: textMuted, fontSize: 14),
      prefixIcon: icon != null ? Icon(icon, color: accent, size: 20) : null,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget yesNoDropdown(String title, String value, Function(String?) onChanged,
      {IconData? icon}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: fieldDecoration(title, icon: icon),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: accent),
      style: GoogleFonts.nunito(color: textDark, fontSize: 15),
      items: ["Yes", "No"].map((e) {
        return DropdownMenuItem(
          value: e,
          child: Row(
            children: [
              Icon(
                e == "Yes" ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: e == "Yes" ? accent : Colors.redAccent,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(e),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

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
              color: primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF90CAF9), Colors.transparent]),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
    return Scaffold(
      backgroundColor: surface,
      body: CustomScrollView(
        slivers: [
          // ── Gradient App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: const Color(0xFF1565C0),
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
                            "Pregnant Women Screening",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Maternal health assessment form",
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.85),
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

          // ── Form Body ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── Basic Info ──────────────────────────────────────
                    _formCard([
                      _sectionHeader(
                          "Basic Information", Icons.person_outline_rounded),
                      TextFormField(
                        controller: nameController,
                        style: GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: fieldDecoration("Name",
                            icon: Icons.face_outlined),
                        validator: (v) =>
                        v!.isEmpty ? "Please enter name" : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: husbandController,
                        style: GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: fieldDecoration("Husband / Father Name",
                            icon: Icons.people_outline_rounded),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: fieldDecoration("Age", icon: Icons.cake_outlined),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: trimester,
                        decoration: fieldDecoration("Trimester",
                            icon: Icons.pregnant_woman_outlined),
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: accent),
                        style: GoogleFonts.nunito(color: textDark, fontSize: 15),
                        items: [
                          "1st Trimester",
                          "2nd Trimester",
                          "3rd Trimester",
                        ]
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) => setState(() => trimester = val),
                      ),
                    ]),

                    // ── Address ─────────────────────────────────────────
                    _formCard([
                      _sectionHeader("Address", Icons.location_on_outlined),
                      TextFormField(
                        controller: addressController,
                        maxLines: 3,
                        style: GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: InputDecoration(
                          labelText: "Full Address",
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
                            borderSide:
                            const BorderSide(color: accent, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        validator: (v) =>
                        v!.isEmpty ? "Please enter address" : null,
                      ),
                    ]),

                    // ── Measurements ────────────────────────────────────
                    _formCard([
                      _sectionHeader(
                          "Measurements", Icons.monitor_weight_outlined),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.nunito(
                                  fontSize: 15, color: textDark),
                              decoration: fieldDecoration("Weight (kg)",
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
                              decoration: fieldDecoration("Hb (g/dL)",
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
                              decoration: fieldDecoration("Systolic BP",
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
                              decoration: fieldDecoration("Diastolic BP",
                                  icon: Icons.favorite_border_rounded),
                            ),
                          ),
                        ],
                      ),
                    ]),

                    // ── Symptoms ────────────────────────────────────────
                    _formCard([
                      _sectionHeader(
                          "Symptoms", Icons.medical_services_outlined),
                      yesNoDropdown(
                        "Dizziness",
                        dizziness,
                            (val) => setState(() => dizziness = val!),
                        icon: Icons.blind_outlined,
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        "Fatigue",
                        fatigue,
                            (val) => setState(() => fatigue = val!),
                        icon: Icons.battery_alert_outlined,
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        "Swelling",
                        swelling,
                            (val) => setState(() => swelling = val!),
                        icon: Icons.water_outlined,
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        "Low Appetite",
                        lowAppetite,
                            (val) => setState(() => lowAppetite = val!),
                        icon: Icons.no_food_outlined,
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        "Past Anemia",
                        pastAnemia,
                            (val) => setState(() => pastAnemia = val!),
                        icon: Icons.history_outlined,
                      ),
                    ]),

                    // ── Notes ───────────────────────────────────────────
                    _formCard([
                      _sectionHeader("Additional Notes", Icons.notes_rounded),
                      TextFormField(
                        controller: notesController,
                        maxLines: 4,
                        style: GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: InputDecoration(
                          labelText: "Notes (optional)",
                          alignLabelWithHint: true,
                          hintText: "Any additional observations...",
                          hintStyle: GoogleFonts.nunito(
                              color: textMuted.withOpacity(0.6), fontSize: 13),
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
                            borderSide:
                            const BorderSide(color: accent, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ]),

                    // ── Submit Button ────────────────────────────────────
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
                              final result = await ApiService.submitPregnantScreening(
                                name: nameController.text,
                                husbandName: husbandController.text,
                                age: int.tryParse(ageController.text) ?? 0,
                                trimester: trimester ?? "1st Trimester",
                                weight: double.tryParse(weightController.text) ?? 0,
                                address: addressController.text,
                                hemoglobin: double.tryParse(hbController.text) ?? 0,
                                systolicBP: int.tryParse(systolicController.text) ?? 0,
                                diastolicBP: int.tryParse(diastolicController.text) ?? 0,
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
                                      'hemoglobin':    double.tryParse(hbController.text) ?? 0,
                                      'systolicBP':    double.tryParse(systolicController.text) ?? 0,
                                      'diastolicBP':   double.tryParse(diastolicController.text) ?? 0,
                                      'weight':        double.tryParse(weightController.text) ?? 0,
                                      'dizziness':     dizziness == "Yes",
                                      'fatigue':       fatigue == "Yes",
                                      'swelling':      swelling == "Yes",
                                      'lowAppetite':   lowAppetite == "Yes",
                                      'pastAnemia':    pastAnemia == "Yes",
                                      'mealPlan':      result['mealPlan'],
                                      'nutritionNeed': result['nutritionNeed'],
                                    },
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Submission failed: $e"),
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
                              "Submit Screening",
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
          ),
        ],
      ),
    );
  }
}