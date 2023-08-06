import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../models/medical_appointment_model.dart';
import '../../models/medical_record_model.dart';
import '../../models/user_model.dart';
import '../../shared/services/medical_appointment_service.dart';
import '../../shared/services/medical_record_service.dart';
import '../../shared/services/psychologist_service.dart';
import '../../shared/services/user.service.dart';

class MedicalRecordCreateForm extends StatefulWidget {
  const MedicalRecordCreateForm({super.key});

  @override
  _MedicalRecordCreateFormState createState() => _MedicalRecordCreateFormState();
}

class _MedicalRecordCreateFormState extends State<MedicalRecordCreateForm> {
  final PsychologistService psychologistService = PsychologistService();
  final MedicalAppointmentService medicalAppointmentService = MedicalAppointmentService();
  final UserService userService = UserService();
  final MedicalRecordService medicalRecordService = MedicalRecordService();
  
  //TODO - AUTENTICAÇÃO
  var psychologistLogged = '1';

  List<MedicalAppointment> psychologistMedicalConsultation = [];
  List<Client> clients = [];
  List<User> users = [];
  int _selectedValueClient = -1;

 @override
  void initState() {    
    super.initState();

    loadMedicalAppointments();
  }

  Future<void> loadMedicalAppointments() async {
      await fetchMedicalAppointments();
      await fetchClientsFromMedicalAppointments();
      await fetchUsersForClients();

      setState(() {});
  }

  Future<void> fetchClientsFromMedicalAppointments() async {
    for (MedicalAppointment consultation in psychologistMedicalConsultation) {
      clients.add(consultation.client);
    }
  }

  Future<void> fetchUsersForClients() async {
    for (Client client in clients) {
      var user = await userService.fetchUser(client.userId.toString());
      if (user != null) {
        users.add(user);
      } else {
        print("Não tem possibilidade, se não é erro de BD");
      }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showAddModal(context);
                      },
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.link),
                      onPressed: () {
                        _showLinkModal(context);
                      },
                    ),
                  ],
                ),
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
                            value: users.firstWhere((user) => user.id == client.userId).id,
                            child: Text(users.firstWhere((user) => user.id == client.userId).name),
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
                      print(_selectedValueClient);
                      var clientSelected =  clients.firstWhere((c) => c.userId == _selectedValueClient);
                      print (clientSelected);
                      MedicalRecord medicalRecord = MedicalRecord(
                        createdAt: DateTime.now(), // Substitua pela data correta
                        updatedAt: DateTime.now(), // Substitua pela data correta
                        notes: notes,
                        theme: theme,
                        mood: mood,
                        objective: objective,
                        evolutionRecord: evolutionRecord,
                        psychologist: psychologist,
                        client: clients.firstWhere((client) => client.userId == _selectedValueClient)
                      );
                      var id = await medicalRecordService.createMedicalRecord(medicalRecord);
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
  }

  void _showAddModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Número'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para salvar o novo cliente
                  Navigator.of(context).pop();
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLinkModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Link CPF'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'CPF'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para pesquisar o CPF
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text('Pesquisar'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
