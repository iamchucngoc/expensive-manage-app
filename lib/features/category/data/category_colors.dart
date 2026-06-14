import 'package:flutter/material.dart';

const List<Color> categoryColors = [
  Color(0xffFF6B6B), Color(0xff4ECDC4), Color(0xff45B7D1), Color(0xff96CEB4),
  Color(0xffF7DC6F), Color(0xffD5DBDB), Color(0xff55EFC4), Color(0xff74B9FF),
  Color(0xffA29BFE), Color(0xffFD79A8), Color(0xffFDCB6E), Color(0xff6C5CE7),
  Color(0xffE17055), Color(0xff00B894), Color(0xff00CEC9), Color(0xff0984E3),
];

String colorToHex(Color color) => '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

Color hexToColor(String hex) => Color(int.parse(hex.replaceFirst('#', '0xFF')));