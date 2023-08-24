import 'package:flutter/material.dart';

String uri = 'http://localhost:3000';
//use http://10.0.2.2:3000 for android emulator
//use http://localhost:3000 for browser

Color text = _hexToColor('#040401');
Color background = _hexToColor('#f7f7e7');
Color primaryButton = _hexToColor('#b1b1e7');
Color secondaryButton = _hexToColor('#f1f1d0');
Color accent = _hexToColor('#b1b1e7');

// Color text = _hexToColor('#130c12');
// Color background = _hexToColor('#f7f2f6');
// Color primaryButton = _hexToColor('#482d43');
// Color secondaryButton = _hexToColor('#ffffff');
// Color accent = _hexToColor('#583752');

// --text: #101019;
// --background: #fcfcfd;
// --primary-button: #b2b285;
// --secondary-button: #ffffff;
// --accent: #b2b285;

Color _hexToColor(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
