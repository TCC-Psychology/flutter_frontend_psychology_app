import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/notification/services/notification_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/medical_appointment_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/triage_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/user.service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_frontend_psychology_app/src/models/notification_model.dart'
    as models;
import '../../../../main.dart';
import '../../../models/client_model.dart';
import '../../../models/medical_appointment_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/client_service.dart';
import 'medical_appointment_triage_show.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalAppointmentClientScreen extends StatefulWidget {
  @override
  _MedicalAppointmentClientScreenState createState() =>
      _MedicalAppointmentClientScreenState();
}

class _MedicalAppointmentClientScreenState
    extends State<MedicalAppointmentClientScreen> {
  NotificationService notificationService = NotificationService();
  ClientService clientService = ClientService();
  MedicalAppointmentService medicalAppointmentService =
      MedicalAppointmentService();
  PsychologistService psychologistService = PsychologistService();
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

  Future<void> loadPsychologists() async {
    psychologists = [];
    for (var appointment in medicalAppointments) {
      final psychologist = await userProfileService
          .fetchUserByPsychologistId(appointment.psychologistId.toString());
      psychologists.add(psychologist!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
      ),
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
                  "Dr. ${psychologist.name}",
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_clock),
                    const SizedBox(width: 8),
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

  Future<void> onTapCardAppointment(MedicalAppointment appointment) async {
    var user = await userProfileService
        .fetchUserByPsychologistId(appointment.psychologistId.toString());
    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      isScrollControlled: true,
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
                      if (user!.latitude != "" && user.longitude != "") {
                        openGoogleMaps(user.latitude!, user.longitude!);
                      } else {
                        EasyLoading.showInfo(
                            'O psicologo não cadastrou uma localização',
                            duration: const Duration(seconds: 3));
                      }
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      var client = await clientService
                          .fetchClientById(appointment.clientId.toString());
                      var user = await userProfileService
                          .fetchUserByClientId(client!.id!.toString());
                      var triage = await triageService
                          .fetchTriageById(appointment.id.toString());
                      if (triage != null) {
                        // ignore: use_build_context_synchronously
                        ShowTriage.show(context, user!, client, triage);
                      } else {
                        await EasyLoading.showInfo('Consulta sem triagem!',
                            duration: const Duration(seconds: 3));
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

      var user = await userProfileService
          .fetchUserByClientId(medicalAppointment.clientId.toString());
      var userName = user!.name;
      String formattedDate =
          DateFormat('dd/MM/yyyy HH:mm').format(medicalAppointment.date);
      models.Notification notification = models.Notification(
          description:
              "O cliente $userName cancelou a consulta do dia $formattedDate");
      await notificationService.createNotificacaoForPsychologist(
          notification, medicalAppointment.psychologistId!.toString());

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

  void openGoogleMaps(String latitude, String longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final uri = Uri.parse(url);

    await launchUrl(uri).catchError((e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    });
  }
}
