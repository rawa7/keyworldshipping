import 'package:flutter/material.dart';

class AppColors {
  // Primary blue color as requested
  static const Color primaryBlue = Color(0xFF28608B);
  
  // Additional shades for consistency
  static const Color primaryBlueLight = Color(0xFF3A7BA8);
  static const Color primaryBlueDark = Color(0xFF1E4A6F);
  
  // Helper method to get shade variations
  static Color primaryBlueShade(int shade) {
    switch (shade) {
      case 50:
        return const Color(0xFFE8F0F7);
      case 100:
        return const Color(0xFFBDD6EA);
      case 200:
        return const Color(0xFF92BBDC);
      case 300:
        return const Color(0xFF67A0CE);
      case 400:
        return const Color(0xFF4A8BC4);
      case 500:
        return primaryBlue; // 0xFF28608B
      case 600:
        return const Color(0xFF235580);
      case 700:
        return const Color(0xFF1E4A6F);
      case 800:
        return const Color(0xFF193F5E);
      case 900:
        return const Color(0xFF14344D);
      default:
        return primaryBlue;
    }
  }
  
  // Helper method for opacity variations
  static Color primaryBlueWithOpacity(double opacity) {
    return primaryBlue.withOpacity(opacity);
  }
} 