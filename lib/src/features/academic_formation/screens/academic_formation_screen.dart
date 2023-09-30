import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/models/academic_formation_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/academic_formation_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';

import '../../../../main.dart';
import 'academic_formation_create.dart';

class AcademicFormationScreen extends StatefulWidget {
  const AcademicFormationScreen({super.key});

  @override
  _AcademicFormationScreenState createState() =>
      _AcademicFormationScreenState();
}

class _AcademicFormationScreenState extends State<AcademicFormationScreen> {
  AcademicFormationService academicFormationService =
      AcademicFormationService();
  PsychologistService psychologistService = PsychologistService();

  List<AcademicFormation> academicFormationList = [];
  var psychologistLogged = supabase.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();

    loadPageUtilities();
  }

  Future<void> loadPageUtilities() async {
    try {
      EasyLoading.show(status: 'Carregando...');
      await fetchAcademicFormations();

      setState(() {});
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  fetchAcademicFormations() async {
    var psychologist =
        await psychologistService.fetchPsychologistByUserId(psychologistLogged);
    academicFormationList = await academicFormationService
        .fetchAcademicFormationsList(psychologist!.id!.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      "Visualizar Formações",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AcademicFormationsCreateScreen()),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.purple,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (academicFormationList.isNotEmpty)
                    _buildShowAcademicFormations(),
                  if (academicFormationList.isEmpty)
                    const Center(
                      child: Text(
                        'Não possui formação acadêmica',
                        style: TextStyle(color: Colors.purple, fontSize: 16),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShowAcademicFormations() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: academicFormationList.map((academicFormation) {
            return GestureDetector(
              onTap: () async {
                _showMedicalRecordUserClientDetailed(
                    context, academicFormation);
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
                          const Text(
                            'Instituição',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                          Text(
                            academicFormation.institution,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Curso',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                          Text(
                            academicFormation.course,
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Período',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                          Text(
                            '${academicFormation.startDate.year} - ${academicFormation.endDate.year}',
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            'Descrição',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple),
                          ),
                          Text(
                            academicFormation.description ?? "N/A",
                            style: const TextStyle(color: Colors.black),
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

  void _showMedicalRecordUserClientDetailed(
    BuildContext context,
    AcademicFormation academicFormation,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Formação',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Instituição',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            academicFormation.institution,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Curso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            academicFormation.course,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Período',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${academicFormation.startDate.year} - ${academicFormation.endDate.year}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            'Descrição',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            academicFormation.description ?? '',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    _showDeleteConfirmation(
                                        context, academicFormation.id!);
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                await deleteAcademicFormation(medicalRecordId, context);
              },
              child: const Text("Sim"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Não"),
            ),
          ],
        );
      },
    );
  }

  deleteAcademicFormation(int medicalRecordId, BuildContext context) async {
    try {
      EasyLoading.show(status: 'Excluindo...');
      await academicFormationService.deleteAcademicFormation(medicalRecordId);

      await fetchAcademicFormations();
      setState(() {});

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}
