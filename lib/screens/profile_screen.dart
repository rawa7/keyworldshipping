import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/app_update_service.dart';
import '../utils/app_localizations.dart';
import '../utils/app_colors.dart';
import '../widgets/update_dialog.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';
import 'account_info_screen.dart';
import 'account_statement_screen.dart';
import 'language_settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;
  
  const ProfileScreen({Key? key, this.user}) : super(key: key);

  Future<void> _checkForUpdates(BuildContext context) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Checking for updates...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final updateService = AppUpdateService();
      final updateModel = await updateService.checkForUpdate(forceCheck: true);
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }
      
      if (updateModel != null && updateModel.shouldShowUpdate()) {
        // Show update dialog
        if (context.mounted) {
          await UpdateDialog.show(
            context,
            updateModel,
            onUpdateSkipped: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Update skipped'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            onUpdatePostponed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You will be reminded about this update later'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            onUpdateStarted: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening app store...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          );
        }
      } else {
        // No update available
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are using the latest version of the app'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.pop(context);
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to check for updates: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // Get the localized name
  String _getLocalizedName(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return localizations.getLocalizedName(
      user?.name,
      user?.aname,
      user?.kname,
    );
  }

  // Get the first letter of the name and capitalize it
  String _getInitial(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    if (user == null) {
      return 'A';
    }
    
    String displayName = _getLocalizedName(context);
    
    if (displayName.isEmpty) {
      return 'A';
    }
    
    return displayName[0].toUpperCase();
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Avatar and Name
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlueWithOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryBlueWithOpacity(0.3), width: 2),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.username ?? user?.phone ?? 'No username',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Menu Items
              _buildProfileMenuItem(
                icon: Icons.person,
                title: localizations.accountInfo,
                iconColor: AppColors.primaryBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountInfoScreen(user: user),
                    ),
                  );
                },
              ),
              
              _buildProfileMenuItem(
                icon: Icons.language,
                title: localizations.languageSettings,
                iconColor: AppColors.primaryBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageSettingsScreen(),
                    ),
                  );
                },
              ),
              
              _buildProfileMenuItem(
                icon: Icons.info,
                title: localizations.aboutUs,
                iconColor: AppColors.primaryBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsScreen(),
                    ),
                  );
                },
              ),
              
              _buildProfileMenuItem(
                icon: Icons.flag,
                title: localizations.contactUs,
                iconColor: AppColors.primaryBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactUsScreen(),
                    ),
                  );
                },
              ),
              
              _buildProfileMenuItem(
                icon: Icons.receipt_long,
                title: localizations.accountStatement ?? 'Account Statement',
                iconColor: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, AccountStatementScreen.routeName);
                },
              ),
              
              _buildProfileMenuItem(
                icon: Icons.system_update,
                title: 'Check for Updates',
                iconColor: Colors.orange,
                onTap: () async {
                  await _checkForUpdates(context);
                },
              ),
              
              const SizedBox(height: 24),
              
              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Show confirmation dialog
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(localizations.logoutConfirmation),
                          content: Text(localizations.logoutConfirmationMessage),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(localizations.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(localizations.logout),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        final authService = AuthService();
                        await authService.logout();
                        
                        if (!context.mounted) return;
                        Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      localizations.logout,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 