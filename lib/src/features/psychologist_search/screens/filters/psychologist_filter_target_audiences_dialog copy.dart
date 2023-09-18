import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/tag/services/tag_service.dart';
import 'package:flutter_frontend_psychology_app/src/models/segment_of_activity_model.dart';
import 'package:flutter_frontend_psychology_app/src/models/target_audience_model.dart';

class PsychologistFilterTargetAudiencesDialog extends StatefulWidget {
  final List<TargetAudience> targetAudiences;

  const PsychologistFilterTargetAudiencesDialog(
      {Key? key, required this.targetAudiences})
      : super(key: key);

  @override
  State<PsychologistFilterTargetAudiencesDialog> createState() =>
      _PsychologistFilterTargetAudiencesDialogState();
}

class _PsychologistFilterTargetAudiencesDialogState
    extends State<PsychologistFilterTargetAudiencesDialog> {
  List<int> _selectedAudienceIds = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Selecione o público alvo"),
      content: SingleChildScrollView(
        child: Column(
          children: widget.targetAudiences.map((audience) {
            return CheckboxListTile(
              title: Text(audience.title),
              value: _selectedAudienceIds.contains(audience.id),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedAudienceIds.add(audience.id!);
                  } else {
                    _selectedAudienceIds.remove(audience.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Selecionar'),
          onPressed: () {
            // Return the list of selected audience IDs
            Navigator.of(context).pop(_selectedAudienceIds);
          },
        ),
      ],
    );
  }
}
