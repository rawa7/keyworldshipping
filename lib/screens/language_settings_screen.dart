import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/language_model.dart';
import '../utils/language_provider.dart';
import '../utils/app_localizations.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.languageSettings),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: LanguageModel.supportedLanguages.length,
        itemBuilder: (context, index) {
          final language = LanguageModel.supportedLanguages[index];
          final isSelected = language.code == languageProvider.currentLanguage.code;
          
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  language.code.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            title: Text(
              language.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(language.localName),
            trailing: isSelected 
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : null,
            onTap: () {
              languageProvider.changeLanguage(language);
            },
          );
        },
      ),
    );
  }
} 