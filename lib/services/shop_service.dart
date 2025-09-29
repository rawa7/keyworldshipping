import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/shop_item_model.dart';

class ShopService {
  static const String apiUrl = 'https://keyworldcargo.com/api/get_shop.php';

  Future<List<ShopItemModel>> fetchShopItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => ShopItemModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load shop items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load shop items: $e');
    }
  }
}
