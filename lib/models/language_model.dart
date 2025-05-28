import 'package:flutter/material.dart';

class LanguageModel {
  final String code;
  final String name;
  final String localName;
  final bool isRtl;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.localName,
    required this.isRtl,
  });

  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(
      code: 'en',
      name: 'English',
      localName: 'English',
      isRtl: false,
    ),
    LanguageModel(
      code: 'ar',
      name: 'Arabic',
      localName: 'العربية',
      isRtl: true,
    ),
    LanguageModel(
      code: 'fa',
      name: 'Kurdish',
      localName: 'کوردی',
      isRtl: true,
    ),
  ];

  static LanguageModel getLanguageByCode(String code) {
    return supportedLanguages.firstWhere(
      (language) => language.code == code,
      orElse: () => supportedLanguages.first,
    );
  }
} 