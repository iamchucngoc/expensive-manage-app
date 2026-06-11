import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeInfo {
  final String name;
  final Color color;
  AppThemeInfo(this.name, this.color);
}

class ThemeProvider extends ChangeNotifier {
  static final List<AppThemeInfo> availableThemes = [
    AppThemeInfo('Dreamy Pink', const Color(0xFFFF6492)),
    AppThemeInfo('Ocean Blue', const Color(0xFF4A90E2)),
    AppThemeInfo('Mint Green', const Color(0xFF2ECC71)),
    AppThemeInfo('Sunset Orange', const Color(0xFFE67E22)),
    AppThemeInfo('Royal Purple', const Color(0xFF9B59B6)),
    AppThemeInfo('Slate Grey', const Color(0xFF7F8C8D)),
  ];

  late Color _primaryColor;
  Color get primaryColor => _primaryColor;

  // Nhận màu đã lưu từ hàm main() truyền vào
  ThemeProvider(Color initialColor) {
    _primaryColor = initialColor;
  }

  void updateColor(Color newColor) async {
    _primaryColor = newColor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('primary_color', newColor.value);
  }
}