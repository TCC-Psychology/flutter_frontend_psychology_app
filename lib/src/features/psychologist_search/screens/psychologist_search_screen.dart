import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/constants/global_variables.dart';
import 'package:flutter_frontend_psychology_app/src/models/psychologist_model.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/psychologist_service.dart';

class PsychologistSearchScreen extends StatefulWidget {
  const PsychologistSearchScreen({Key? key}) : super(key: key);

  @override
  State<PsychologistSearchScreen> createState() =>
      _PsychologistSearchScreenState();
}

class _PsychologistSearchScreenState extends State<PsychologistSearchScreen> {
  final PsychologistService psychologistService = PsychologistService();
  List<Psychologist>? psychologists;

  @override
  void initState() {
    super.initState();
    fetchPsychologistList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: psychologists == null
          ? Container()
          : SafeArea(
              child: ListView.builder(
                itemCount: psychologists?.length,
                itemBuilder: (context, index) {
                  var psychologist = psychologists![index];
                  return SizedBox(
                    height: 80,
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      color: Colors.cyan.shade400,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(psychologist.certificationNumber.toString()),
                            Text(psychologist.userId.toString()),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  fetchPsychologistList() async {
    EasyLoading.show(status: 'Loading...');
    var fetchedPsychologists =
        await psychologistService.fetchPsychologistList();
    if (fetchedPsychologists.isNotEmpty) {
      psychologists = fetchedPsychologists;
    } else {
      EasyLoading.showError('Failed to load data.');
    }
    setState(() {});
    EasyLoading.dismiss();
  }
}
