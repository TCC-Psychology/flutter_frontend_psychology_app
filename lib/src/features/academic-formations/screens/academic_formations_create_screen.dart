import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/academic_formations_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../main.dart';
import '../../../models/academic_formation_model.dart';
import '../../psychologist_profile/psychologist_profile_screen.dart';

class AcademicFormationsCreateScreen extends StatefulWidget {
  const AcademicFormationsCreateScreen({Key? key}) : super(key: key);

  @override
  State<AcademicFormationsCreateScreen> createState() =>
      _AcademicFormationsCreateScreen();
}

class _AcademicFormationsCreateScreen
    extends State<AcademicFormationsCreateScreen> {
  var idUserLogged = supabase.auth.currentUser!.id;
  final locale = Get.locale;
  AcademicFormationsService academicFormationsService =
      AcademicFormationsService();
  TextEditingController institution = TextEditingController();
  TextEditingController course = TextEditingController();
  TextEditingController startYear = TextEditingController();
  TextEditingController finishedYear = TextEditingController();
  TextEditingController description = TextEditingController();
  DateTime selectedStartDate = DateTime(2023, 01, 01);
  DateTime selectedEndDate = DateTime(2023, 01, 01);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(10), child: Container()),
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: SizedBox(
                        width: 350,
                        height: 40,
                        child: TextFormField(
                          controller: institution,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'Universidade',
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
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
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Align(
                      alignment: const AlignmentDirectional(0, 0),
                      child: SizedBox(
                        width: 350,
                        height: 40,
                        child: TextFormField(
                          controller: course,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'Curso',
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
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
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: SizedBox(
                                width: 160,
                                height: 40,
                                child: TextButton(
                                  onPressed: () => _selectStartDate(context),
                                  child: Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(selectedStartDate),
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: SizedBox(
                                width: 160,
                                height: 40,
                                child: TextButton(
                                    onPressed: () => _selectEndDate(context),
                                    child: Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(selectedEndDate),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                                ))
                          ],
                        )),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  width: 150,
                  height: 40,
                  child: FilledButton(
                    onPressed: () async {
                      createAcademicFormation();
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.blue)),
                    child: const Text(
                      'Adicionar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  createAcademicFormation() async {
    EasyLoading.show(status: 'Carregando...');
    AcademicFormation academicFormation = AcademicFormation(
      institution: institution.text,
      course: course.text,
      description: description.text,
      endDate: selectedEndDate.toUtc(),
      startDate: selectedStartDate.toUtc(),
    );
    await academicFormationsService
        .createAcademicFormation(idUserLogged, academicFormation)
        .then((value) => {
              EasyLoading.showSuccess('Dados atualizados com sucesso!'),
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PsychologistProfileScreen()),
              ),
            });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(1970, 01, 01),
        lastDate: DateTime(2027, 01, 01),
        locale: locale);

    if (picked != selectedStartDate && picked != null) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2023, 05, 15),
      firstDate: DateTime(1970, 01, 01),
      lastDate: DateTime(2027, 01, 01),
    );

    if (picked != selectedEndDate && picked != null) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }
}
