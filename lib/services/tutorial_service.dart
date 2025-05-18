import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tutorial_model.dart';

class TutorialService {
  static const String baseUrl = 'https://keyworldcargo.com/api/get_app_tutorials.php';

  Future<List<TutorialModel>> fetchTutorials(String appId) async {
    try {
      final url = '$baseUrl?app_id=$appId';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => TutorialModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load tutorials: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load tutorials: $e');
    }
  }
} 