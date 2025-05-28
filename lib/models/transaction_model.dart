class TransactionModel {
  final int id;
  final String type;
  final String amount;
  final String description;
  final String createdAt;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      type: json['type'] ?? '',
      amount: json['amount'] ?? '0.00',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'created_at': createdAt,
    };
  }
}

class AccountStatementModel {
  final int userId;
  final String balance;
  final List<TransactionModel> transactions;

  AccountStatementModel({
    required this.userId,
    required this.balance,
    required this.transactions,
  });

  factory AccountStatementModel.fromJson(Map<String, dynamic> json) {
    List<TransactionModel> transactions = [];
    if (json['transactions'] != null) {
      transactions = List<TransactionModel>.from(
        json['transactions'].map((x) => TransactionModel.fromJson(x))
      );
    }

    return AccountStatementModel(
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      balance: json['balance'] ?? '0.00',
      transactions: transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'balance': balance,
      'transactions': transactions.map((x) => x.toJson()).toList(),
    };
  }
} 