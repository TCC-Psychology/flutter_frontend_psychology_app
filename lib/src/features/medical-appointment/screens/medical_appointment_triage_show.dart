import 'package:flutter/material.dart';

import '../../../models/client_model.dart';
import '../../../models/triage_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/utils/relationsship_type.dart';

class ShowTriage {
  static void show(
      BuildContext context, UserProfile user, Client client, Triage triage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowTriageContent(user: user, client: client, triage: triage);
      },
    );
  }
}

class ShowTriageContent extends StatelessWidget {
  final UserProfile user;
  final Client client;
  final Triage triage;

  ShowTriageContent(
      {required this.user, required this.client, required this.triage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        child: SingleChildScrollView(
          child: DefaultTabController(
            length: 3,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Triagem',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.person)),
                      Tab(icon: Icon(Icons.task)),
                      Tab(icon: Icon(Icons.info)),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SingleChildScrollView(
                    child: Container(
                      // Conteúdo do modal aqui
                      height: 400,
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Nome',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(user.name,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'CPF',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(user.cpf,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Data de Nascimento',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      user.birthDate != null
                                          ? user.birthDate.toString()
                                          : '',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Telefone',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(user.phone,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Causa principal',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Center(
                                    child: Text(triage.chiefComplaint,
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Fatores',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Center(
                                    child: Text(triage.triggeringFacts,
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Sintomas',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Center(
                                    child: Text(triage.currentSymptoms,
                                        style: const TextStyle(fontSize: 18)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Religião',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(client.religion ?? '',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Estado Civil',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                      client.relationshipStatus != null
                                          ? getReadableRelationshipStatus(
                                              client.relationshipStatus)
                                          : '',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Nome do Pai',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(client.fatherName ?? '',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Profissão do Pai',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(client.fatherOccupation ?? '',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Nome da Mãe',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(client.motherName ?? '',
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Profissão da Mãe',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(client.motherOccupation ?? '',
                                      style: const TextStyle(fontSize: 18)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
