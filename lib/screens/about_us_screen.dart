import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../utils/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/language_provider.dart';
import '../main.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  int _selectedIndex = 4; // Profile is selected (About Us is typically accessed from Profile)

  // Get text based on current language
  String _getLocalizedText(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage.code;
    
    switch (currentLanguage) {
      case 'fa': // Kurdish
        return 'کۆمپانیاکەمان کرین و گواستنەوە دابین دەکات بۆتان لە سایتە جیهانیەکان لەچەندین وڵات .\nناونیشانی ئێمە  ڕانیە تەلاری دەوەن \nهەولێر 40 مەتری بەرامبەر توین تاوەر';
      case 'ar': // Arabic
        return 'الشراء و الشحن \nشركتنا تقوم بشراء والشحن للبضائعكم من موقع العالمية .\nالعنوان قضاء رانية بناية تلاري دون \nاربيل شارع 40 فلكة الزراعة مقابل توين تاوةر.';
      default: // English
        return 'Your trusted shipping partner for seamless cargo delivery from Dubai, China, and Kuwait to Iraq.';
    }
  }

  // Launch Instagram URL with fallback
  Future<void> _launchInstagram(String username) async {
    // Try Instagram app first
    final instagramAppUrl = 'instagram://user?username=$username';
    final instagramWebUrl = 'https://www.instagram.com/$username';
    
    try {
      // Try to launch Instagram app
      if (await canLaunchUrl(Uri.parse(instagramAppUrl))) {
        await launchUrl(
          Uri.parse(instagramAppUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to web browser
        await launchUrl(
          Uri.parse(instagramWebUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // If all fails, try web browser as last resort
      try {
        await launchUrl(
          Uri.parse(instagramWebUrl),
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        // Show error message to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Instagram. Please check if you have Instagram installed.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildInstagramIcon({
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/instagramicon.jpeg',
            width: 45,
            height: 45,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to camera icon if image fails to load
              return Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFE4405F),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 24,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index != 2) { // Don't handle search button tap
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(initialIndex: index),
                  ),
                  (route) => false,
                );
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: AppColors.primaryBlueShade(700),
            unselectedItemColor: Colors.grey[500],
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 24,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_boat_filled),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
          ),
        ),
        Positioned(
          top: -25,
          left: MediaQuery.of(context).size.width / 2 - 35,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primaryBlueShade(700),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlueWithOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ABOUT US',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: AppColors.primaryBlueShade(600),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              
              // Company Logo - Clickable to go to Instagram
              GestureDetector(
                onTap: () => _launchInstagram('key_world.cargo'),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.key,
                                color: Colors.black,
                                size: 30,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'KEY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Company Name
              const Text(
                'KEY WORLD',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 30),
              
              // Description Text - Language specific
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _getLocalizedText(context),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Follow Us Text
              Text(
                'Follow Us',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Social Media Icons - Only Instagram with custom icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Instagram Account - using custom Instagram icon
                  _buildInstagramIcon(
                    onTap: () => _launchInstagram('key_world.cargo'),
                  ),
                  
                  // Second Instagram Account - using custom Instagram icon
                  _buildInstagramIcon(
                    onTap: () => _launchInstagram('key_world_cargo'),
                  ),
                ],
              ),
              
              const SizedBox(height: 120), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
} 