import 'package:flutter/material.dart';

class ColorUtils {
  static List<Color> getSkyPaletteByTimeOfDay(DateTime now) {
    final hour = now.hour;
    if (hour >= 5 && hour < 8) {
      return [const Color(0xFFFFE4E1), const Color(0xFFA3C4DC)]; // Dawn
    } else if (hour >= 8 && hour < 16) {
      return [const Color(0xFFC8E6C9), const Color(0xFFA3C4DC)]; // Noon
    } else if (hour >= 16 && hour < 19) {
      return [const Color(0xFFFFB6C1), const Color(0xFFE6E6FA)]; // Evening
    } else {
      return [const Color(0xFF191970), const Color(0xFF483D8B)]; // Night
    }
  }
}
