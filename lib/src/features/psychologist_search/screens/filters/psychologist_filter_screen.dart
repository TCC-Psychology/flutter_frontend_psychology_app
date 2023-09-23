import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_search/screens/filters/psychologist_filter_segment_of_activity_dialog.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_search/screens/filters/psychologist_filter_target_audiences_dialog%20copy.dart';
import 'package:flutter_frontend_psychology_app/src/features/tag/services/tag_service.dart';
import 'package:flutter_frontend_psychology_app/src/models/segment_of_activity_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/target_audience_model.dart';

class PsychologistFilterScreen extends StatefulWidget {
  @override
  _PsychologistFilterScreenState createState() =>
      _PsychologistFilterScreenState();
}

class _PsychologistFilterScreenState extends State<PsychologistFilterScreen> {
  final TagService tagService = TagService();

  List<TargetAudience> targetAudienceList = [];
  List<SegmentOfActivity> segmentOfActivityList = [];

  List<int> selectedSegmentIds = [];
  List<int> selectedTargetAudienceIds = [];

  String selectedTargetAudienceNames = '';
  String selectedSegmentNames = '';

  void _onApplyButtonPressed() {
    Navigator.pop(context, {
      'selectedSegmentIds': selectedSegmentIds,
      'selectedTargetAudienceIds': selectedTargetAudienceIds
    });
  }

  void _openPsychologistFilterTargetAudiencesDialog(
      BuildContext context) async {
    selectedTargetAudienceIds = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PsychologistFilterTargetAudiencesDialog(
          targetAudiences: targetAudienceList,
        );
      },
    );

    if (selectedTargetAudienceIds != null) {
      final selectedNames = selectedTargetAudienceIds!
          .map(
            (id) => targetAudienceList
                .firstWhere((element) => element.id == id)
                .title,
          )
          .join(', ');
      setState(() {
        selectedTargetAudienceNames = selectedNames;
      });

      print(selectedTargetAudienceIds);
    }
  }

  void _openPsychologistFilterSegmentOfActivityDialog(
      BuildContext context) async {
    selectedSegmentIds = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PsychologistFilterSegmentOfActivityDialog(
          segmentOfActivity: segmentOfActivityList,
        );
      },
    );
    final selectedNames = selectedSegmentIds
        .map(
          (id) => segmentOfActivityList
              .firstWhere((element) => element.id == id)
              .title,
        )
        .join(', ');
    setState(() {
      selectedSegmentNames = selectedNames;
    });
    print(selectedSegmentIds);
  }

  fetchTagList() async {
    EasyLoading.show(status: 'Carregando...');

    final targets = await tagService.fetchTargetAudiences();
    final segments = await tagService.fetchSegmentOfActivity();

    targetAudienceList.addAll(targets);
    segmentOfActivityList.addAll(segments);

    setState(() {});

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    fetchTagList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () =>
                      _openPsychologistFilterTargetAudiencesDialog(context),
                  child: const Text("Público alvo"),
                ),
              ),
              if (selectedTargetAudienceNames.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(selectedTargetAudienceNames),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () =>
                      _openPsychologistFilterSegmentOfActivityDialog(context),
                  child: Text("Segmento"),
                ),
              ),
              if (selectedSegmentNames.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(selectedSegmentNames),
                ),
              ],
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: Text("Cancelar")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: _onApplyButtonPressed, child: Text("Aplicar")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
