import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';

import '../../../../main.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/services/user.service.dart';
import '../../medical-appointment/screens/medical_appointment_create.dart';

class PsychologistSearchScreen extends StatefulWidget {
  const PsychologistSearchScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistSearchScreen> createState() =>
      _PsychologistSearchScreenState();
}

class _PsychologistSearchScreenState extends State<PsychologistSearchScreen> {
  final ClientService clientService = ClientService();
  final PsychologistService psychologistService = PsychologistService();
  final UserProfileService userProfileService = UserProfileService();
  List<Psychologist> psychologists = [];
  List<UserProfile> users = [];

  @override
  void initState() {
    super.initState();

    loadPageUtilities();
  }

  loadPageUtilities() async {
    try {
      EasyLoading.show(status: 'Procurando...');
      await fetchPsychologistList();
      await fetchUsersByPsychologist();

      setState(() {});
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  fetchPsychologistList() async {
    psychologists = [];
    psychologists = await psychologistService.fetchPsychologistList();
    EasyLoading.dismiss();
  }

  fetchUsersByPsychologist() async {
    for (var psychologist in psychologists) {
      var user = await userProfileService
          .fetchUserByPsychologistId(psychologist.id.toString());

      if (!users.any((item) => item.id == user!.id)) {
        if (user != null) {
          users.add(user);
        } else {
          EasyLoading.showError(
            'Erro inesperado, reinicie o aplicativo.',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              "Listagem de psicologos",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (psychologists.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: psychologists.length,
                itemBuilder: (context, index) {
                  Psychologist psychologist = psychologists[index];
                  UserProfile user =
                      users.firstWhere((u) => u.id == psychologist.userId);

                  return GestureDetector(
                    onTap: () {
                      _openPsychologistModal(context, psychologist);
                    },
                    child: Card(
                      margin: const EdgeInsets.all(16.0),
                      child: ListTile(
                        leading: const Icon(
                          Icons
                              .account_circle, // Placeholder icon, you can replace this
                          size: 48.0,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              user.name,
                              style: const TextStyle(
                                color: Colors.purple,
                              ),
                            )),
                            Text('${user.city}, ${user.state}'),
                            Text(user.phone),
                            Text(
                                'Certificate Number: ${psychologist.certificationNumber}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            if (psychologists.isEmpty)
              const Center(
                child: Text('No psychologists found.'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const HorizontalMenu(),
    );
  }

  Future<void> _openPsychologistModal(
      BuildContext context, Psychologist psychologist) async {
    var user = await userProfileService
        .fetchUserByPsychologistId(psychologist.id.toString());

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.person), text: 'Perfil'),
                  Tab(icon: Icon(Icons.location_on), text: 'Localização'),
                  Tab(icon: Icon(Icons.tag), text: 'Tags'),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    var client = await clientService
                        .fetchClientByUserId(supabase.auth.currentUser!.id);
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MedicalAppointmentCreate(
                                psychologistId: psychologist.id!.toString(),
                                clientId: client!.id!.toString(),
                                appointmentId: null,
                              )),
                    );
                  },
                ),
              ],
            ),
            body: TabBarView(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16.0),
                        Center(
                          child: Text(user!.name,
                              style: const TextStyle(fontSize: 20)),
                        ),
                        Center(
                          child: Text(
                              'Número de Certificação: ${psychologist.certificationNumber ?? "N/A"}',
                              style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 16.0),
                        // Center(
                        //   child: Text('Telefone: ${user.phone}',
                        //       style: const TextStyle(fontSize: 16)),
                        // ),
                        const Center(child: SizedBox(height: 16.0)),
                        Text('CPF: ${user.cpf}',
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Text('CEP: ${user.cep ?? "N/A"}',
                              style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text('Cidade: ${user.city ?? "N/A"}',
                              style: const TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(height: 10),
                        Text('Estado: ${user.state ?? "N/A"}',
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para obter rota quando o botão for pressionado
                            // Isso pode envolver integração com APIs de mapas, por exemplo
                            // Substitua este comentário com o código necessário
                          },
                          child: const Text('Obter Rota',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
