import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

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

  String? trimester;

  String dizziness = "No";
  String fatigue = "No";
  String swelling = "No";
  String lowAppetite = "No";
  String pastAnemia = "No";

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget yesNoDropdown(String title, String value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: fieldDecoration(title),
      items: ["Yes", "No"]
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Pregnant Women Screening"),
        backgroundColor: const Color(0xFF4CAF50),
      ),

      backgroundColor: const Color(0xFFF5F6F8),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Form(
              key: _formKey,

              child: Column(
                children: [

                  Text(
                    "Pregnancy Screening Form",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    decoration: fieldDecoration("Name"),
                    validator: (v) => v!.isEmpty ? "Enter name" : null,
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: husbandController,
                    decoration: fieldDecoration("Husband/Father Name"),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Age"),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: trimester,
                    decoration: fieldDecoration("Trimester"),
                    items: ["1st Trimester", "2nd Trimester", "3rd Trimester"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        trimester = val;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Weight (kg)"),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: hbController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Haemoglobin (g/dL)"),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: systolicController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Systolic BP"),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: diastolicController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Diastolic BP"),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Symptoms",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  yesNoDropdown(
                      "Dizziness",
                      dizziness,
                          (val) => setState(() => dizziness = val!)),

                  const SizedBox(height: 12),

                  yesNoDropdown(
                      "Fatigue",
                      fatigue,
                          (val) => setState(() => fatigue = val!)),

                  const SizedBox(height: 12),

                  yesNoDropdown(
                      "Swelling",
                      swelling,
                          (val) => setState(() => swelling = val!)),

                  const SizedBox(height: 12),

                  yesNoDropdown(
                      "Low Appetite",
                      lowAppetite,
                          (val) => setState(() => lowAppetite = val!)),

                  const SizedBox(height: 12),

                  yesNoDropdown(
                      "Past Anemia",
                      pastAnemia,
                          (val) => setState(() => pastAnemia = val!)),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: fieldDecoration("Notes"),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {

                          final result = await ApiService.submitPregnantScreening(

                            beneficiaryId: nameController.text,

                            name: nameController.text,
                            husbandName: husbandController.text,
                            age: int.parse(ageController.text),

                            trimester: trimester ?? "1st Trimester",

                            weight: double.parse(weightController.text),
                            hemoglobin: double.parse(hbController.text),

                            systolicBP: int.parse(systolicController.text),
                            diastolicBP: int.parse(diastolicController.text),

                            dizziness: dizziness == "Yes",
                            fatigue: fatigue == "Yes",
                            swelling: swelling == "Yes",
                            lowAppetite: lowAppetite == "Yes",
                            pastAnemia: pastAnemia == "Yes",

                            notes: notesController.text,
                          );

                          print(result);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Screening Data Submitted")),
                          );

                        }

                      },

                      child: const Text(
                        "Submit Screening",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}