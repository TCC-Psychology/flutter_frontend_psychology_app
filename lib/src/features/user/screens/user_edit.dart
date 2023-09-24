import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/user/screens/avatar.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/user.service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../main.dart';
import '../../../models/client_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/style/input_decoration.dart';
import '../../../shared/utils/input_formatter_util.dart.dart';
import '../../academic_formation/screens/academic_formation_screen.dart';
import '../../medical-appointment/screens/medical_appointment_psychologist.dart';
import '../../psychologist_search/screens/psychologist_search_screen.dart';

class UserProfileEdit extends StatefulWidget {
  const UserProfileEdit({super.key});

  @override
  _UserProfileEditState createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit> {
  UserProfileService userProfileService = UserProfileService();
  ClientService clientService = ClientService();
  PsychologistService psychologistService = PsychologistService();
  UserProfile? userProfile;
  Client? client;
  Psychologist? psychologist;
  var userLoggedId = supabase.auth.currentUser!.id;

  String? _imageUrl;
  String latitude = '';
  String longitude = '';
  List<RelationshipStatus> relationshipStatusList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherOccupationController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController motherOccupationController = TextEditingController();
  TextEditingController certificationNumberController = TextEditingController();
  RelationshipStatus? relationshipStatusController;

  @override
  void initState() {
    super.initState();
    loadUtilites();
  }

  loadUtilites() async {
    try {
      EasyLoading.show(status: 'Carregando...');

      await fetchUser();
      relationshipStatusList = RelationshipStatus.values;
      nameController.text = userProfile!.name;
      cpfController.text = InputFormatterUtil.formatCPF(userProfile!.cpf);
      phoneController.text =
          InputFormatterUtil.formatPhoneNumber(userProfile!.phone);
      cityController.text = userProfile!.city ?? '';
      stateController.text = userProfile!.state ?? '';
      cepController.text = userProfile!.cep != null && userProfile!.cep != ''
          ? InputFormatterUtil.formatCEP(userProfile!.cep!)
          : '';
      descriptionController.text = userProfile!.description ?? '';
      genderController.text = userProfile!.gender ?? '';

      if (client != null) {
        popularClient();
      } else {
        certificationNumberController.text =
            psychologist!.certificationNumber ?? '';
      }

      setState(() {});
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  fetchUser() async {
    userProfile = await userProfileService.fetchUserByUserId(userLoggedId);
    client = await clientService.fetchClientByUserId(userLoggedId);
    if (client == null) {
      psychologist =
          await psychologistService.fetchPsychologistByUserId(userLoggedId);
    }
  }

  popularClient() {
    religionController.text = client!.religion ?? '';
    relationshipStatusController = client!.relationshipStatus;
    fatherNameController.text = client!.fatherName ?? '';
    fatherOccupationController.text = client!.fatherOccupation ?? '';
    motherNameController.text = client!.motherName ?? '';
    motherOccupationController.text = client!.motherOccupation ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Meus dados",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            if (psychologist != null)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const AcademicFormationScreen()),
                    );
                  },
                  child: const Icon(
                    Icons.book,
                    color: Colors.purple,
                    size: 32,
                  ),
                ),
              ),
            const SizedBox(height: 15),
            Avatar(
                imageUrl: _imageUrl,
                onUpload: (imageUrl) {
                  setState(() {
                    _imageUrl = imageUrl;
                  });
                }),
            const SizedBox(height: 15),
            TextFormField(
              controller: nameController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Name *',
                prefixIcon: Icons.person,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: cpfController,
              inputFormatters: [InputFormatterUtil.cpfMaskInputFormatter()],
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'CPF *',
                prefixIcon: Icons.credit_card,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.phone,
              inputFormatters: [InputFormatterUtil.phoneMaskInputFormatter()],
              controller: phoneController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Phone *',
                prefixIcon: Icons.phone,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: birthDateController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: "Data de nascimento",
                prefixIcon: Icons.date_range,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    birthDateController.text = formattedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: cityController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'City',
                prefixIcon: Icons.location_city,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: stateController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'State',
                prefixIcon: Icons.location_on,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: cepController,
              inputFormatters: [InputFormatterUtil.cepMaskInputFormatter()],
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'CEP',
                prefixIcon: Icons.location_searching,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: descriptionController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Description',
                prefixIcon: Icons.description,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: genderController,
              decoration: ProjectInputDecorations.textFieldDecoration(
                labelText: 'Gender',
                prefixIcon: Icons.person_outline,
              ),
            ),
            if (client != null) formClient(),
            if (psychologist != null) formPsychologist(),
            if (userProfile?.userType == UserType.PSYCHOLOGIST)
              const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                handleGetLocation();
              },
              child: const Text('Buscar localização'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                handleUserEdit();
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget formClient() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 15),
        TextFormField(
          controller: religionController,
          decoration: ProjectInputDecorations.textFieldDecoration(
            labelText: 'Religion',
            prefixIcon: Icons.accessibility_new,
          ),
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<RelationshipStatus>(
          value: relationshipStatusController,
          onChanged: (newValue) {
            setState(() {
              relationshipStatusController = newValue!;
            });
          },
          decoration: ProjectInputDecorations.textFieldDecoration(
            labelText: "Tipo de relacionamento",
          ),
          items: relationshipStatusList.map((status) {
            return DropdownMenuItem<RelationshipStatus>(
              value: status,
              child: Text(status.toString().split('.').last),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: fatherNameController,
          decoration: ProjectInputDecorations.textFieldDecoration(
            labelText: "Father's Name",
            prefixIcon: Icons.person_outline,
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: fatherOccupationController,
          decoration: ProjectInputDecorations.textFieldDecoration(
            labelText: "Father's Occupation",
            prefixIcon: Icons.work,
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: motherNameController,
          decoration: ProjectInputDecorations.textFieldDecoration(
            labelText: "Mother's Name",
            prefixIcon: Icons.person_outline,
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: motherOccupationController,
          decoration: ProjectInputDecorations.textFieldDecoration(
            labelText: "Ocupação mãe",
            prefixIcon: Icons.work,
          ),
        ),
      ],
    );
  }

  Widget formPsychologist() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 15),
        TextFormField(
          controller: certificationNumberController,
          decoration: ProjectInputDecorations.textFieldDecoration(
            labelText: 'Certificado',
            prefixIcon: Icons.accessibility_new,
          ),
        ),
      ],
    );
  }

  void handleUserEdit() async {
    try {
      EasyLoading.show(status: 'Editando...');

      String name = nameController.text.trim();
      String cpf = InputFormatterUtil.getUnmaskedCpfText(
        cpfController.text.trim(),
      );
      String phone = InputFormatterUtil.getUnmaskedPhoneText(
        phoneController.text.trim(),
      );
      String birthDate = birthDateController.text.trim();
      String city = cityController.text.trim();
      String state = stateController.text.trim();
      String cep = InputFormatterUtil.getUnmaskedCep(
        cepController.text.trim(),
      );
      String description = descriptionController.text.trim();
      String gender = genderController.text.trim();

      UserProfile userProfileEdited = UserProfile(
        name: name,
        cpf: cpf,
        phone: phone,
        birthDate: DateTime.tryParse(birthDate)?.toUtc(),
        city: city,
        state: state,
        cep: cep,
        description: description,
        gender: gender,
        userType: userProfile!.userType,
        latitude: latitude,
        longitude: longitude,
      );

      await userProfileService.editUser(userProfileEdited, userProfile!.id!);

      if (client != null) {
        handleEditClient();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PsychologistSearchScreen()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MedicalAppointmentPsychologistScreen()),
        );
        handleEditPsychologist();
      }
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> handleEditClient() async {
    String religion = religionController.text.trim();
    RelationshipStatus? relationshipStatus = relationshipStatusController;
    String fatherName = fatherNameController.text.trim();
    String fatherOccupation = fatherOccupationController.text.trim();
    String motherName = motherNameController.text.trim();
    String motherOccupation = motherOccupationController.text.trim();

    Client clientEdit = Client(
      religion: religion,
      relationshipStatus: relationshipStatus,
      fatherName: fatherName,
      fatherOccupation: fatherOccupation,
      motherName: motherName,
      motherOccupation: motherOccupation,
    );
    await clientService.editClient(clientEdit, client!.id!);
  }

  Future<void> handleEditPsychologist() async {
    String certificationNumber = certificationNumberController.text.trim();

    Psychologist psychologistEdit =
        Psychologist(certificationNumber: certificationNumber);
    await psychologistService.editPsychologist(
        psychologistEdit, psychologist!.id!);
  }

  Future<void> handleGetLocation() async {
    try {
      await Permission.location.request();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique suas permissões de localização',
      );
    }
  }
}
