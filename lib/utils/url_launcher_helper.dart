import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchYoutubeVideo(String videoUrl, BuildContext context) async {
    final Uri uri = Uri.parse(videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the video'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  static Future<void> launchWhatsApp({
    required String phoneNumber,
    required String message,
    required BuildContext context,
  }) async {
    // Format phone number (remove any spaces or special characters)
    String formattedPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Try different WhatsApp URL schemes in order of preference
    final List<String> whatsappUrls = [
      'whatsapp://send?phone=$formattedPhone&text=${Uri.encodeComponent(message)}',
      'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}',
      'https://api.whatsapp.com/send?phone=$formattedPhone&text=${Uri.encodeComponent(message)}',
    ];
    
    bool launched = false;
    
    for (String urlString in whatsappUrls) {
      try {
        final Uri uri = Uri.parse(urlString);
        
        // Try to launch directly without checking canLaunchUrl first
        // as canLaunchUrl sometimes fails to detect installed WhatsApp
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        launched = true;
        break; // If successful, exit the loop
      } catch (e) {
        // Continue to next URL if this one fails
        print('Failed to launch $urlString: $e');
        continue;
      }
    }
    
    // If none of the URLs worked, show error message
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open WhatsApp. Please make sure WhatsApp is installed.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 