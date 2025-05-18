import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_model.dart';

class AppService {
  static const String apiUrl = 'https://keyworldcargo.com/api/get_apps.php';

  Future<List<AppModel>> fetchApps() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => AppModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load apps: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load apps: $e');
    }
  }
} 