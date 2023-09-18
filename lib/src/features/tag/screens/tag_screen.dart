import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/main.dart';
import 'package:flutter_frontend_psychology_app/src/features/tag/services/tag_service.dart';
import 'package:flutter_frontend_psychology_app/src/models/segment_of_activity_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/target_audience_model.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({Key? key}) : super(key: key);

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  var currentUserId = supabase.auth.currentUser!.id;

  final TagService tagService = TagService();

  List<TargetAudience> targetAudienceList = [];
  List<SegmentOfActivity> segmentOfActivityList = [];

  final List<int?> selectedTargetAudienceIds = [];
  final List<int?> selectedSegmentOfActivityIds = [];

  @override
  void initState() {
    try {
      EasyLoading.show(status: 'Carregando...');
      super.initState();
      fetchTagList();
      fetchSelectedTags();
    } catch (e) {
      EasyLoading.showError(
        'Erro inesperado, verifique sua conexão com a internet',
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Público alvo",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      targetAudienceList.map((TargetAudience targetAudience) {
                    return FilterChip(
                      label: Text(targetAudience.title),
                      selected:
                          selectedTargetAudienceIds.contains(targetAudience.id),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedTargetAudienceIds.add(targetAudience.id);
                            tagService.connectTag(
                              EntityType.TargetAudience,
                              currentUserId,
                              targetAudience.id,
                            );
                          } else {
                            selectedTargetAudienceIds.remove(targetAudience.id);
                            tagService.disconnectTag(
                              EntityType.TargetAudience,
                              currentUserId,
                              targetAudience.id,
                            );
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Segmentos",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children:
                      segmentOfActivityList.map((SegmentOfActivity segment) {
                    return FilterChip(
                      label: Text(
                        style: const TextStyle(fontSize: 12),
                        segment.title,
                      ),
                      selected:
                          selectedSegmentOfActivityIds.contains(segment.id),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedSegmentOfActivityIds.add(segment.id);
                            tagService.connectTag(
                              EntityType.SegmentOfActivity,
                              currentUserId,
                              segment.id,
                            );
                          } else {
                            selectedSegmentOfActivityIds.remove(segment.id);
                            tagService.disconnectTag(
                              EntityType.SegmentOfActivity,
                              currentUserId,
                              segment.id,
                            );
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  fetchTagList() async {
    final targets = await tagService.fetchTargetAudiences();
    final segments = await tagService.fetchSegmentOfActivity();

    targetAudienceList.addAll(targets);
    segmentOfActivityList.addAll(segments);

    setState(() {});
  }

  Future<void> fetchSelectedTags() async {
    final List<TargetAudience> currentTargets =
        await tagService.fetchCurrentPsychologistTargetAudiences(currentUserId);
    final List<SegmentOfActivity> currentSegments =
        await tagService.fetchCurrentPsychologistSegments(currentUserId);

    List<int?> currentTargetIds =
        currentTargets.map((target) => target.id).toList();
    List<int?> currentSegmentIds =
        currentSegments.map((segment) => segment.id).toList();

    setState(() {
      selectedTargetAudienceIds.addAll(currentTargetIds);
      selectedSegmentOfActivityIds.addAll(currentSegmentIds);
    });
  }
}
