import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/medical_appointment_service.dart';

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
  DateTime? _selectedDate;
  DateTime? _selectedTime;

  Future<void> _handleDateSelection(DateTime selectedDate) async {
    var medicalAppointments = await medicalAppointmentService
        .fetchMedicalAppointmentList(widget.psychologistId, null);
    for (var item in medicalAppointments) {
      print(item.toJson());
    }
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
          title: Text('Create Medical Appointment'),
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
                    Text('Select a time:'),
                    SizedBox(height: 15), // Aumentei o espaçamento vertical
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
