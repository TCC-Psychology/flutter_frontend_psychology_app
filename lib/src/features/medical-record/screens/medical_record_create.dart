// ignore_for_file: use_build_context_synchronously

import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../main.dart';
import '../../../models/client_model.dart';
import '../../../models/medical_appointment_model.dart';
import '../../../models/medical_record_model.dart';
import '../../../models/psychologist_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/auth/auth_models.dart';
import '../../../shared/services/auth/auth_service.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/services/medical_appointment_service.dart';
import '../../../shared/services/medical_record_service.dart';
import '../../../shared/services/psychologist_service.dart';
import '../../../shared/services/user.service.dart';
import '../../../shared/style/input_decoration.dart';
import '../../../shared/utils/input_formatter_util.dart.dart';
import '../../../shared/validators/auth_validator.dart';
import 'medical_record_screen.dart';

class MedicalRecordCreateForm extends StatefulWidget {
  const MedicalRecordCreateForm({super.key});

  @override
  _MedicalRecordCreateFormState createState() =>
      _MedicalRecordCreateFormState();
}

class _MedicalRecordCreateFormState extends State<MedicalRecordCreateForm> {
  final MedicalAppointmentService medicalAppointmentService =
      MedicalAppointmentService();
  final MedicalRecordService medicalRecordService = MedicalRecordService();
  final PsychologistService psychologistService = PsychologistService();
  final ClientService clientService = ClientService();
  final UserProfileService userProfileService = UserProfileService();
  final AuthService authService = AuthService();

  var psychologistLogged = supabase.auth.currentUser!.id;

  final GlobalKey<State> _dialogKey = GlobalKey<State>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _datePickerController = TextEditingController();
  List<RelationshipStatus> relationshipStatusList = RelationshipStatus.values;
  List<MedicalAppointment> psychologistMedicalConsultation = [];
  List<UserProfile> users = [];
  String _selectedValueUserId = "";
  int selectedMood = 1;
  RelationshipStatus? _relationshipStatus;
  String notes = '';
  String theme = '';
  String objective = '';
  String evolutionRecord = '';
  DateTime? _birthDate;
  String _religion = '';
  String _fatherName = '';
  String _fatherOccupation = '';
  String _motherName = '';
  String _motherOccupation = '';
  String _name = '';
  String _cpf = '';
  String _phone = '';
  String _cep = '';
  String _city = '';
  String _state = '';
  String _gender = '';
  String _email = '';
  bool _showAdditionalUserFields = false;
  bool _showAdditionalClientFields = false;
  UserProfile? userTypeClientSearched;
  String cpfValue = '';
  bool _cpfAlreadyExists = false;
  bool _phoneAlreadyExists = false;
  bool _isNomeFilled = false;
  bool _isCpfFilled = false;
  bool _isPhoneFilled = false;
  bool _isEmailFilled = false;
  Psychologist? psychologist;
  MaskTextInputFormatter cpfMask = InputFormatterUtil.cpfMaskInputFormatter();
  @override
  void initState() {
    super.initState();

    loadPageUtilities();
  }

  Future<void> loadPageUtilities() async {
    try {
      EasyLoading.show(status: 'Carregando...');
      await fetchMedicalAppointments();
      await fetchUsersByClients();

      setState(() {});
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  fetchMedicalAppointments() async {
    psychologist =
        await psychologistService.fetchPsychologistByUserId(psychologistLogged);

    psychologistMedicalConsultation = await medicalAppointmentService
        .fetchMedicalAppointmentList(psychologist!.id!.toString(), 'null');
  }

  Future<void> fetchUsersByClients() async {
    users = [];
    for (MedicalAppointment medicalAppointment
        in psychologistMedicalConsultation) {
      var user = await userProfileService
          .fetchUserByClientId(medicalAppointment.clientId.toString());

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Criar Prontuário',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 24,
                      color: Colors.purple,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _showAddModal(context);
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.link),
                      onPressed: () {
                        _showLinkModal(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValueUserId = newValue!;
                    });
                  },
                  items: users.isEmpty
                      ? []
                      : users.map((user) {
                          return DropdownMenuItem<String>(
                            value: user.id,
                            child: Text(user.name),
                          );
                        }).toList(),
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Paciente",
                  ),
                  validator: (value) {
                    if (_selectedValueUserId == -1) {
                      return 'Por favor, selecione um paciente';
                    }
                    return null;
                  },
                  isExpanded: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Tema *",
                    prefixIcon: Icons.title,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tema';
                    }
                    return null;
                  },
                  onSaved: (value) => theme = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Objetivo *",
                    prefixIcon: Icons.folder_copy_sharp,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o objetivo';
                    }
                    return null;
                  },
                  onSaved: (value) => objective = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Evolução *",
                    prefixIcon: Icons.upcoming,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a evolução';
                    }
                    return null;
                  },
                  onSaved: (value) => evolutionRecord = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: ProjectInputDecorations.textFieldDecoration(
                    labelText: "Notas",
                    prefixIcon: Icons.notes,
                  ),
                  onSaved: (value) => notes = value!,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Center(
                    child: Text(
                      'Humor',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 1;
                        });
                      },
                      child: Icon(
                        selectedMood == 1
                            ? Icons.sentiment_very_dissatisfied
                            : Icons.sentiment_very_dissatisfied_outlined,
                        color: selectedMood == 1 ? Colors.red : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 2;
                        });
                      },
                      child: Icon(
                        selectedMood == 2
                            ? Icons.sentiment_dissatisfied
                            : Icons.sentiment_dissatisfied_outlined,
                        color: selectedMood == 2 ? Colors.orange : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 3;
                        });
                      },
                      child: Icon(
                        selectedMood == 3
                            ? Icons.sentiment_neutral
                            : Icons.sentiment_neutral_outlined,
                        color: selectedMood == 3 ? Colors.yellow : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 4;
                        });
                      },
                      child: Icon(
                        selectedMood == 4
                            ? Icons.sentiment_satisfied
                            : Icons.sentiment_satisfied_outlined,
                        color:
                            selectedMood == 4 ? Colors.lightGreen : Colors.grey,
                        size: 50,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = 5;
                        });
                      },
                      child: Icon(
                        selectedMood == 5
                            ? Icons.sentiment_very_satisfied
                            : Icons.sentiment_very_satisfied_outlined,
                        color: selectedMood == 5 ? Colors.green : Colors.grey,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      var client = await clientService
                          .fetchClientByUserId(_selectedValueUserId.toString());

                      MedicalRecord medicalRecord = MedicalRecord(
                          id: null,
                          notes: notes,
                          theme: theme,
                          mood: selectedMood.toString(),
                          objective: objective,
                          evolutionRecord: evolutionRecord,
                          psychologistId: psychologist!.id,
                          clientId: client?.id);

                      var id = await medicalRecordService
                          .createMedicalRecord(medicalRecord);

                      if (id == 1) {
                        EasyLoading.showSuccess('Prontuario criado',
                            duration: const Duration(seconds: 3));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MedicalRecordScreen()),
                        );
                      }
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              key: _dialogKey,
              title: const Text('Adicionar Cliente'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                          _isNomeFilled = value.isNotEmpty;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'CPF',
                        errorText:
                            _cpfAlreadyExists ? 'CPF já cadastrado' : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _cpf = value;
                          _isCpfFilled = value.isNotEmpty;
                          _cpfAlreadyExists = false;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Número de Celular',
                        errorText: _phoneAlreadyExists
                            ? 'Celular já cadastrado'
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _phone = value;
                          _isPhoneFilled = value.isNotEmpty;
                          _phoneAlreadyExists = false;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                          _isEmailFilled = value.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showAdditionalUserFields =
                              !_showAdditionalUserFields;
                        });
                      },
                      child: Text(_showAdditionalUserFields
                          ? 'Ocultar campos usuario adicionais'
                          : 'Mostrar campos usuario adicionais'),
                    ),
                    if (_showAdditionalUserFields)
                      _buildAdditionalFieldsUserForm(),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showAdditionalClientFields =
                              !_showAdditionalClientFields;
                        });
                      },
                      child: Text(_showAdditionalClientFields
                          ? 'Ocultar campos paciente adicionais'
                          : 'Mostrar campos paciente adicionais'),
                    ),
                    if (_showAdditionalClientFields)
                      _buildAdditionalFieldsClientForm(),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_areAllFieldsFilled()) {
                          var userCpf = await userProfileService
                              .fetchUserByProperties(_cpf, null, null);
                          var userPhone = await userProfileService
                              .fetchUserByProperties(null, _phone, null);

                          setState(() {
                            _cpfAlreadyExists = userCpf != null;
                            _phoneAlreadyExists = userPhone != null;
                          });

                          if (!_cpfAlreadyExists && !_phoneAlreadyExists) {
                            _saveClientData();
                          }
                        } else {
                          EasyLoading.showError(
                            'Por favor, preencha todos os campos obrigatórios.',
                          );
                        }
                      },
                      child: const Text('Salvar'),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLinkModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void resetUserTypeClientSearched() {
              setState(() {
                userTypeClientSearched = null;
              });
            }

            return WillPopScope(
              onWillPop: () async {
                resetUserTypeClientSearched();
                return true;
              },
              child: AlertDialog(
                key: _dialogKey,
                title: const Text('Relacionar Paciente'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        inputFormatters: [cpfMask],
                        decoration: ProjectInputDecorations.textFieldDecoration(
                          labelText: "CPF *",
                          prefixIcon: Icons.numbers,
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            cpfValue = newValue;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            userTypeClientSearched = null;
                          });
                          cpfValue = InputFormatterUtil.getUnmaskedCpfText(
                            cpfValue.trim(),
                          );
                          var user = await userProfileService
                              .fetchUserByProperties(cpfValue, null, null);
                          if (user.isDefinedAndNotNull) {
                            UserProfile? alreadyRelatedUser;
                            for (var u in users) {
                              if (u.id == user!.id!) {
                                alreadyRelatedUser = u;
                                break;
                              }
                            }
                            if (alreadyRelatedUser.isUndefinedOrNull) {
                              var client = await clientService
                                  .fetchClientByUserId(user!.id!.toString());
                              if (client.isDefinedAndNotNull) {
                                userTypeClientSearched = user;
                                setState(() {});
                              } else {
                                EasyLoading.showError(
                                  'O usuario deste cpf não é do tipo cliente!',
                                );
                              }
                            } else {
                              EasyLoading.showError(
                                'O paciente já está relacionado!',
                              );
                            }
                          } else {
                            EasyLoading.showError(
                              'Usuario não encontrado!',
                            );
                          }
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search),
                            SizedBox(width: 15),
                            Text('Pesquisar'),
                          ],
                        ),
                      ),
                      if (userTypeClientSearched != null) _showUserFetched(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAdditionalFieldsClientForm() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<RelationshipStatus>(
                value: _relationshipStatus,
                onChanged: (newValue) {
                  setState(() {
                    _relationshipStatus = newValue!;
                  });
                },
                decoration:
                    const InputDecoration(labelText: 'Tipo de relacionamento'),
                items: relationshipStatusList.map((status) {
                  return DropdownMenuItem<RelationshipStatus>(
                    value: status,
                    child: Text(status.toString().split('.').last),
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Religião'),
                onChanged: (value) {
                  setState(() {
                    _religion = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome do Pai'),
                onChanged: (value) {
                  setState(() {
                    _fatherName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ocupação do Pai'),
                onChanged: (value) {
                  setState(() {
                    _fatherOccupation = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome da Mãe'),
                onChanged: (value) {
                  setState(() {
                    _motherName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Ocupação da Mãe'),
                onChanged: (value) {
                  setState(() {
                    _motherOccupation = value;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdditionalFieldsUserForm() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _datePickerController,
                readOnly: true,
                decoration:
                    const InputDecoration(labelText: 'Data de nascimento'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthDate = pickedDate;
                      _datePickerController.text = _formatDate(
                          pickedDate); // Usa a função para formatar a data
                    });
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Gênero'),
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cep'),
                onChanged: (value) {
                  setState(() {
                    _cep = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cidade'),
                onChanged: (value) {
                  setState(() {
                    _city = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Estado'),
                onChanged: (value) {
                  setState(() {
                    _state = value;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _showUserFetched() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(width: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Nome'),
              const SizedBox(width: 10),
              Text(userTypeClientSearched!.name),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Telefone'),
              const SizedBox(width: 10),
              Text(userTypeClientSearched!.phone),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('CPF'),
              const SizedBox(width: 10),
              Text(userTypeClientSearched!.cpf),
            ],
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            onPressed: () async {
              var client = await clientService
                  .fetchClientByUserId(userTypeClientSearched!.id!.toString());

              MedicalAppointment medicalAppointment = MedicalAppointment(
                  date: DateTime.now(),
                  status: AppointmentStatus.confirmed,
                  appointmentType: AppointmentType.presencial,
                  clientId: client!.id!,
                  psychologistId: psychologist!.id);

              var id = await medicalAppointmentService
                  .createMedicalAppointment(medicalAppointment);

              if (id == 1) {
                Navigator.of(_dialogKey.currentContext!).pop();
                userTypeClientSearched = null;
                EasyLoading.showSuccess(
                  'Paciente relacionado!',
                );
              }

              loadPageUtilities();

              setState(() {});
            },
            child: const Text('Relacionar'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _saveClientData() async {
    SignUpData signUpData = SignUpData(
      email: _email,
      password: 'senha qualquer',
      cpf: _cpf,
      name: _name,
      phone: _phone,
      birthDate: _birthDate,
      userType: UserType.client,
      certificationNumber: '',
    );

    UserProfile user = UserProfile(
      name: _name,
      cpf: _cpf,
      birthDate: _birthDate,
      imageUrl: '',
      city: _city,
      state: _state,
      cep: _cep,
      phone: _phone,
      description: '',
      gender: _gender,
    );

    try {
      EasyLoading.show(status: 'Carregando...');
      String? userClientId = await authService.signUp(signUpData);
      if (userClientId != null) {
        EasyLoading.showSuccess(
          'Paciente cadastrado!',
        );
      } else {}
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }

    // Client client = Client(
    //   religion: _religion,
    //   relationshipStatus: _relationshipStatus,
    //   fatherName: _fatherName,
    //   fatherOccupation: _fatherOccupation,
    //   motherName: _motherName,
    //   motherOccupation: _motherOccupation,
    // );

    // var userCreated =
    //     await userProfileService.createUserAndClient(user, client);
    // var userId = userCreated!.id!.toString();

    // var clientCreated = await clientService.fetchClientByUserId(userId);

    // MedicalAppointment medicalAppointment = MedicalAppointment(
    //     date: DateTime.now(),
    //     status: AppointmentStatus.confirmed,
    //     appointmentType: AppointmentType.presencial,
    //     clientId: clientCreated!.id,
    //     psychologistId: psychologist!.id);

    // var id = await medicalAppointmentService
    //     .createMedicalAppointment(medicalAppointment);

    // if (id == 1) {
    //   EasyLoading.showSuccess(
    //     'Paciente cadastrado com sucesso',
    //   );
    //   Navigator.of(_dialogKey.currentContext!).pop();
    // }

    // loadPageUtilities();

    // setState(() {});
  }

  bool _areAllFieldsFilled() {
    return _isNomeFilled && _isCpfFilled && _isPhoneFilled && _isEmailFilled;
  }
}
