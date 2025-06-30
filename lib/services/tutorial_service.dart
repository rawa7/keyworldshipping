import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tutorial_model.dart';

class TutorialService {
  static const String baseUrl = 'https://keyworldcargo.com/api/get_app_tutorials.php';

  Future<List<TutorialModel>> fetchTutorials(String appId, {String? languageCode}) async {
    try {
      // Determine which language to request from API
      String apiLanguage = 'en'; // Default to English
      if (languageCode == 'ar') {
        apiLanguage = 'ar'; // Only use Arabic if explicitly Arabic
      }
      
      final url = '$baseUrl?app_id=$appId&language=$apiLanguage';
      print('🔍 Fetching tutorials from: $url');
      
      final response = await http.get(Uri.parse(url));
      
      print('📊 Tutorial response status: ${response.statusCode}');
      print('📊 Tutorial response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // Handle both List and single object responses
        if (responseData is List) {
          if (responseData.isEmpty) {
            print('⚠️ Empty tutorial list received');
            return [];
          }
          
          List<TutorialModel> tutorials = [];
          for (var data in responseData) {
            try {
              tutorials.add(TutorialModel.fromJson(data));
            } catch (e) {
              print('❌ Error parsing tutorial: $e');
              print('❌ Tutorial data: $data');
              // Continue with other tutorials even if one fails
            }
          }
          
          // Additional local filtering based on language
          if (languageCode == 'ar') {
            // If Arabic is selected, show only Arabic tutorials
            tutorials = tutorials.where((tutorial) => 
              tutorial.language == 'ar' || tutorial.language == null).toList();
          } else {
            // For any other language, show only English tutorials
            tutorials = tutorials.where((tutorial) => 
              tutorial.language == 'en' || tutorial.language == null).toList();
          }
          
          return tutorials;
        } else {
          print('❌ Unexpected response format: $responseData');
          return [];
        }
      } else {
        throw Exception('Failed to load tutorials: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Tutorial service error: $e');
      throw Exception('Failed to load tutorials: $e');
    }
  }
} 