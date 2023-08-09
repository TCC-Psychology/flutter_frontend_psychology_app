import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';

import '../../../shared/services/psychologist_service.dart';

class PsychologistEditProfileScreen extends StatefulWidget {
  const PsychologistEditProfileScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistEditProfileScreen> createState() =>
      _PsychologistEditProfileScreen();
}

class _PsychologistEditProfileScreen
    extends State<PsychologistEditProfileScreen> {
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
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.image_search_outlined)),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: SizedBox(
                              width: 250,
                              height: 40,
                              child: TextFormField(
                                //controller: document,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: 'Nome',
                                  labelStyle: const TextStyle(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.home_outlined,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: SizedBox(
                                      width: 170,
                                      height: 40,
                                      child: TextFormField(
                                        //controller: document,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          labelText: 'Cidade',
                                          labelStyle: const TextStyle(
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.psychology_outlined,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: SizedBox(
                                      width: 170,
                                      height: 40,
                                      child: TextFormField(
                                        //controller: document,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          labelText: 'Abordagem',
                                          labelStyle: const TextStyle(
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      child: SingleChildScrollView(
                                        child: TextFormField(
                                          //controller: document,
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                            hintText: 'Digite seu texto...',
                                            labelStyle: const TextStyle(
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.message_outlined,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: SizedBox(
                                      width: 250,
                                      height: 40,
                                      child: TextFormField(
                                        //controller: document,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          labelText: 'Telefone',
                                          labelStyle: const TextStyle(
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ));
  }
}
