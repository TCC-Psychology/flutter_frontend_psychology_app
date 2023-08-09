import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';

import '../../../shared/services/psychologist_service.dart';

class PsychologistProfileScreen extends StatefulWidget {
  const PsychologistProfileScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistProfileScreen> createState() =>
      _PsychologistProfileScreen();
}

class _PsychologistProfileScreen extends State<PsychologistProfileScreen> {
  final PsychologistService psychologistService = PsychologistService();
  final Psychologist psychologist = Psychologist(
    id: 1,
    certificationNumber: '1',
    userId: 1,
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: psychologist == null
            ? Container()
            : ListView(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10), child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 30,
                        child: FilledButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.blue)),
                          child: const Text(
                            'Editar perfil',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10), child: Container()),
                  Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(100), // Raio dos cantos
                            child: Image.asset(
                              'lib/src/assets/images/logo.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Text(
                            'Fabio Vaz',
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.home_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Alfenas',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.psychology_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Abordagem',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 25)),
                          const Wrap(
                            spacing: 5.0,
                            runSpacing: 2.0,
                            children: [
                              Text(
                                'Ansiedade',
                                style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Ansiedade',
                                style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Ansiedade',
                                style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Ansiedade',
                                style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
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
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      'Como psicólogo, eu sou treinado para compreender e analisar a mente humana e o comportamento. Eu trabalho com indivíduos, grupos e organizações para ajudá-los a melhorar sua saúde mental e bem-estar emocional. Isso pode incluir ajudar as pessoas a lidar com problemas de saúde mental, tais como ansiedade e depressão, ou ajudar casais e famílias a melhorar seus relacionamentos. Eu uso uma variedade de técnicas terapêuticas para ajudar as pessoas a compreender e resolver seus problemas, e trabalho em colaboração com meus pacientes para alcançar seus objetivos.',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    'Telefone',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.none,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Formação Acadêmica",
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          const Column(
                            children: [
                              Text(
                                "Universidade Federal de Alfenas",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Curso de Psicologia",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "2015 - 2020",
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ));
  }
}
