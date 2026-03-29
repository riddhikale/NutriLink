import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import 'risk_result_page.dart';

class ChildScreeningPage extends StatefulWidget {
  const ChildScreeningPage({super.key});

  @override
  State<ChildScreeningPage> createState() => _ChildScreeningPageState();
}

class _ChildScreeningPageState extends State<ChildScreeningPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final parentController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final muacController = TextEditingController();
  final notesController = TextEditingController();
  final addressController = TextEditingController();

  String? gender;
  String weakness = "No";
  String lowAppetite = "No";
  String frequentIllness = "No";
  String diarrhea = "No";

  static const Color primaryGreen = Color(0xFF1565C0);
  static const Color lightGreen = Color(0xFF1E88E5);
  static const Color accentGreen = Color(0xFFE3F2FD);
  static const Color surfaceColor = Color(0xFFF5F9FF);
  static const Color textDark = Color(0xFF0D1B2A);
  static const Color textMuted = Color(0xFF546E7A);

  InputDecoration fieldDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.nunito(
        color: textMuted,
        fontSize: 14,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: lightGreen, size: 20)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCFE0CF), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCFE0CF), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightGreen, width: 2),
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

  Widget yesNoDropdown(
      String title, String value, Function(String?) onChanged,
      {IconData? icon}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: fieldDecoration(title, icon: icon),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: lightGreen),
      style: GoogleFonts.nunito(
        color: textDark,
        fontSize: 15,
      ),
      items: ["Yes", "No"].map((e) {
        return DropdownMenuItem(
          value: e,
          child: Row(
            children: [
              Icon(
                e == "Yes" ? Icons.check_circle_outline : Icons.cancel_outlined,
                color: e == "Yes" ? lightGreen : Colors.redAccent,
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
              color: accentGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryGreen, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: primaryGreen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFFA5D6A7),
                  Colors.transparent,
                ]),
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
      backgroundColor: surfaceColor,
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
                    // Decorative circles
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
                    // Header text
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Child Screening",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Nutritional assessment form",
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
                      _sectionHeader("Basic Information", Icons.person_outline_rounded),
                      TextFormField(
                        controller: nameController,
                        style: GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: fieldDecoration("Child Name",
                            icon: Icons.child_care_rounded),
                        validator: (v) =>
                        v!.isEmpty ? "Please enter child name" : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: ageController,
                              keyboardType: TextInputType.number,
                              style:
                              GoogleFonts.nunito(fontSize: 15, color: textDark),
                              decoration: fieldDecoration("Age (months)",
                                  icon: Icons.cake_outlined),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: gender,
                              decoration: fieldDecoration("Gender",
                                  icon: Icons.wc_rounded),
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: lightGreen),
                              style: GoogleFonts.nunito(
                                  color: textDark, fontSize: 15),
                              items: ["Male", "Female"]
                                  .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => gender = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: parentController,
                        style: GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: fieldDecoration("Mother / Father Name",
                            icon: Icons.people_outline_rounded),
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
                          labelStyle:
                          GoogleFonts.nunito(color: textMuted, fontSize: 14),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 44),
                            child: Icon(Icons.home_outlined,
                                color: lightGreen, size: 20),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFCFE0CF), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFCFE0CF), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            const BorderSide(color: lightGreen, width: 2),
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
                              controller: heightController,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.nunito(
                                  fontSize: 15, color: textDark),
                              decoration: fieldDecoration("Height (cm)",
                                  icon: Icons.height_rounded),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: muacController,
                        keyboardType: TextInputType.number,
                        style:
                        GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: fieldDecoration("MUAC (cm)",
                            icon: Icons.straighten_rounded),
                      ),
                    ]),

                    // ── Symptoms ────────────────────────────────────────
                    _formCard([
                      _sectionHeader(
                          "Symptoms", Icons.medical_services_outlined),
                      yesNoDropdown(
                        "Weakness",
                        weakness,
                            (val) => setState(() => weakness = val!),
                        icon: Icons.battery_alert_outlined,
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
                        "Frequent Illness",
                        frequentIllness,
                            (val) => setState(() => frequentIllness = val!),
                        icon: Icons.sick_outlined,
                      ),
                      const SizedBox(height: 12),
                      yesNoDropdown(
                        "Diarrhea",
                        diarrhea,
                            (val) => setState(() => diarrhea = val!),
                        icon: Icons.water_drop_outlined,
                      ),
                    ]),

                    // ── Notes ───────────────────────────────────────────
                    _formCard([
                      _sectionHeader("Additional Notes", Icons.notes_rounded),
                      TextFormField(
                        controller: notesController,
                        maxLines: 4,
                        style:
                        GoogleFonts.nunito(fontSize: 15, color: textDark),
                        decoration: InputDecoration(
                          labelText: "Notes (optional)",
                          alignLabelWithHint: true,
                          hintText: "Any additional observations...",
                          hintStyle: GoogleFonts.nunito(
                              color: textMuted.withOpacity(0.6), fontSize: 13),
                          labelStyle:
                          GoogleFonts.nunito(color: textMuted, fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFCFE0CF), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFCFE0CF), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                            const BorderSide(color: lightGreen, width: 2),
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
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0xFF1565C0).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final result2 = await ApiService.submitChildScreening(
                                name: nameController.text,
                                ageMonths: int.tryParse(ageController.text) ?? 0,
                                gender: gender ?? "Male",
                                parentName: parentController.text,
                                weight: double.tryParse(weightController.text) ?? 0,
                                height: double.tryParse(heightController.text) ?? 0,
                                muac: double.tryParse(muacController.text) ?? 0,
                                address: addressController.text,
                                weakness: weakness == "Yes",
                                lowAppetite: lowAppetite == "Yes",
                                frequentIllness: frequentIllness == "Yes",
                                diarrhea: diarrhea == "Yes",
                                notes: notesController.text,
                              );

                              print("API RESULT: $result2"); // ← check console for exact keys

                              // Try common key names your backend might use
                              String risk = (result2['level']
                                  ?? result2['riskLevel']
                                  ?? result2['risk']
                                  ?? "low").toString();

                              if (!context.mounted) return;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RiskResultPage(risk: risk),
                                ),
                              );
                            } catch (e) {
                              print("ERROR: $e"); // ← see what's going wrong
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Submission failed: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },                        child: Row(
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