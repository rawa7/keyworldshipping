import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/price_model.dart';

class PriceService {
  static const String apiUrl = 'https://keyworldcargo.com/api/get_city_prices.php';

  Future<List<PriceModel>> fetchPrices() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('prices')) {
          final List<dynamic> pricesJson = data['prices'];
          return pricesJson.map((json) => PriceModel.fromJson(json)).toList();
        } else {
          throw Exception('Invalid data format: missing prices key');
        }
      } else {
        throw Exception('Failed to load prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load prices: $e');
    }
  }
} 