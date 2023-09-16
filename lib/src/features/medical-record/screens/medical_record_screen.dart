import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/models/client_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/auth_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/input_formatter_util.dart.dart';
import '../../../../main.dart';
import '../../../models/medical_appointment_model.dart';
import '../../../models/medical_record_model.dart';
import '../../../models/psychologist_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/services/medical_appointment_service.dart';
import '../../../shared/services/medical_record_service.dart';
import '../../../shared/services/psychologist_service.dart';
import '../../../shared/services/user.service.dart';
import '../../../shared/style/input_decoration.dart';
import '../../../shared/utils/relationsship_type.dart';
import 'medical_record_create.dart';
import 'medical_record_edit.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  _MedicalRecordScreenState createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  final MedicalAppointmentService medicalAppointmentService =
      MedicalAppointmentService();
  final MedicalRecordService medicalRecordService = MedicalRecordService();
  final PsychologistService psychologistService = PsychologistService();
  final ClientService clientService = ClientService();
  final UserProfileService userProfileService = UserProfileService();
  final AuthService authService = AuthService();

  List<MedicalAppointment> psychologistMedicalConsultation = [];
  List<UserProfile> users = [];
  List<MedicalRecord> medicalRecorList = [];

  String _selectedValueUserId = "";
  Psychologist? psychologist;
  var psychologistLogged = supabase.auth.currentUser!.id;
  @override
  void initState() {
    super.initState();

    loadPageUtilities();
  }

  Future<void> loadPageUtilities() async {
    try {
      EasyLoading.show(status: 'Carregando...');
      await fetchMedicalAppointments();
      await fetchUsersByClients();

      setState(() {});
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  fetchMedicalAppointments() async {
    psychologist =
        await psychologistService.fetchPsychologistByUserId(psychologistLogged);

    psychologistMedicalConsultation = await medicalAppointmentService
        .fetchMedicalAppointmentList(psychologist!.id!.toString(), 'null');
  }

  Future<void> fetchUsersByClients() async {
    for (MedicalAppointment medicalAppointment
        in psychologistMedicalConsultation) {
      var user = await userProfileService
          .fetchUserByClientId(medicalAppointment.clientId.toString());
      if (!users.any((item) => item.id == user!.id)) {
        if (user != null) {
          users.add(user);
        } else {
          EasyLoading.showError(
            'Erro inesperado, entre em contato com os desenvolveores',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Visualizar Prontuarios",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MedicalRecordCreateForm()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    onChanged: (newValue) async {
                      _selectedValueUserId = newValue!;

                      var client = await clientService
                          .fetchClientByUserId(_selectedValueUserId.toString());
                      medicalRecorList =
                          await medicalRecordService.fetchMedicalRecordtList(
                              psychologist!.id!.toString(),
                              client!.id!.toString());
                      setState(() {});
                    },
                    items: users.isEmpty
                        ? []
                        : users.map((user) {
                            return DropdownMenuItem<String>(
                              value: user.id,
                              child: Text(user.name),
                            );
                          }).toList(),
                    decoration: ProjectInputDecorations.textFieldDecoration(
                      labelText: "Paciente",
                    ),
                    isExpanded: true,
                  ),
                  if (medicalRecorList.isNotEmpty) _buildShowMedicalRecord(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowMedicalRecord() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: medicalRecorList.map((medicalRecord) {
            return GestureDetector(
              onTap: () async {
                var chosenUser = users
                    .singleWhere((user) => user.id == _selectedValueUserId);
                var clientUser = await clientService
                    .fetchClientByUserId(chosenUser.id.toString());
                // ignore: use_build_context_synchronously
                _showMedicalRecordUserClientDetailed(
                    context, chosenUser, clientUser!, medicalRecord);
              },
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2.0,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tema: ${medicalRecord.theme}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8.0),
                          Text('Objetivo: ${medicalRecord.objective}'),
                          const SizedBox(height: 8.0),
                          Text(
                              'Registro de Evolução: ${medicalRecord.evolutionRecord}'),
                          const SizedBox(height: 8.0),
                          Text('Notas: ${medicalRecord.notes ?? ""}'),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Text('Humor:'),
                              _getMoodIcon(int.parse(medicalRecord.mood)),
                            ],
                          ),
                        ],
                      ),
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

  void _showMedicalRecordUserClientDetailed(BuildContext context,
      UserProfile user, Client client, MedicalRecord medicalRecord) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            child: SingleChildScrollView(
              child: DefaultTabController(
                length: 3,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Center(
                        child: Text(
                          'Prontuário',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.person)),
                          Tab(icon: Icon(Icons.task)),
                          Tab(icon: Icon(Icons.info)),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                        child: Container(
                          //aqui
                          height: 400,
                          child: TabBarView(
                            children: [
                              SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Nome',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(user.name,
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'CPF',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          InputFormatterUtil.formatCPF(
                                            user.cpf,
                                          ),
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Idade',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          user.birthDate != null
                                              ? InputFormatterUtil.calculateAge(
                                                  user.birthDate!)
                                              : '',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Telefone',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          InputFormatterUtil.formatPhoneNumber(
                                              user.phone),
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Tema',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(medicalRecord.theme,
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Objetivo',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(medicalRecord.objective,
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Evolução',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(medicalRecord.evolutionRecord,
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Notas',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(medicalRecord.notes ?? '',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Humor',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      _getMoodIcon(
                                          int.parse(medicalRecord.mood)),
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Religião',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(client.religion ?? '',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Estado Civil',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          client.relationshipStatus != null
                                              ? getReadableRelationshipStatus(
                                                  client.relationshipStatus)
                                              : '',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Nome do Pai',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(client.fatherName ?? '',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Profissão do Pai',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(client.fatherOccupation ?? '',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Nome da Mãe',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(client.motherName ?? '',
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Profissão da Mãe',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(client.motherOccupation ?? '',
                                          style: const TextStyle(fontSize: 18)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SingleChildScrollView(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicalRecordEditForm(
                                    medicalRecord: medicalRecord,
                                    userName: user.name,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(Icons.edit), // Ícone de lápis
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmation(
                                  context, medicalRecord.id!);
                            },
                            child: const Icon(Icons.delete),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int medicalRecordId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Excluir item"),
          content: const Text("Tem certeza de que deseja excluir este item?"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await medicalRecordService.deleteMedicalRecord(medicalRecordId);

                var client = await clientService
                    .fetchClientByUserId(_selectedValueUserId.toString());
                medicalRecorList =
                    await medicalRecordService.fetchMedicalRecordtList(
                        psychologistLogged, client!.id!.toString());

                setState(() {});

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Sim"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o modal
              },
              child: const Text("Não"),
            ),
          ],
        );
      },
    );
  }
}
