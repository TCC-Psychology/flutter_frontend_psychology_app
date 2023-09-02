import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/academic-formations/screens/academic_formations_create_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/academic-formations/screens/academic_formations_update_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_profile/psychologist_edit_profile_screen.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/user.service.dart';

import '../../../main.dart';
import '../../models/academic_formation_model.dart';
import '../../models/user_model.dart';
import '../../shared/services/academic_formations_service.dart';

class PsychologistProfileScreen extends StatefulWidget {
  const PsychologistProfileScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistProfileScreen> createState() =>
      _PsychologistProfileScreen();
}

class _PsychologistProfileScreen extends State<PsychologistProfileScreen> {
  var idUserLogged = supabase.auth.currentUser!.id;
  final UserProfileService userProfileService = UserProfileService();
  UserProfile? user = UserProfile(cpf: '', name: '', phone: '');
  List<AcademicFormation>? academicFormations;
  final AcademicFormationsService academicFormationsServiceService =
      AcademicFormationsService();
  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchAcademicFormationsList();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 30,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PsychologistEditProfileScreen()),
                            );
                          },
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
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'lib/src/assets/images/logo.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Text(
                            user?.name ?? '--',
                            style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.home_outlined,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    user?.city ?? '--',
                                    style: const TextStyle(
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
                                    child: Text(
                                      user?.description ?? '--',
                                      style: const TextStyle(
                                          color: Colors.black87,
                                          decoration: TextDecoration.none,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )),
                          const Padding(padding: EdgeInsets.only(top: 10)),
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
                                  Text(
                                    user?.phone ?? '--',
                                    style: const TextStyle(
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Formação Acadêmica",
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AcademicFormationsCreateScreen()),
                                    );
                                  },
                                  icon: const Icon(Icons.add))
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          academicFormations == null
                              ? Container()
                              : SizedBox(
                                  height: 300,
                                  width: 350,
                                  child: ListView(
                                    children: academicFormations!
                                        .map(buildAcademicFormationWidget)
                                        .toList(),
                                  ))
                        ],
                      ),
                    ],
                  )
                ],
              ));
  }

  fetchUser() async {
    EasyLoading.show(status: 'Loading...');
    var fetchedUser = await userProfileService.fetchUserByUserId(idUserLogged);
    if (fetchedUser != null) {
      user = fetchedUser;
    } else {
      EasyLoading.showError('Failed to load data.');
    }
    setState(() {});
    EasyLoading.dismiss();
  }

  fetchAcademicFormationsList() async {
    EasyLoading.show(status: 'Buscando...');
    var fetchedAcademicFormations =
        await academicFormationsServiceService.fetchAcademicFormationsList();
    if (fetchedAcademicFormations.isNotEmpty) {
      academicFormations = fetchedAcademicFormations;
    } else {
      EasyLoading.showError('Failed to load data.');
    }
    setState(() {});
    EasyLoading.dismiss();
  }

  Card buildAcademicFormationWidget(AcademicFormation formation) {
    return Card(
      color: Colors.grey[200],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Universidade: ${formation.institution}",
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Curso: ${formation.course}",
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${formation.startDate.year} - ${formation.endDate.year}",
                    style: const TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AcademicFormationUpdateScreen(
                            formationId: formation.id.toString())),
                  );
                },
              ),
            ],
          )),
    );
  }
}
