import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../main.dart';
import '../../../models/medical_appointment_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/services/medical_appointment_service.dart';
import '../../../shared/style/input_decoration.dart';

class MedicalAppointmentCreate extends StatefulWidget {
  final String psychologistId;

  const MedicalAppointmentCreate({required this.psychologistId});

  @override
  _MedicalAppointmentCreateState createState() =>
      _MedicalAppointmentCreateState();
}

class _MedicalAppointmentCreateState extends State<MedicalAppointmentCreate> {
  var clientLogged = supabase.auth.currentUser!.id;

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

  Future<void> _handleDateSelection(DateTime selectedDate) async {
    List<DateTime> datasIguais = medicalAppointments
        .map((appointment) => appointment.date)
        .where((date) =>
            date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day)
        .toList();

    setState(() {
      _selectedDate = selectedDate;
      _selectedTime = null;
      _updateAvailableTimes(datasIguais);
    });
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
      appBar: AppBar(
        title: const Text('Agendamento de Consulta'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            const SizedBox(height: 20),
            if (_selectedDate != null)
              Column(
                children: [
                  const Text('Horários Disponíveis'),
                  const SizedBox(height: 15),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _handleTimeSelection(time);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedTime != null &&
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
                  ElevatedButton(
                    onPressed: handleScheduling,
                    child: const Text("Marcar"),
                  ),
                ],
              ),
          ],
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

      var client = await clientService.fetchClientByUserId(clientLogged);

      MedicalAppointment medicalAppointment = MedicalAppointment(
          date: medicalAppointDate,
          status: AppointmentStatus.pending,
          appointmentType: appointmentType,
          psychologistId: int.parse(widget.psychologistId),
          clientId: client!.id!);

      await medicalAppointmentService
          .createMedicalAppointment(medicalAppointment);
      EasyLoading.showSuccess('Consulta marcada');
    } catch (e) {
      // Handle potential errors
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
