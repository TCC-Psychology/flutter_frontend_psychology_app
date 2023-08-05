import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../models/medical_appointment_model.dart';
import '../../models/medical_record_model.dart';
import '../../shared/services/medical_appointment_service.dart';
import '../../shared/services/psychologist_service.dart';

class MedicalRecordCreateForm extends StatefulWidget {
  const MedicalRecordCreateForm({super.key});

  @override
  _MedicalRecordCreateFormState createState() => _MedicalRecordCreateFormState();
}

class _MedicalRecordCreateFormState extends State<MedicalRecordCreateForm> {
  final PsychologistService psychologistService = PsychologistService();
  final MedicalAppointmentService medicalAppointmentService = MedicalAppointmentService();
  
  //TODO - AUTENTICAÇÃO
  var psychologistLogged = '1';

  List<MedicalAppointment> psychologistMedicalConsultation = [];
  List<Client> clients = [];
  int _selectedValueClient = -1;

 @override
  void initState() {
    super.initState();
    loadMedicalAppointments();
  }

  Future<void> loadMedicalAppointments() async {
    await fetchMedicalAppointments();

    for (MedicalAppointment consultation in psychologistMedicalConsultation) {
      clients.add(consultation.client);
    }
  }


  final _formKey = GlobalKey<FormState>();
  String notes = '';
  String theme = '';
  String mood = '';
  String objective = '';
  String evolutionRecord = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Medical Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValueClient = newValue!;
                    });
                  },
                  items: clients.isEmpty
                      ? []
                      : clients.map((client) {
                          return DropdownMenuItem<int>(
                            value: client.id,
                            child: Text(client.fatherName),
                          );
                        }).toList(),
                  decoration: const InputDecoration(labelText: 'Selecione um paciente'),
                  validator: (value) {
                    if (clients.isEmpty) {
                      return 'Não há clientes relacionados disponíveis.';
                    } else if (value == -1) {
                      return 'Por favor, selecione um paciente';
                    }
                    return null;
                  },
                  onSaved: (value) => _selectedValueClient = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Notas'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira as notas';
                    }
                    return null;
                  },
                  onSaved: (value) => notes = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tema'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tema';
                    }
                    return null;
                  },
                  onSaved: (value) => theme = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Humor'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o humor';
                    }
                    return null;
                  },
                  onSaved: (value) => mood = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Objetivo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o objetivo';
                    }
                    return null;
                  },
                  onSaved: (value) => objective = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Registro de evolução'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o registro de evolução';
                    }
                    return null;
                  },
                  onSaved: (value) => evolutionRecord = value!,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      //TODO - AUTENTICAÇÃO
                      var psychologist = await psychologistService.fetchPsychologistById(psychologistLogged);
                      
                      MedicalRecord medicalRecord = MedicalRecord(
                        id: 1, // Substitua pelo valor correto do ID, se aplicável
                        createdAt: DateTime.now(), // Substitua pela data correta
                        updatedAt: DateTime.now(), // Substitua pela data correta
                        notes: notes,
                        theme: theme,
                        mood: mood,
                        objective: objective,
                        evolutionRecord: evolutionRecord,
                        psychologist: psychologist
                      );
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

  fetchMedicalAppointments() async {
    var fetchedmedicalAppointments =
        await medicalAppointmentService.fetchMedicalAppointmentList(psychologistLogged, 'null');
    
    psychologistMedicalConsultation = fetchedmedicalAppointments;
    setState(() {});
  }
}
