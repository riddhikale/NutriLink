import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';

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

  String? gender;
  String weakness = "No";
  String lowAppetite = "No";
  String frequentIllness = "No";
  String diarrhea = "No";

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
        title: const Text("Child Screening"),
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
                    "Child Screening Form",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    decoration: fieldDecoration("Child Name"),
                    validator: (v) => v!.isEmpty ? "Enter child name" : null,
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Age (months)"),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: fieldDecoration("Gender"),
                    items: ["Male", "Female"]
                        .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        gender = val;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: parentController,
                    decoration: fieldDecoration("Mother/Father Name"),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Weight (kg)"),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("Height (cm)"),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: muacController,
                    keyboardType: TextInputType.number,
                    decoration: fieldDecoration("MUAC (cm)"),
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
                      "Weakness", weakness, (val) => setState(() => weakness = val!)),

                  const SizedBox(height: 12),

                  yesNoDropdown("Low Appetite", lowAppetite,
                          (val) => setState(() => lowAppetite = val!)),

                  const SizedBox(height: 12),

                  yesNoDropdown("Frequent Illness", frequentIllness,
                          (val) => setState(() => frequentIllness = val!)),

                  const SizedBox(height: 12),

                  yesNoDropdown(
                      "Diarrhea", diarrhea, (val) => setState(() => diarrhea = val!)),

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

                          final result = await ApiService.submitChildScreening(

                            beneficiaryId: nameController.text,

                            name: nameController.text,
                            ageMonths: int.parse(ageController.text),
                            gender: gender ?? "Male",
                            parentName: parentController.text,

                            weight: double.parse(weightController.text),
                            height: double.parse(heightController.text),
                            muac: double.parse(muacController.text),

                            weakness: weakness == "Yes",
                            lowAppetite: lowAppetite == "Yes",
                            frequentIllness: frequentIllness == "Yes",
                            diarrhea: diarrhea == "Yes",

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