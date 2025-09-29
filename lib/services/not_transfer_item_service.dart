import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/not_transfer_item_model.dart';

class NotTransferItemService {
  static const String apiUrl = 'https://keyworldcargo.com/api/get_not_transfer_item.php';

  Future<List<NotTransferItemModel>> fetchNotTransferItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => NotTransferItemModel.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load not transfer items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load not transfer items: $e');
    }
  }
}
