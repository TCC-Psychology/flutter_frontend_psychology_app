import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../models/medical_appointment_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/services/medical_appointment_service.dart';
import '../../../shared/style/input_decoration.dart';
import '../../triage/triage_create.dart';
import 'medical_appointment_client.dart';
import 'medical_appointment_psychologist.dart';

class MedicalAppointmentCreate extends StatefulWidget {
  final String clientId;
  final String psychologistId;
  final String? appointmentId;

  const MedicalAppointmentCreate({
    required this.psychologistId,
    required this.clientId,
    this.appointmentId,
  });

  @override
  _MedicalAppointmentCreateState createState() =>
      _MedicalAppointmentCreateState();
}

class _MedicalAppointmentCreateState extends State<MedicalAppointmentCreate> {
  MedicalAppointmentService medicalAppointmentService =
      MedicalAppointmentService();
  ClientService clientService = ClientService();
  // ignore: prefer_final_fields
  List<DateTime> _availableTimes = [];
  List<MedicalAppointment> medicalAppointments = [];
  AppointmentType appointmentType = AppointmentType.online;
  DateTime? _selectedDate;
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    loadPageUtilities();
  }

  Future<void> loadPageUtilities() async {
    medicalAppointments = await medicalAppointmentService
        .fetchMedicalAppointmentList(widget.psychologistId, null);
    setState(() {});
  }

  void _handleDateSelection(DateTime selectedDate) {
    List<DateTime> datasIguais = medicalAppointments
        .map((appointment) => appointment.date)
        .where((date) =>
            date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day)
        .toList();

    _selectedDate = selectedDate;
    _selectedTime = null;
    _updateAvailableTimes(datasIguais);
    setState(() {});
  }

  void _updateAvailableTimes(List<DateTime> datasOcupadas) {
    _availableTimes.clear();

    if (_selectedDate != null) {
      for (int startHour = 8; startHour <= 17; startHour += 3) {
        for (int hour = startHour; hour < startHour + 3 && hour <= 16; hour++) {
          if (!datasOcupadas.any((date) => date.hour == hour)) {
            _availableTimes.add(DateTime(
              _selectedDate!.year,
              _selectedDate!.month,
              _selectedDate!.day,
              hour,
              0,
            ));
          }
        }
      }
    }
  }

  void _handleTimeSelection(DateTime selectedTime) {
    setState(() {
      _selectedTime = selectedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime minSelectableDate = now.add(Duration(days: 2));

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Agendamento de Consulta',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    color: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField(
                value: appointmentType,
                decoration: ProjectInputDecorations.textFieldDecoration(
                  labelText: "Tipo de consulta",
                ),
                items: [
                  DropdownMenuItem(
                    value: AppointmentType.online,
                    child: Text(AppointmentType.online.name),
                  ),
                  DropdownMenuItem(
                    value: AppointmentType.presencial,
                    child: Text(AppointmentType.presencial.name),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    appointmentType = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              CalendarDatePicker(
                initialDate: minSelectableDate,
                firstDate: minSelectableDate,
                lastDate: DateTime(2100),
                onDateChanged: _handleDateSelection,
                selectableDayPredicate: (DateTime date) {
                  return date.weekday != DateTime.saturday &&
                      date.weekday != DateTime.sunday;
                },
              ),
              if (_selectedDate != null)
                Column(
                  children: [
                    const Text(
                      'Horários Disponíveis',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: List.generate(_availableTimes.length, (index) {
                        if (index % 3 == 0) {
                          int endIndex = index + 3 <= _availableTimes.length
                              ? index + 3
                              : _availableTimes.length;

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _availableTimes
                                    .sublist(index, endIndex)
                                    .map((time) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _handleTimeSelection(time);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _selectedTime != null &&
                                                    _selectedTime == time
                                                ? Colors.blue
                                                : null,
                                        padding: const EdgeInsets.all(15),
                                        minimumSize: const Size(80, 50),
                                      ),
                                      child: Text('${time.hour}:00'),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: handleScheduling,
                      child: const Text("Marcar"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void handleScheduling() async {
    try {
      if (_selectedDate.isNull || _selectedTime.isNull) {
        await EasyLoading.showError('Selecione o dia e a hora',
            duration: const Duration(seconds: 30));
        await Future.delayed(const Duration(seconds: 1)); // Atraso de 1 segundo
        return;
      }

      EasyLoading.show(status: 'Agendando...');
      DateTime medicalAppointDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      medicalAppointDate =
          medicalAppointDate.subtract(const Duration(hours: 3));

      MedicalAppointment medicalAppointment = MedicalAppointment(
          date: medicalAppointDate.toUtc(),
          status: AppointmentStatus.pending,
          appointmentType: appointmentType,
          psychologistId: int.parse(widget.psychologistId),
          clientId: int.parse(widget.clientId));

      if (widget.appointmentId != null) {
        print("Rermacando consulta");
        medicalAppointment.status = AppointmentStatus.confirmed;

        await medicalAppointmentService.editMedicalAppointment(
            medicalAppointment, widget.appointmentId!);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MedicalAppointmentPsychologistScreen()),
        );
      } else {
        var appointmentCreated = await medicalAppointmentService
            .createMedicalAppointment(medicalAppointment);

        if (appointmentCreated == null) {
          throw Error();
        }

        showTriageModal(appointmentCreated.id!);
      }
    } catch (e) {
      // Handle potential errors
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  void showTriageModal(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Triagem'),
          content:
              const Text('Você deseja fazer uma triagem para esta consulta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TriageScreen(
                            medicalAppointmentId: appointmentId.toString(),
                          )),
                );
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MedicalAppointmentClientScreen()),
                );
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }
}
