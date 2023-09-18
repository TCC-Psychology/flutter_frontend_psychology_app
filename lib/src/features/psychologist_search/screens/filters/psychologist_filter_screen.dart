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

  List<int>? selectedSegmentIds = [];
  List<int>? selectedTargetAudienceIds = [];

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
    if (selectedSegmentIds != null) {
      print(selectedSegmentIds);
    }
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
        title: Text('Filtros'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () =>
                _openPsychologistFilterTargetAudiencesDialog(context),
            child: Text("Público alvo"),
          ),
          ElevatedButton(
            onPressed: () =>
                _openPsychologistFilterSegmentOfActivityDialog(context),
            child: Text("Segmento"),
          ),
        ],
      ),
    );
  }
}
