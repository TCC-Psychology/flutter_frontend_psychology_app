import 'package:flutter/material.dart';

class ProjectInputDecorations {
  static InputDecoration textFieldDecoration(
      {String? labelText, IconData? prefixIcon}) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      // ... you can add more properties or customize further if needed
    );
  }

  static ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
