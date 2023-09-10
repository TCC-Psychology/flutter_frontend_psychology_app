import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../models/academic_formation_model.dart';
import '../../../shared/services/academic_formation_service.dart';
import '../../../shared/style/input_decoration.dart';
import 'academic_formation_screen.dart';

class AcademicFormationsCreateScreen extends StatefulWidget {
  const AcademicFormationsCreateScreen({Key? key}) : super(key: key);

  @override
  State<AcademicFormationsCreateScreen> createState() =>
      _AcademicFormationsCreateScreen();
}

class _AcademicFormationsCreateScreen
    extends State<AcademicFormationsCreateScreen> {
  var userLoggedId = supabase.auth.currentUser!.id;

  AcademicFormationService academicFormationsService =
      AcademicFormationService();
  TextEditingController institution = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController startYear = TextEditingController();
  TextEditingController finishedYear = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime selectedStartDate = DateTime(2023, 01, 01);
  DateTime selectedEndDate = DateTime(2023, 01, 01);
  PsychologistService psychologistService = PsychologistService();
  final TextEditingController startDate = TextEditingController();
  DateTime? dateTimeStartDate;
  final TextEditingController endDate = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? dateTimeEndtDate;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Formação Acadêmica",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: SizedBox(
                          child: TextFormField(
                            controller: institution,
                            keyboardType: TextInputType.name,
                            decoration:
                                ProjectInputDecorations.textFieldDecoration(
                              labelText: "Universidade",
                              prefixIcon: Icons.book,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: SizedBox(
                          child: TextFormField(
                            controller: course,
                            keyboardType: TextInputType.name,
                            decoration:
                                ProjectInputDecorations.textFieldDecoration(
                              labelText: "Curso",
                              prefixIcon: Icons.house,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: startDate,
                        decoration: ProjectInputDecorations.textFieldDecoration(
                          labelText: "Inicio da formação",
                          prefixIcon: Icons.date_range,
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedStartDate = pickedDate;
                              DateFormat format = new DateFormat("dd/MM/yyyy");
                              startDate.text = format.format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: endDate,
                        decoration: ProjectInputDecorations.textFieldDecoration(
                          labelText: "Fim da formação",
                          prefixIcon: Icons.date_range,
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedEndDate = pickedDate;
                              DateFormat format = new DateFormat("dd/MM/yyyy");
                              endDate.text = format.format(pickedDate);
                            });
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(top: 25)),
                      SizedBox(
                        height: 150,
                        width: 350,
                        child: ListView(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: TextFormField(
                                  controller: description,
                                  maxLines: 5,
                                  minLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    hintText: 'Descrição...',
                                    hintStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    fillColor: Colors.grey.shade300,
                                    filled: true,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  SizedBox(
                    child: FilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          createAcademicFormation();
                        }
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.blue),
                      ),
                      child: const Text(
                        'Adicionar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  createAcademicFormation() async {
    try {
      EasyLoading.show(status: 'Salvando...');
      AcademicFormation academicFormation = AcademicFormation(
        institution: institution.text,
        course: course.text,
        description: description.text,
        endDate: selectedEndDate.toUtc(),
        startDate: selectedStartDate.toUtc(),
      );

      var psychologist =
          await psychologistService.fetchPsychologistByUserId(userLoggedId);
      await academicFormationsService.createAcademicFormation(
          psychologist!.id.toString(), academicFormation);

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AcademicFormationScreen()),
      );
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
