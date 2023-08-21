import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../models/user_model.dart';
import '../../../shared/services/psychologist_service.dart';
import '../../../shared/services/user_service.dart';

class PsychologistEditProfileScreen extends StatefulWidget {
  const PsychologistEditProfileScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistEditProfileScreen> createState() =>
      _PsychologistEditProfileScreen();
}

class _PsychologistEditProfileScreen
    extends State<PsychologistEditProfileScreen> {
  final PsychologistService psychologistService = PsychologistService();
  final UserService userService = UserService();
  String prevApproach = '';
  User? user = User();
  TextEditingController name = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController approach = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController phone = TextEditingController();
  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: user == null
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: SizedBox(
                                      width: 250,
                                      height: 40,
                                      child: TextFormField(
                                        controller: name,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          hintText: 'Nome',
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
                              )
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                      width: 250,
                                      height: 40,
                                      child: TextFormField(
                                        controller: city,
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                          hintText: 'Cidade',
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
                                            hintText: 'Digite sua descrição...',
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
                                        controller: phone,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          hintText: 'Telefone',
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
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: FilledButton(
                          onPressed: () async {
                            updateUser();
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.blue)),
                          child: const Text(
                            'Salvar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ));
  }

  fetchUser() async {
    EasyLoading.show(status: 'Carregando...');
    var fetchedUser = await userService.fetchUserByUserId("1");
    if (fetchedUser != null) {
      user = fetchedUser;
      setState(() {
        name.text = user?.name ?? "";
        city.text = user?.city ?? "";
        description.text = user?.description ?? "";
        phone.text = user?.phone ?? "";
      });
    } else {
      EasyLoading.showError('Failed to load data.');
    }
    EasyLoading.dismiss();
  }

  updateUser() async {
    EasyLoading.show(status: 'Carregando...');

    User userUptaded = User(
      name: name.text,
      city: city.text,
      description: description.text,
      phone: phone.text,
      cpf: user?.cpf,
      email: user?.email,
      password: user?.password,
    );
    bool isUpdated = false;
    await userService
        .updateUserById("1", userUptaded)
        .then((value) => isUpdated = true);

    if (isUpdated) {
      EasyLoading.showSuccess('Dados atualizados com sucesso!');
    } else {
      EasyLoading.showError('Tente novamente...');
    }
  }
}
