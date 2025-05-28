import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/transaction_service.dart';
import '../utils/app_localizations.dart';

class AccountStatementScreen extends StatefulWidget {
  static const routeName = '/account-statement';
  
  @override
  _AccountStatementScreenState createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {
  final TransactionService _transactionService = TransactionService();
  final AuthService _authService = AuthService();
  
  bool _isLoading = true;
  AccountStatementModel? _accountStatement;
  UserModel? _currentUser;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Get current user
      _currentUser = await _authService.getLocalUser();
      
      if (_currentUser == null || _authService.isGuestUser(_currentUser)) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'You must be logged in to view your account statement.';
        });
        return;
      }
      
      // Get account statement for current user
      final statement = await _transactionService.getCustomerTransactions(_currentUser!.id);
      
      setState(() {
        _accountStatement = statement;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load account statement: ${error.toString()}';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.accountStatement),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(localizations),
    );
  }
  
  Widget _buildBody(AppLocalizations localizations) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: Text(localizations.retry),
              ),
            ],
          ),
        ),
      );
    }
    
    if (_accountStatement == null) {
      return Center(
        child: Text(localizations.noData),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(localizations),
              SizedBox(height: 24),
              Text(
                localizations.transactionHistory,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildTransactionsList(localizations),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBalanceCard(AppLocalizations localizations) {
    final balance = double.tryParse(_accountStatement!.balance) ?? 0.0;
    final isNegative = balance < 0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.currentBalance,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '\$${_accountStatement!.balance}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isNegative ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              isNegative ? localizations.youOweThisAmount : localizations.availableBalance,
              style: TextStyle(
                fontSize: 14,
                color: isNegative ? Colors.red[400] : Colors.green[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransactionsList(AppLocalizations localizations) {
    if (_accountStatement!.transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            localizations.noTransactionsFound,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _accountStatement!.transactions.length,
      itemBuilder: (ctx, index) {
        final transaction = _accountStatement!.transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }
  
  Widget _buildTransactionItem(TransactionModel transaction) {
    final isCharge = transaction.type == 'charge';
    final color = isCharge ? Colors.red : Colors.green;
    final icon = isCharge
        ? Icons.arrow_circle_up_outlined
        : Icons.arrow_circle_down_outlined;
    
    // Format the date
    String formattedDate = '';
    try {
      final dateTime = DateTime.parse(transaction.createdAt);
      formattedDate = DateFormat('MMM d, yyyy, h:mm a').format(dateTime);
    } catch (e) {
      formattedDate = transaction.createdAt;
    }
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          transaction.description,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          formattedDate,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Text(
          '${isCharge ? '-' : '+'}\$${transaction.amount}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
} 