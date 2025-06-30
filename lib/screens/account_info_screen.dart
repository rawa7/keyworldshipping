import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../utils/app_localizations.dart';
import '../utils/language_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/language_selector_widget.dart';

class AccountInfoScreen extends StatelessWidget {
  final UserModel? user;
  
  const AccountInfoScreen({Key? key, this.user}) : super(key: key);

  // Get the first letter of the name and capitalize it
  String _getInitial(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    if (user == null) {
      return 'A';
    }
    
    String displayName = localizations.getLocalizedName(
      user?.name,
      user?.aname,
      user?.kname,
    );
    
    if (displayName.isEmpty) {
      return 'A';
    }
    
    return displayName[0].toUpperCase();
  }
  
  String _getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return localizations.getLocalizedName(
      user?.name,
      user?.aname,
      user?.kname,
    );
  }
  
  Widget _buildInfoItem({required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.account),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const [
          LanguageSelectorWidget(),
          SizedBox(width: 8),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Profile section with blue background
            Container(
              color: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 32),
              width: double.infinity,
              child: Column(
                children: [
                  // Profile avatar with initial
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getInitial(context),
                        style: const TextStyle(
                          color: AppColors.primaryBlue,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getLocalizedName(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Account details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoItem(
                      label: localizations.accountName,
                      value: _getLocalizedName(context),
                    ),
                    _buildInfoItem(
                      label: localizations.username,
                      value: user?.username ?? 'accountname-152',
                    ),
                    _buildInfoItem(
                      label: localizations.phoneNumber,
                      value: user?.phone ?? '07XX XXX XXXX',
                    ),
                  
                    _buildInfoItem(
                      label: localizations.accountType,
                      value: user?.role ?? localizations.standard,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 