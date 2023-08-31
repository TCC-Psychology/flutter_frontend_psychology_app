import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/medical_appointment_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/triage_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/user.service.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../models/client_model.dart';
import '../../../models/medical_appointment_model.dart';
import '../../../models/triage_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/utils/relationsship_type.dart';

class MedicalAppointmentClientScreen extends StatefulWidget {
  @override
  _MedicalAppointmentClientScreenState createState() =>
      _MedicalAppointmentClientScreenState();
}

class _MedicalAppointmentClientScreenState
    extends State<MedicalAppointmentClientScreen> {
  ClientService clientService = ClientService();
  PsychologistService psychologistService = PsychologistService();
  MedicalAppointmentService medicalAppointmentService =
      MedicalAppointmentService();
  UserProfileService userProfileService = UserProfileService();
  TriageService triageService = TriageService();

  List<MedicalAppointment> medicalAppointments = [];
  List<UserProfile> psychologists = [];
  Client? client;
  AppointmentStatus appointmentStatus = AppointmentStatus.confirmed;

  var userLogged = supabase.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();

    loadPageUtilities();
  }

  Future<void> loadPageUtilities() async {
    client = await clientService.fetchClientByUserId(userLogged);
    await fetchMedicalAppointments();
    setState(() {});
  }

  Future<void> fetchMedicalAppointments() async {
    try {
      EasyLoading.show(status: 'Carregando...');
      medicalAppointments = [];
      medicalAppointments = await medicalAppointmentService
          .fetchMedicalAppointmentByAppointmentsStateList(
              null, client!.id!.toString(), appointmentStatus);
      medicalAppointments.sort((a, b) {
        int dateComparison = b.date.compareTo(a.date);

        if (dateComparison != 0) {
          return dateComparison;
        } else {
          return b.date.hour.compareTo(a.date.hour);
        }
      });

      await loadPsychologists();
      setState(() {});
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            "Minhas consultas",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildMenuButtons(),
          _buildMedicalAppointmentsList(),
        ],
      ),
      bottomNavigationBar: const HorizontalMenu(),
    );
  }

  Widget _buildMenuButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatusButton(AppointmentStatus.pending),
          _buildStatusButton(AppointmentStatus.confirmed),
          _buildStatusButton(AppointmentStatus.canceled),
        ],
      ),
    );
  }

  Widget _buildStatusButton(AppointmentStatus status) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            appointmentStatus = status;
          });
          fetchMedicalAppointments();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              appointmentStatus == status ? Colors.purple : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          status.toString().split('.').last,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMedicalAppointmentsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: medicalAppointments.length,
        itemBuilder: (context, index) {
          final appointment = medicalAppointments[index];
          final psychologist = psychologists[index];
          return _buildAppointmentCard(appointment, psychologist);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
      MedicalAppointment appointment, UserProfile psychologist) {
    return GestureDetector(
      onTap: () {
        onTapCardAppointment(appointment);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Dr. ${psychologist.name}", // Adicionando "Dr." ao nome do psicólogo
                  style: const TextStyle(fontSize: 18, color: Colors.purple),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd MMM').format(appointment.date),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      appointment.status == AppointmentStatus.confirmed
                          ? const Icon(Icons.check_circle,
                              color: Colors.green, size: 24)
                          : appointment.status == AppointmentStatus.pending
                              ? const Icon(Icons.check_circle,
                                  color: Colors.yellow, size: 24)
                              : const Icon(Icons.cancel,
                                  color: Colors.red, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        appointment.status.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Centraliza horizontalmente
                  children: [
                    const Icon(Icons.lock_clock), // Ícone de relógio
                    const SizedBox(width: 8), // Espaço entre o ícone e o texto
                    Text(
                      _formatAppointmentTime(appointment.date),
                      style:
                          const TextStyle(fontSize: 16, color: Colors.purple),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadPsychologists() async {
    psychologists = [];
    for (var appointment in medicalAppointments) {
      final psychologist = await userProfileService
          .fetchUserByPsychologistId(appointment.psychologistId.toString());
      psychologists.add(psychologist!);
    }
  }

  String _formatAppointmentTime(DateTime dateTime) {
    int hour = dateTime.hour;
    String period = hour < 12 ? "AM" : "PM";

    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    return "$hour:${dateTime.minute.toString().padLeft(2, '0')} $period";
  }

  void onTapCardAppointment(MedicalAppointment appointment) {
    showModalBottomSheet(
      isScrollControlled: true, // Faz o modal ocupar toda a altura da tela
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "O que deseja?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para obter a localização
                      Navigator.pop(context); // Fecha o modal
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent),
                    child: const Text(
                      "Localização",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      cancelAppointment(appointment);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var client = await clientService
                          .fetchClientByUserId(appointment.clientId.toString());
                      var user = await userProfileService
                          .fetchUserByClientId(client!.id!.toString());
                      var triage = await triageService
                          .fetchTriageById(appointment.triage);
                      _showMedicalRecordUserClientDetailed(
                          context, user, client);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      "Triagem",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> cancelAppointment(MedicalAppointment appointment) async {
    try {
      EasyLoading.show(status: 'Cancelando...');

      MedicalAppointment medicalAppointment = MedicalAppointment(
          date: appointment.date,
          status: AppointmentStatus.canceled,
          appointmentType: appointment.appointmentType,
          psychologistId: appointment.psychologistId,
          clientId: appointment.clientId);

      await medicalAppointmentService.editMedicalAppointment(
          medicalAppointment, appointment.id.toString());
      await fetchMedicalAppointments();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  void _showMedicalRecordUserClientDetailed(
      BuildContext context, UserProfile user, Client client, Triage triage) {
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
                                      Text(user.cpf,
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      const Text(
                                        'Data de Nascimento',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                          user.birthDate != null
                                              ? user.birthDate.toString()
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
                                      Text(user.phone,
                                          style: const TextStyle(fontSize: 18)),
                                      const SizedBox(height: 16.0),
                                      // const Text(
                                      //   'E-mail',
                                      //   style: TextStyle(
                                      //     fontSize: 18,
                                      //     fontWeight: FontWeight.bold,
                                      //   ),
                                      // ),
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
}
