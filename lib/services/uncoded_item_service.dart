import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/uncoded_item_model.dart';

class UncodedItemService {
  static const String apiUrl = 'https://keyworldcargo.com/api/get_uncoded_items.php';

  Future<List<UncodedItemModel>> fetchUncodedItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => UncodedItemModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load uncoded items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load uncoded items: $e');
    }
  }

  // Get an uncoded item by ID
  Future<UncodedItemModel?> getUncodedItemById(String id) async {
    try {
      final items = await fetchUncodedItems();
      return items.firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception('Item not found'),
      );
    } catch (e) {
      throw Exception('Failed to load uncoded item: $e');
    }
  }

  // Search uncoded items by item code or description
  Future<List<UncodedItemModel>> searchUncodedItems(String query) async {
    try {
      final items = await fetchUncodedItems();
      if (query.isEmpty) {
        return items;
      }
      
      return items.where((item) {
        return item.itemCode.toLowerCase().contains(query.toLowerCase()) ||
               item.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      throw Exception('Failed to search uncoded items: $e');
    }
  }
} 