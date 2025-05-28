import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/info_model.dart';

class InfoService {
  final String _apiUrl = 'https://keyworldcargo.com/api/get_info.php';

  Future<List<InfoModel>> fetchInfo() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => InfoModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load info: $e');
    }
  }
} 