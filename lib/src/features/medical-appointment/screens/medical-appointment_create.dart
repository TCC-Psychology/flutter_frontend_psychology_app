import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/medical_appointment_service.dart';

import '../../../models/medical_appointment_model.dart';

class MedicalAppointmentCreate extends StatefulWidget {
  final String psychologistId;

  const MedicalAppointmentCreate({required this.psychologistId});

  @override
  _MedicalAppointmentCreateState createState() =>
      _MedicalAppointmentCreateState();
}

class _MedicalAppointmentCreateState extends State<MedicalAppointmentCreate> {
  MedicalAppointmentService medicalAppointmentService =
      MedicalAppointmentService();
  List<MedicalAppointment> medicalAppointments = [];
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
    //2023-08-22T10:00:00.000Z
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
    });
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
          title: const Text('Agendamento do consulta'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CalendarDatePicker(
                initialDate: minSelectableDate,
                firstDate: minSelectableDate,
                lastDate: DateTime(2100),
                onDateChanged: _handleDateSelection,
                selectableDayPredicate: (DateTime date) {
                  if (date.weekday == DateTime.saturday ||
                      date.weekday == DateTime.sunday) {
                    return false;
                  }
                  return true;
                },
              ),
              SizedBox(height: 20),
              if (_selectedDate != null)
                Column(
                  children: [
                    const Text('Horarios disponiveis'),
                    const SizedBox(
                        height: 15), // Aumentei o espaçamento vertical
                    Column(
                      children: [
                        for (int startHour = 8; startHour <= 17; startHour += 3)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int hour = startHour;
                                      hour < startHour + 3;
                                      hour++)
                                    if (hour <= 16)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                8), // Espaçamento horizontal entre os botões
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _handleTimeSelection(
                                              DateTime(
                                                _selectedDate!.year,
                                                _selectedDate!.month,
                                                _selectedDate!.day,
                                                hour,
                                                0,
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _selectedTime !=
                                                        null &&
                                                    _selectedTime!.hour == hour
                                                ? Colors.blue
                                                : null,
                                            padding: const EdgeInsets.all(
                                                15), // Espaçamento interno
                                            minimumSize: const Size(80,
                                                50), // Tamanho mínimo do botão
                                          ),
                                          child: Text('$hour:00'),
                                        ),
                                      ),
                                ],
                              ),
                              const SizedBox(
                                  height:
                                      10), // Espaçamento vertical entre as linhas
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}
