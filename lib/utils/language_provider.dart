import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language_model.dart';

class LanguageProvider extends ChangeNotifier {
  static const String LANGUAGE_CODE_KEY = 'language_code';
  LanguageModel _currentLanguage = LanguageModel.supportedLanguages.first;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  LanguageModel get currentLanguage => _currentLanguage;
  
  Locale get locale => Locale(_currentLanguage.code);
  
  bool get isRtl => _currentLanguage.isRtl;

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(LANGUAGE_CODE_KEY);
    if (savedCode != null) {
      _currentLanguage = LanguageModel.getLanguageByCode(savedCode);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(LanguageModel language) async {
    if (_currentLanguage.code != language.code) {
      _currentLanguage = language;
      
      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LANGUAGE_CODE_KEY, language.code);
      
      notifyListeners();
    }
  }
} 