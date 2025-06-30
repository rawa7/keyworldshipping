import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company_address_model.dart';

class CompanyAddressService {
  static const String apiUrl = 'https://keyworldcargo.com/api/api_companyaddress.php';

  Future<List<CompanyAddressModel>> fetchCompanyAddresses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> jsonData = responseData['data'];
          return jsonData.map((data) => CompanyAddressModel.fromJson(data)).toList();
        } else {
          throw Exception('Invalid data format: missing data key');
        }
      } else {
        throw Exception('Failed to load company addresses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load company addresses: $e');
    }
  }
} 