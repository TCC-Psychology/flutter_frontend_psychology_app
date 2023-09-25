import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_search/screens/filters/psychologist_filter_screen.dart';

import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/academic_formation_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_frontend_psychology_app/src/shared/style/input_decoration.dart';

import '../../../../main.dart';
import '../../../models/academic_formation_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/services/user.service.dart';
import '../../../shared/utils/input_formatter_util.dart.dart';
import '../../medical-appointment/screens/medical_appointment_create.dart';

class PsychologistSearchScreen extends StatefulWidget {
  const PsychologistSearchScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistSearchScreen> createState() =>
      _PsychologistSearchScreenState();
}

class _PsychologistSearchScreenState extends State<PsychologistSearchScreen> {
  String? _imageUrl;
  final ClientService clientService = ClientService();
  final PsychologistService psychologistService = PsychologistService();
  final UserProfileService userProfileService = UserProfileService();
  final AcademicFormationService academicFormationService =
      AcademicFormationService();

  List<int>? selectedSegmentIds = [];
  List<int>? selectedTargetAudienceIds = [];

  List<Psychologist> psychologists = [];
  List<Psychologist> filteredPsychologists = [];

  List<UserProfile> users = [];
  //I was using this academic information to test, then I created a fictitious data, when Fabio comes up I fix it
  List<AcademicFormation> academicFormations = [];

  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    loadPageUtilities();
  }

  loadPageUtilities() async {
    try {
      EasyLoading.show(status: 'Procurando...');
      await fetchPsychologistList();
      // await fetchUsersByPsychologist();

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
    psychologists = await psychologistService.fetchPsychologistList(
      selectedSegmentIds,
      selectedTargetAudienceIds,
    );
    filteredPsychologists = psychologists;
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

  void _openFilters() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PsychologistFilterScreen()),
    );
    if (result != null) {
      selectedSegmentIds = result['selectedSegmentIds'];
      selectedTargetAudienceIds = result['selectedTargetAudienceIds'];
      loadPageUtilities();
    }
  }

  void _startSearch(String query) {
    setState(() {
      query = query.toLowerCase().trim();

      if (query.isEmpty) {
        filteredPsychologists = psychologists;
      } else {
        filteredPsychologists = psychologists.where((psychologist) {
          final user = psychologist.user;
          if (user != null) {
            if (user.city != null) {
              final userCity = user.city!.toLowerCase();
              return userCity.contains(query);
            }
          }
          return false;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: Form(
                          key: _key,
                          child: TextFormField(
                            controller: _searchController,
                            decoration:
                                ProjectInputDecorations.textFieldDecoration(
                              labelText: "Pesquise por Cidade",
                              prefixIcon: Icons.search,
                            ),
                            onChanged: (String text) {
                              if (!_key.currentState!.validate()) {
                                return;
                              }
                              _startSearch(text);
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0), // Some padding for better alignment
                      child: ElevatedButton(
                        style: ProjectInputDecorations.buttonStyle(),
                        onPressed: _openFilters,
                        child: const Icon(Icons.filter_alt),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "Listagem de psicologos",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (filteredPsychologists.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredPsychologists.length,
                    itemBuilder: (context, index) {
                      Psychologist psychologist = filteredPsychologists[index];
                      UserProfile user = psychologist.user!;
                      String userId = user.id!;

                      final imagePath = '/$userId/profile';
                      String imageUrl = supabase.storage
                          .from('profiles')
                          .getPublicUrl(imagePath);

                      _imageUrl = Uri.parse(imageUrl).replace(queryParameters: {
                        't': DateTime.now().millisecondsSinceEpoch.toString()
                      }).toString();

                      return GestureDetector(
                        onTap: () {
                          _openPsychologistModal(
                              context, psychologist, user.imageUrl);
                        },
                        child: Card(
                          margin: const EdgeInsets.all(16.0),
                          child: ListTile(
                            leading: SizedBox(
                              // ignore: unnecessary_null_comparison
                              child: user.imageUrl != null
                                  ? Image.network(
                                      _imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.account_circle,
                                      size: 48.0,
                                    ),
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
                                Text(
                                    '${user.city ?? "N/A cidade"}, ${user.state ?? "N/A estado"}'),
                                Text(InputFormatterUtil.formatPhoneNumber(
                                    user.phone)),
                                Text(
                                    'Certificate Number: ${psychologist.certificationNumber ?? ""}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openPsychologistModal(BuildContext context,
      Psychologist psychologist, String? imageUrlView) async {
    var user = await userProfileService
        .fetchUserByPsychologistId(psychologist.id.toString());
    academicFormations = await academicFormationService
        .fetchAcademicFormationsList(psychologist.id!.toString());
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
                  Tab(icon: Icon(Icons.tag), text: 'Formações'),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
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
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          // ignore: unnecessary_null_comparison
                          child: user!.imageUrl != null
                              ? Image.network(
                                  imageUrlView!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.account_circle,
                                  size: 150,
                                ),
                        ),
                        const Text(
                          'Nome',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Número de Certificação',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          psychologist.certificationNumber ?? "N/A",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'CPF:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          user.cpf,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CEP',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          user.cep ?? "N/A",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Cidade',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          user.city ?? "N/A",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Estado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          user.state ?? "N/A",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        if (user.latitude != null && user.longitude != null)
                          ElevatedButton(
                            onPressed: () {
                              openGoogleMaps(
                                user.latitude!,
                                user.longitude!,
                              );
                            },
                            child: const Text(
                              'Obter Rota',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: academicFormations.map((formation) {
                      return Center(
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Instituição:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  Text(
                                    formation.institution,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Curso:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  Text(
                                    formation.course,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Descrição:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  Text(
                                    formation.description!,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Período:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  Text(
                                    '${formation.startDate.year} - ${formation.endDate.year}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void openGoogleMaps(String latitude, String longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final uri = Uri.parse(url);

    await launchUrl(uri).catchError((e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    });
  }
}
