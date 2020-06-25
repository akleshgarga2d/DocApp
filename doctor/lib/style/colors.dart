import 'dart:ui';
import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFF4e4e4e);
  static const Color loginGradientEnd = const Color(0xFF1a1a1a);
  static const Color primaryColor = const Color(0xff57679B);
  static const Color primaryDark = const Color(0xff2196F3);
  static const Color white = const Color(0xFFffffff);
  static const Color cardColor = const Color(0xFF34435e);
  static const Color buttonColor = const Color(0xFF34435e);
  static const Color textSecondary = const Color(0xFFECEFF1);
  static const Color buttonText = const Color(0xFFFFFFFF);
  static const Color bottomselected = const Color(0xFFECEFF1);
  static const Color bottomunselected = const Color(0xFFFFFFFF);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}