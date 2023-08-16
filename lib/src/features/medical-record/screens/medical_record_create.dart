// ignore_for_file: use_build_context_synchronously

import 'dart:js_interop';

import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../models/client_model.dart';
import '../../../models/medical_appointment_model.dart';
import '../../../models/medical_record_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/services/client_service.dart';
import '../../../shared/services/medical_appointment_service.dart';
import '../../../shared/services/medical_record_service.dart';
import '../../../shared/services/psychologist_service.dart';
import '../../../shared/services/user.service.dart';
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

  //TODO - AUTENTICAÇÃO
  var psychologistLogged = '1';

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
  String _nome = '';
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
  bool _emailAlreadyExists = false;
  bool _isNomeFilled = false;
  bool _isCpfFilled = false;
  bool _isPhoneFilled = false;
  bool _isEmailFilled = false;

  @override
  void initState() {
    super.initState();

    loadPageUtilities();
  }

  Future<void> loadPageUtilities() async {
    await fetchMedicalAppointments();
    await fetchUsersByClients();

    setState(() {});
  }

  fetchMedicalAppointments() async {
    psychologistMedicalConsultation = await medicalAppointmentService
        .fetchMedicalAppointmentList(psychologistLogged, 'null');
  }

  Future<void> fetchUsersByClients() async {
    users = [];
    for (MedicalAppointment medicalAppointment
        in psychologistMedicalConsultation) {
      var user = await userProfileService
          .fetchUserByClientId(medicalAppointment.clientId.toString());

      if (user != null) {
        users.add(user);
      } else {
        print(
            "Fazer algo que mostre um erro e que é necessario reiniciar o app, pq seria impossivel nao ter user aqui");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Prontuario'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                  decoration:
                      const InputDecoration(labelText: 'Selecione um paciente'),
                  validator: (value) {
                    if (users.isEmpty) {
                      return 'Não há pacientes relacionados disponíveis.';
                    } else if (_selectedValueUserId == -1) {
                      return 'Por favor, selecione um paciente';
                    }
                    return null;
                  },
                  isExpanded: true,
                  onSaved: (value) => _selectedValueUserId = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tema'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tema';
                    }
                    return null;
                  },
                  onSaved: (value) => theme = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Objetivo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o objetivo';
                    }
                    return null;
                  },
                  onSaved: (value) => objective = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Evolução'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a evolução';
                    }
                    return null;
                  },
                  onSaved: (value) => evolutionRecord = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Notas'),
                  onSaved: (value) => notes = value!,
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Humor',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
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

                      //TODO - Deixar psicologo global após (autenticação)
                      var psychologist = await psychologistService
                          .fetchPsychologistById(psychologistLogged);
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

                      // ignore: use_build_context_synchronously
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MedicalRecordScreen()),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const HorizontalMenu(),
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
                          _nome = value;
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
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText:
                            _emailAlreadyExists ? 'Email já cadastrado' : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                          _isEmailFilled = value.isNotEmpty;
                          _emailAlreadyExists = false;
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
                          var userCpf = await userService.fetchUserByProperties(
                              _cpf, null, null);
                          var userPhone = await userService
                              .fetchUserByProperties(null, _phone, null);
                          var userEmail = await userService
                              .fetchUserByProperties(null, null, _email);

                          setState(() {
                            _cpfAlreadyExists = userCpf != null;
                            _phoneAlreadyExists = userPhone != null;
                            _emailAlreadyExists = userEmail != null;
                          });

                          if (!_cpfAlreadyExists &&
                              !_phoneAlreadyExists &&
                              !_emailAlreadyExists) {
                            _saveClientData();
                          }
                        } else {
                          showCustomAlertDialog(context,
                              'Por favor, preencha todos os campos obrigatórios (Nome, cpf, email e telefone).');
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
                        decoration: const InputDecoration(labelText: 'CPF'),
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
                          var user = await userService.fetchUserByProperties(
                              cpfValue, null, null);
                          if (user.isDefinedAndNotNull) {
                            User? alreadyRelatedUser;
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
                                showCustomAlertDialog(context,
                                    'O usuario deste cpf não é do tipo cliente!');
                              }
                            } else {
                              showCustomAlertDialog(
                                  context, 'O paciente já está relacionado!');
                            }
                          } else {
                            showCustomAlertDialog(
                                context, 'Usuario não encontrado!');
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
              const SizedBox(width: 10), // Espaço entre o título e o conteúdo
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
              var psychologist = await psychologistService
                  .fetchPsychologistById(psychologistLogged);
              var client = await clientService
                  .fetchClientByUserId(userTypeClientSearched!.id!.toString());

              MedicalAppointment medicalAppointment = MedicalAppointment(
                  date: DateTime.now(),
                  status: AppointmentStatus.confirmed,
                  appointmentType: AppointmentType.presencial,
                  clientId: client?.id!,
                  psychologistId: psychologist!.id);

              var id = await medicalAppointmentService
                  .createMedicalAppointment(medicalAppointment);

              if (id == 1) {
                Navigator.of(_dialogKey.currentContext!).pop();
                userTypeClientSearched = null;
                _showSuccessModal(context);
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
    UserProfile user = UserProfile(
      name: _nome,
      cpf: _cpf,
      birthDate: _birthDate,
      imageUrl: '',
      city: _city,
      state: _state,
      cep: _cep,
      phone: _phone,
      description: '',
      // email: _email,
      // password: 'password',
      gender: _gender,
    );

    Client client = Client(
      religion: _religion,
      relationshipStatus: _relationshipStatus,
      fatherName: _fatherName,
      fatherOccupation: _fatherOccupation,
      motherName: _motherName,
      motherOccupation: _motherOccupation,
    );

    var userCreated =
        await userProfileService.createUserAndClient(user, client);
    var userId = userCreated!.id!.toString();

    var clientCreated = await clientService.fetchClientByUserId(userId);
    var psychologist =
        await psychologistService.fetchPsychologistById(psychologistLogged);

    MedicalAppointment medicalAppointment = MedicalAppointment(
        date: DateTime.now(),
        status: AppointmentStatus.confirmed,
        appointmentType: AppointmentType.presencial,
        clientId: clientCreated!.id,
        psychologistId: psychologist!.id);

    var id = await medicalAppointmentService
        .createMedicalAppointment(medicalAppointment);

    if (id == 1) {
      Navigator.of(_dialogKey.currentContext!).pop();

      _showSuccessModal(context);
    }

    loadPageUtilities();

    setState(() {});
  }

  void _showSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });

        return const AlertDialog(
          title: Center(child: Text('Successo')),
          content: Center(child: Text('Paciente relacionado.')),
        );
      },
    );
  }

  bool _areAllFieldsFilled() {
    return _isNomeFilled && _isCpfFilled && _isPhoneFilled && _isEmailFilled;
  }

  void showCustomAlertDialog(BuildContext context, String contentText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aviso'),
        content: Text(contentText), // Usando a variável de texto recebida
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
