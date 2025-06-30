import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transport_model.dart';
import '../models/search_response_model.dart';

class TransportService {
  static const String apiUrl = 'https://keyworldcargo.com/api/get_transports.php';
  static const String singleTransportUrl = 'https://keyworldcargo.com/api/get_one_transport.php';
  static const String searchUrl = 'https://keyworldcargo.com/api/search.php';

  Future<List<TransportModel>> fetchTransports() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => TransportModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load transports: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load transports: $e');
    }
  }
  
  // Get transports filtered by type
  Future<List<TransportModel>> getTransportsByType(String transportType) async {
    final allTransports = await fetchTransports();
    return allTransports.where((transport) => 
      transport.transportType.toLowerCase() == transportType.toLowerCase()
    ).toList();
  }
  
  // Get a single transport by transport code
  Future<TransportModel> getTransportByCode(String transportCode) async {
    try {
      final url = Uri.parse('$singleTransportUrl?transport_code=$transportCode');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isNotEmpty) {
          return TransportModel.fromJson(jsonData[0]);
        } else {
          throw Exception('Transport not found with code: $transportCode');
        }
      } else {
        throw Exception('Failed to load transport: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load transport: $e');
    }
  }

  // New search method using the search API
  Future<SearchResponseModel> searchByCode(String code) async {
    try {
      final url = Uri.parse('$searchUrl?code=$code');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return SearchResponseModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search: $e');
    }
  }
} 