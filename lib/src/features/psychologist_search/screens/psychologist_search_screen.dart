import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/user_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';

import '../../../../main.dart';
import '../../../shared/services/user.service.dart';

class PsychologistSearchScreen extends StatefulWidget {
  const PsychologistSearchScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistSearchScreen> createState() =>
      _PsychologistSearchScreenState();
}

class _PsychologistSearchScreenState extends State<PsychologistSearchScreen> {
  final PsychologistService psychologistService = PsychologistService();
  final UserProfileService userProfileService = UserProfileService();
  List<Psychologist> psychologists = [];

  @override
  void initState() {
    super.initState();
    fetchPsychologistList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: psychologists.isEmpty
            ? const Center(
                child: Text('Nenhum psicólogo encontrado.'),
              )
            : ListView.builder(
                itemCount: psychologists.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<UserProfile?>(
                    future: userProfileService.fetchUserByPsychologistId(
                        psychologists[index].id!.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // or any loading indicator
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      var psychologist = psychologists[index];
                      var user = snapshot.data;
                      return GestureDetector(
                        onTap: () async {
                          _openPsychologistModal(context, psychologist);
                        },
                        child: Card(
                          // ... rest of your card widget
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Nome: ${user!.name}'),
                              // Text('Telefone: ${user.phone}'),
                              Text('Localização: ${user.city}, ${user.state}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      bottomNavigationBar: const HorizontalMenu(),
    );
  }

  fetchPsychologistList() async {
    EasyLoading.show(status: 'Buscando...');
    var fetchedPsychologists =
        await psychologistService.fetchPsychologistList();
    psychologists = fetchedPsychologists;
    setState(() {});
    EasyLoading.dismiss();
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
