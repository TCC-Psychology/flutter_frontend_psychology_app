import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/medical-record/screens/medical_record_screen.dart';
import 'package:flutter_frontend_psychology_app/src/models/medical_record_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/medical_record_service.dart';
import '../../../shared/services/user.service.dart';
import '../../../shared/style/input_decoration.dart';

final MedicalRecordService medicalRecordService = MedicalRecordService();

class MedicalRecordEditForm extends StatefulWidget {
  final MedicalRecord medicalRecord;
  final String userName;
  const MedicalRecordEditForm(
      {Key? key, required this.medicalRecord, required this.userName})
      : super(key: key);
  @override
  _MedicalRecordEditFormState createState() => _MedicalRecordEditFormState();
}

class _MedicalRecordEditFormState extends State<MedicalRecordEditForm> {
  UserProfileService userService = UserProfileService();
  final _formKey = GlobalKey<FormState>();
  MedicalRecord? medicalRecord;
  String? notes = '';
  String theme = '';
  String objective = '';
  String evolutionRecord = '';
  int selectedMood = 1;
  int medicalRecordIdEdit = 0;
  UserProfile? user;

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedMood = int.parse(widget.medicalRecord.mood);
    });
  }

  Future<void> loadPageUtilities() async {
    user = await userService
        .fetchUserByUserId(widget.medicalRecord.clientId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Prontuario'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Paciente', // Texto "Paciente" acima do nome do usuário
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.medicalRecord.theme,
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Tema *",
                    prefixIcon: Icons.title,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tema';
                    }
                    return null;
                  },
                  onSaved: (value) => theme = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.medicalRecord.objective,
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Objetivo *",
                    prefixIcon: Icons.folder_copy_sharp,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o objetivo';
                    }
                    return null;
                  },
                  onSaved: (value) => objective = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.medicalRecord.evolutionRecord,
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Evolução *",
                    prefixIcon: Icons.upcoming,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a evolução';
                    }
                    return null;
                  },
                  onSaved: (value) => evolutionRecord = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.medicalRecord.notes ?? '',
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Notas",
                    prefixIcon: Icons.notes,
                  ),
                  onSaved: (value) => notes = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text(
                      'Humor',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 1;
                        });
                      },
                      child: Icon(
                        selectedMood == 1
                            ? Icons.sentiment_very_dissatisfied
                            : Icons.sentiment_very_dissatisfied_outlined,
                        color: selectedMood == 1 ? Colors.red : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 2;
                        });
                      },
                      child: Icon(
                        selectedMood == 2
                            ? Icons.sentiment_dissatisfied
                            : Icons.sentiment_dissatisfied_outlined,
                        color: selectedMood == 2 ? Colors.orange : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 3;
                        });
                      },
                      child: Icon(
                        selectedMood == 3
                            ? Icons.sentiment_neutral
                            : Icons.sentiment_neutral_outlined,
                        color: selectedMood == 3 ? Colors.yellow : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 4;
                        });
                      },
                      child: Icon(
                        selectedMood == 4
                            ? Icons.sentiment_satisfied
                            : Icons.sentiment_satisfied_outlined,
                        color:
                            selectedMood == 4 ? Colors.lightGreen : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 5;
                        });
                      },
                      child: Icon(
                        selectedMood == 5
                            ? Icons.sentiment_very_satisfied
                            : Icons.sentiment_very_satisfied_outlined,
                        color: selectedMood == 5 ? Colors.green : Colors.grey,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      MedicalRecord medicalRecord = MedicalRecord(
                        notes: notes,
                        theme: theme,
                        mood: selectedMood.toString(),
                        objective: objective,
                        evolutionRecord: evolutionRecord,
                      );

                      var id = await medicalRecordService.editMedicalRecord(
                          medicalRecord, widget.medicalRecord.id!);

                      if (id == 1) {
                        setState(() {});
                        EasyLoading.showSuccess(
                          'Prontuario editado',
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicalRecordScreen(),
                          ),
                        );
                      } else {
                        EasyLoading.showError(
                          'Erro inesperado, reinicie o aplicativo',
                        );
                      }
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}