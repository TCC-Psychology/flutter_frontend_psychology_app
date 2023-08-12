import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../models/medical_appointment_model.dart';
import '../../models/medical_record_model.dart';
import '../../models/user_model.dart';
import '../../shared/services/client_service.dart';
import '../../shared/services/medical_appointment_service.dart';
import '../../shared/services/medical_record_service.dart';
import '../../shared/services/psychologist_service.dart';
import '../../shared/services/user.service.dart';
import 'create.dart';

class MedicalRecordIndex extends StatefulWidget {
  const MedicalRecordIndex({super.key});

  @override
  _MedicalRecordIndexState createState() => _MedicalRecordIndexState();
}

class _MedicalRecordIndexState extends State<MedicalRecordIndex> {
  final MedicalAppointmentService medicalAppointmentService = MedicalAppointmentService();
  final MedicalRecordService medicalRecordService = MedicalRecordService();
  final PsychologistService psychologistService = PsychologistService();
  final ClientService clientService = ClientService();
  final UserService userService = UserService();
  
  //TODO - AUTENTICAÇÃO
  var psychologistLoggedId = '1';

  //Using un creatMedicalRecord
  List<MedicalAppointment> psychologistMedicalConsultation = [];
  List<User> users = [];
  List<MedicalRecord> medicalRecorList = [];
  int _selectedValueUserId = -1;
 @override
  void initState() {    
    super.initState();

    loadPageUtilities();
  }

  Future<void> loadPageUtilities() async {
      await fetchMedicalAppointments();
      await fetchUsersForClients();

      setState(() {});
  }

  fetchMedicalAppointments() async {
    var fetchedmedicalAppointments =
        await medicalAppointmentService.fetchMedicalAppointmentList(psychologistLoggedId, 'null');
        //AQUI - RETIRA E DEIXAR SOMENTE ME 1 VARIAVEL
        psychologistMedicalConsultation = fetchedmedicalAppointments;
  }

  Future<void> fetchUsersForClients() async {
    for (MedicalAppointment medicalAppointment in psychologistMedicalConsultation) {
      var user = await userService.fetchUserForClientId(medicalAppointment.clientId.toString());

      if (user != null) {
        users.add(user);
      } else {
        print("Fazer algo que mostre um erro e que é necessario reiniciar o app, pq seria impossivel nao ter user aqui");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar Prontuarios'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicalRecordCreateForm()), // Replace with the actual route
                    );
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  onChanged: (newValue) async {
                    _selectedValueUserId = newValue!;
    
                    var client = await clientService.fetchClientForUserId(_selectedValueUserId!.toString());
                    medicalRecorList = await medicalRecordService.fetchMedicalRecordtList(psychologistLoggedId, client!.id!.toString());
    
                    setState((){});
                  },
                  items: users.isEmpty
                      ? []
                      : users.map((user) {
                          return DropdownMenuItem<int>(
                            value: user.id,
                            child: Text(user.name),
                          );
                        }).toList(),
                  decoration: const InputDecoration(labelText: 'Selecione um paciente'),
                  validator: (value) {
                    if (users.isEmpty) {
                      return 'Não há pacientes relacionados disponíveis.';
                    } else if (value == -1) {
                      return 'Por favor, selecione um paciente';
                    }
                    return null;
                  },
                  onSaved: (value) => _selectedValueUserId = value!,
                ),
                if (medicalRecorList.length != 0) _buildShowMedicalRecord(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }

  Widget _buildShowMedicalRecord() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: medicalRecorList.map((medicalRecord) {
            return SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 2.0,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tema: ${medicalRecord.theme ?? "N/A"}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text('Objetivo: ${medicalRecord.objective ?? "N/A"}'),
                        SizedBox(height: 8.0),
                        Text('Registro de Evolução: ${medicalRecord.evolutionRecord ?? "N/A"}'),
                        SizedBox(height: 8.0),
                        Text('Notas: ${medicalRecord.notes ?? "N/A"}'),
                        SizedBox(height: 8.0),
                        Text('Humor:'),
                        _getMoodIcon(int.parse(medicalRecord.mood)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _getMoodIcon(int mood) {
    IconData iconData;
    Color color;

    switch (mood) {
      case 1:
        iconData = Icons.sentiment_very_dissatisfied;
        color = Colors.red;
        break;
      case 2:
        iconData = Icons.sentiment_dissatisfied;
        color = Colors.orange;
        break;
      case 3:
        iconData = Icons.sentiment_neutral;
        color = Colors.yellow;
        break;
      case 4:
        iconData = Icons.sentiment_satisfied;
        color = Colors.lightGreen;
        break;
      case 5:
        iconData = Icons.sentiment_very_satisfied;
        color = Colors.green;
        break;
      default:
        iconData = Icons.help_outline;
        color = Colors.grey;
    }

    return Icon(
      iconData,
      color: color,
    );
  }
}