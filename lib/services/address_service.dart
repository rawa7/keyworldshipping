import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/address_model.dart';

class AddressService {
  static const String baseUrl = 'https://keyworldcargo.com/api';

  Future<List<AddressModel>> fetchAddresses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_address.php'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load addresses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }

  // New method to fetch addresses from the address2 API
  Future<List<Address2Model>> fetchAddresses2() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_address2.php'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Address2Model.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load addresses2: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch addresses2: $e');
    }
  }
} 