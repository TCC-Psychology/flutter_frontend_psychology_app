import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../models/medical_appointment_model.dart';
import '../../models/medical_record_model.dart';
import '../../models/user_model.dart';
import '../../shared/services/medical_appointment_service.dart';
import '../../shared/services/medical_record_service.dart';
import '../../shared/services/psychologist_service.dart';
import '../../shared/services/user.service.dart';

class MedicalRecordCreateForm extends StatefulWidget {
  const MedicalRecordCreateForm({super.key});

  @override
  _MedicalRecordCreateFormState createState() => _MedicalRecordCreateFormState();
}

class _MedicalRecordCreateFormState extends State<MedicalRecordCreateForm> {
  final PsychologistService psychologistService = PsychologistService();
  final MedicalAppointmentService medicalAppointmentService = MedicalAppointmentService();
  final UserService userService = UserService();
  final MedicalRecordService medicalRecordService = MedicalRecordService();
  
  //TODO - AUTENTICAÇÃO
  var psychologistLogged = '1';

  //Using un creatMedicalRecord
  List<MedicalAppointment> psychologistMedicalConsultation = [];
  List<Client> clients = [];
  List<User> users = [];
  int _selectedValueClient = -1;
  final _formKey = GlobalKey<FormState>();
  String notes = '';
  String theme = '';
  String mood = '';
  String objective = '';
  String evolutionRecord = '';

  //Using in creatClientForPsychologist
  List<RelationshipStatus> relationshipStatusList = [];
  bool _showAdditionalClientFields = false;
  String _religion = '';
  RelationshipStatus? _relationshipStatus;
  String _fatherName = '';
  String _fatherOccupation = '';
  String _motherName = '';
  String _motherOccupation = '';
  final TextEditingController _datePickerController = TextEditingController();
  DateTime? _birthDate ;

  //Using in creatUserForPsycholigist
  bool _showAdditionalUserFields = false;
  String _nome = '';
  String _cpf = '';
  String _phone = '';
  String _cep = '';
  String _city = '';
  String _state = '';
  String _gender = '';
  String _email = '';

 @override
  void initState() {    
    super.initState();

    loadMedicalAppointments();
  }

  Future<void> loadMedicalAppointments() async {
      await fetchMedicalAppointments();
      await fetchClientsFromMedicalAppointments();
      await fetchUsersForClients();

      setState(() {});
  }

  Future<void> fetchClientsFromMedicalAppointments() async {
    for (MedicalAppointment consultation in psychologistMedicalConsultation) {
      clients.add(consultation.client);
    }
  }

  Future<void> fetchUsersForClients() async {
    for (Client client in clients) {
      var user = await userService.fetchUser(client.userId.toString());
      if (user != null) {
        users.add(user);
      } else {
        print("Não tem possibilidade, se não é erro de BD");
      }
    }

    relationshipStatusList = RelationshipStatus.values;
    print(relationshipStatusList);
  }

  fetchMedicalAppointments() async {
    var fetchedmedicalAppointments =
        await medicalAppointmentService.fetchMedicalAppointmentList(psychologistLogged, 'null');
    
    psychologistMedicalConsultation = fetchedmedicalAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Medical Record'),
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
                DropdownButtonFormField<int>(
                  onChanged: (newValue) {
                    setState(() {
                      _selectedValueClient = newValue!;
                    });
                  },
                  items: clients.isEmpty
                      ? []
                      : clients.map((client) {
                          return DropdownMenuItem<int>(
                            value: users.firstWhere((user) => user.id == client.userId).id,
                            child: Text(users.firstWhere((user) => user.id == client.userId).name),
                          );
                        }).toList(),
                  decoration: const InputDecoration(labelText: 'Selecione um paciente'),
                  validator: (value) {
                    if (clients.isEmpty) {
                      return 'Não há clientes relacionados disponíveis.';
                    } else if (value == -1) {
                      return 'Por favor, selecione um paciente';
                    }
                    return null;
                  },
                  onSaved: (value) => _selectedValueClient = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Notas'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira as notas';
                    }
                    return null;
                  },
                  onSaved: (value) => notes = value!,
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
                  decoration: const InputDecoration(labelText: 'Humor'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o humor';
                    }
                    return null;
                  },
                  onSaved: (value) => mood = value!,
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
                  decoration: const InputDecoration(labelText: 'Registro de evolução'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o registro de evolução';
                    }
                    return null;
                  },
                  onSaved: (value) => evolutionRecord = value!,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      var psychologist = await psychologistService.fetchPsychologistById(psychologistLogged);

                      MedicalRecord medicalRecord = MedicalRecord(
                        createdAt: DateTime.now(), // Substitua pela data correta
                        updatedAt: DateTime.now(), // Substitua pela data correta
                        notes: notes,
                        theme: theme,
                        mood: mood,
                        objective: objective,
                        evolutionRecord: evolutionRecord,
                        psychologist: psychologist,
                        client: clients.firstWhere((client) => client.userId == _selectedValueClient)
                      );
                      var id = await medicalRecordService.createMedicalRecord(medicalRecord);
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
              title: const Text('Adicionar Cliente'),
              content: SingleChildScrollView( // Adicionando SingleChildScrollView
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      onChanged: (value) {
                        setState(() {
                          _nome = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'CPF'),
                      onChanged: (value) {
                        setState(() {
                          _cpf = value;
                        });
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Número Celular'),
                      onChanged: (value) {
                        setState(() {
                          _phone = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showAdditionalUserFields = !_showAdditionalUserFields;
                        });
                      },
                      child: Text(_showAdditionalUserFields
                          ? 'Ocultar campos usuario adicionais'
                          : 'Mostrar campos usuario adicionais'),
                    ),
                    if (_showAdditionalUserFields) _buildAdditionalFieldsUserForm(),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showAdditionalClientFields = !_showAdditionalClientFields;
                        });
                      },
                      child: Text(_showAdditionalClientFields
                          ? 'Ocultar campos paciente adicionais'
                          : 'Mostrar campos paciente adicionais'),
                    ),
                    if (_showAdditionalClientFields) _buildAdditionalFieldsClientForm(),
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () {
                        _saveClientData();
                      },
                      child: const Text('Salvar'),
                    ),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Relacionar pessoa cadastrada a você.'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'CPF'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para pesquisar o CPF
                  Navigator.of(context).pop();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Text('Pesquisar'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //TODO - Depois retirar esse SingleChildScrollView PARA VER SE DA ERRO
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
              decoration: const InputDecoration(labelText: 'Tipo de relacionamento'),
              items: relationshipStatusList.map((status) {
                return DropdownMenuItem<RelationshipStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
            ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Status do relacionamento'),
                onChanged: (value) {
                  setState(() {
                    _relationshipStatus = value as RelationshipStatus?;
                  });
                },
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
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
                decoration: const InputDecoration(labelText: 'Data de nascimento'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _birthDate  ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthDate  = pickedDate;
                      _datePickerController.text = _formatDate(pickedDate); // Usa a função para formatar a data
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveClientData() async {
    UserCreate userCreate = UserCreate(
      name: _nome,
      cpf: _cpf,
      birthDate: _birthDate,
      imageUrl: null,
      city: _city,
      state: _state,
      cep: _cep,
      phone: _phone,
      description: null,
      email: _email,
      //Essa senha nao pode ser preenchida pelo psicologo, ter que ser qualquer uma e dps dar a permissao pro user alterar
      password: 'SenhaQualquer',
      gender: _gender,
    );

    ClientCreate clientCreate = ClientCreate(
      religion: _religion,
      relationshipStatus: _relationshipStatus,
      fatherName: _fatherName,
      fatherOccupation: _fatherOccupation,
      motherName: _motherName,
      motherOccupation: _motherOccupation,
    );

    //TODO - Mostrar uma mensagem por user se o id é de sucesso dizendo que foi cadastrado.
    var id = await userService.createUserAndClient(userCreate, clientCreate);

  }
}
