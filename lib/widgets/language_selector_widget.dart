import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/language_model.dart';
import '../utils/language_provider.dart';

class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;

    return PopupMenuButton<LanguageModel>(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            currentLanguage.localName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onSelected: (LanguageModel language) {
        languageProvider.changeLanguage(language);
      },
      itemBuilder: (context) {
        return LanguageModel.supportedLanguages.map((language) {
          final isSelected = language.code == currentLanguage.code;
          return PopupMenuItem<LanguageModel>(
            value: language,
            child: Row(
              children: [
                Text(language.localName),
                const SizedBox(width: 8),
                if (isSelected) const Icon(Icons.check, color: Colors.blue),
              ],
            ),
          );
        }).toList();
      },
    );
  }
} 