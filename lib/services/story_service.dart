import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story_model.dart';

class StoryService {
  static const String baseUrl = 'https://keyworldcargo.com/api';

  Future<List<StoryModel>> fetchStories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_stories.php'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        
        // Filter only valid (active and not expired) stories
        final stories = jsonData
            .map((json) => StoryModel.fromJson(json))
            .where((story) => story.isValid)
            .toList();
        
        // Sort by creation date (newest first)
        stories.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        return stories;
      } else {
        throw Exception('Failed to load stories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stories: $e');
    }
  }
} 