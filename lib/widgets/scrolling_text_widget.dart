import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import '../models/info_model.dart';
import '../utils/language_provider.dart';
import '../utils/app_localizations.dart';

class ScrollingTextWidget extends StatefulWidget {
  final List<InfoModel> infoItems;

  const ScrollingTextWidget({
    Key? key,
    required this.infoItems,
  }) : super(key: key);

  @override
  State<ScrollingTextWidget> createState() => _ScrollingTextWidgetState();
}

class _ScrollingTextWidgetState extends State<ScrollingTextWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _getLocalizedText(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage.code;
    
    // Get the appropriate text based on current language
    List<String> titles = widget.infoItems.map((item) {
      switch (currentLanguage) {
        case 'ar':
          return item.atitle.isNotEmpty ? item.atitle : item.title;
        case 'fa': // Kurdish
          return item.ktitle.isNotEmpty ? item.ktitle : item.title;
        default: // English
          return item.title;
      }
    }).toList();
    
    // Join all texts with separators
    return titles.join('   •   ');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Listen to language provider changes so widget rebuilds when language is loaded on app restart
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isRtl = languageProvider.isRtl;
    final textDirection = isRtl ? TextDirection.rtl : TextDirection.ltr;
    
    if (widget.infoItems.isEmpty) {
      return Container(
        height: 40,
        alignment: Alignment.center,
        child: const Text(
          'PLEASE ENTER YOUR NOTE HERE TO ALERT YOUR USERS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final combinedText = _getLocalizedText(context);
    
    // If text is short enough, don't animate
    if (combinedText.length < 50) {
      return SizedBox(
        height: 40,
        child: Center(
          child: Text(
            combinedText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            textDirection: textDirection,
          ),
        ),
      );
    }
    
    return SizedBox(
      height: 40,
      child: Marquee(
        // Add key to force rebuild when language changes
        key: ValueKey('${languageProvider.currentLanguage.code}_${combinedText.hashCode}'),
        text: combinedText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.center,
        blankSpace: 50.0,
        velocity: isRtl ? -30.0 : 30.0,
        startPadding: 10.0,
        accelerationDuration: const Duration(seconds: 2),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(seconds: 1),
        decelerationCurve: Curves.easeOut,
        pauseAfterRound: const Duration(seconds: 2),
        // Explicitly set text direction for the Marquee widget
        textDirection: textDirection,
      ),
    );
  }
} 