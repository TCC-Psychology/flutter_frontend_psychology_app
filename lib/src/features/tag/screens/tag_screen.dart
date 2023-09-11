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
    super.initState();
    fetchTagList();
    fetchSelectedTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Público alvo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Segmentos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                      style: TextStyle(fontSize: 12),
                      segment.title,
                    ),
                    selected: selectedSegmentOfActivityIds.contains(segment.id),
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
    );
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

  Future<void> fetchSelectedTags() async {
    EasyLoading.show(status: 'Carregando...');

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

    EasyLoading.dismiss();
  }
}
