import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/tag/services/tag_service.dart';
import 'package:flutter_frontend_psychology_app/src/models/segment_of_activity_model.dart';

class PsychologistFilterSegmentOfActivityDialog extends StatefulWidget {
  final List<SegmentOfActivity> segmentOfActivity;

  const PsychologistFilterSegmentOfActivityDialog(
      {Key? key, required this.segmentOfActivity})
      : super(key: key);

  @override
  State<PsychologistFilterSegmentOfActivityDialog> createState() =>
      _PsychologistFilterSegmentOfActivityDialogState();
}

class _PsychologistFilterSegmentOfActivityDialogState
    extends State<PsychologistFilterSegmentOfActivityDialog> {
  List<int> _selectedSegmentOfActivityIds = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Selecione os segmentos"),
      content: SingleChildScrollView(
        child: Column(
          children: widget.segmentOfActivity.map((segment) {
            return CheckboxListTile(
              title: Text(segment.title),
              value: _selectedSegmentOfActivityIds.contains(segment.id),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedSegmentOfActivityIds.add(segment.id!);
                  } else {
                    _selectedSegmentOfActivityIds.remove(segment.id);
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
          child: Text('Salvar'),
          onPressed: () {
            // Return the list of selected segment IDs
            Navigator.of(context).pop(_selectedSegmentOfActivityIds);
          },
        ),
      ],
    );
  }
}
