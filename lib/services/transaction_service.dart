import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction_model.dart';

class TransactionService {
  final String baseUrl = 'https://keyworldcargo.com/api';
  
  // Get customer account statement
  Future<AccountStatementModel> getCustomerTransactions(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_customer_transactions.php?user_id=$userId'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AccountStatementModel.fromJson(data);
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }
} 