import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/triage_service.dart';

import '../../models/triage_model.dart';
import '../medical-appointment/screens/medical_appointment_client.dart';

class TriageScreen extends StatefulWidget {
  final String medicalAppointmentId;

  const TriageScreen({Key? key, required this.medicalAppointmentId})
      : super(key: key);

  @override
  _TriageScreenState createState() => _TriageScreenState();
}

class _TriageScreenState extends State<TriageScreen> {
  TriageService triageService = TriageService();
  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();
  int currentQuestionIndex = 0;
  bool isWaiting = false; // Track if waiting for 2 seconds

  String? chiefComplaint;
  String? triggeringFacts;
  List<String> currentSymptoms = [];

  final List<String> questions = [
    "Olá, eu sou o PSICOLOGUINHO, e vou ajudar você a fazer a triagem para a consulta. \nPrimeiramente, qual é o motivo principal pela qual procura o atendimento?",
    "E o que desencadeou esses acontecimentos?",
    "Por favor, liste os seus sintomas. Digite '.' quando terminar."
  ];

  @override
  void initState() {
    super.initState();
    addMessage(
        ChatMessage(text: questions[currentQuestionIndex], isUser: false));
    currentQuestionIndex++;
  }

  void addMessage(ChatMessage message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  Future<void> processUserMessage(String messageText) async {
    if (isWaiting) return;

    if (chiefComplaint == null) {
      chiefComplaint = messageText;
    } else if (triggeringFacts == null) {
      triggeringFacts = messageText;
    } else if (messageText == '.') {
      await registrationTriage();
      setState(() {
        isWaiting = false;
      });
      return;
    } else {
      currentSymptoms.add(messageText);
    }

    addMessage(ChatMessage(text: messageText, isUser: true));
    messageController.clear();

    if (currentQuestionIndex < questions.length) {
      setState(() {
        isWaiting = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          addMessage(ChatMessage(
              text: questions[currentQuestionIndex], isUser: false));
          currentQuestionIndex++;
          isWaiting = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Triagem Guiada')),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    enabled: !isWaiting,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: (messageController.text.isEmpty || isWaiting)
                      ? null
                      : () {
                          processUserMessage(messageController.text);
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> registrationTriage() async {
    try {
      EasyLoading.show(status: 'Montando triagem');

      Triage triage = Triage(
        chiefComplaint: chiefComplaint!,
        triggeringFacts: triggeringFacts!,
        medicalAppointmentId: widget.medicalAppointmentId,
        currentSymptoms: currentSymptoms.join(", "),
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await triageService.createTriage(triage, widget.medicalAppointmentId);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MedicalAppointmentClientScreen()),
      );
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}