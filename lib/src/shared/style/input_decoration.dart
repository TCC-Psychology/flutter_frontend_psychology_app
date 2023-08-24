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
}
