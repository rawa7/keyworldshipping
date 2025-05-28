import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/banner_model.dart';
import 'models/app_model.dart';
import 'models/user_model.dart';
import 'models/info_model.dart';
import 'services/banner_service.dart';
import 'services/app_service.dart';
import 'services/auth_service.dart';
import 'services/info_service.dart';
import 'widgets/banner_widget.dart';
import 'widgets/app_grid_widget.dart';
import 'widgets/scrolling_text_widget.dart';
import 'screens/tutorials_screen.dart';
import 'screens/transports_screen.dart';
import 'screens/price_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/pre_auth_screen.dart';
import 'screens/account_statement_screen.dart';
import 'utils/app_localizations.dart';
import 'utils/language_provider.dart';
import 'widgets/language_selector_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return MaterialApp(
      title: 'KeyWorld',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Set locale based on provider
      locale: languageProvider.locale,
      // Configure supported locales
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ar', ''), // Arabic
        Locale('fa', ''), // Persian (for Kurdish)
      ],
      // Configure localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Set text direction based on language
      builder: (context, child) {
        return Directionality(
          textDirection: languageProvider.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/auth': (context) => const PreAuthScreen(),
        AccountStatementScreen.routeName: (context) => AccountStatementScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();
  
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }
  
  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Slight delay for splash screen
    
    final isLoggedIn = await _authService.isLoggedIn();
    
    if (!mounted) return;
    
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal, width: 3),
                  ),
                  child: const Icon(Icons.key, color: Colors.amber, size: 40),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.appTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final BannerService _bannerService = BannerService();
  final AppService _appService = AppService();
  final AuthService _authService = AuthService();
  final InfoService _infoService = InfoService();
  List<BannerModel> _banners = [];
  List<AppModel> _apps = [];
  List<InfoModel> _infoItems = [];
  UserModel? _currentUser;
  bool _isLoadingBanners = true;
  bool _isLoadingApps = true;
  bool _isLoadingUser = true;
  bool _isLoadingInfo = true;
  String? _bannerErrorMessage;
  String? _appErrorMessage;
  String? _infoErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchApps();
    _loadUserData();
    _fetchInfo();
  }
  
  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getLocalUser();
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
      
      // If no user is found, redirect to auth screen
      if (user == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/auth');
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
      });
      
      // If error loading user, redirect to auth screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/auth');
      });
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final banners = await _bannerService.fetchBanners();
      setState(() {
        _banners = banners;
        _isLoadingBanners = false;
      });
    } catch (e) {
      setState(() {
        _bannerErrorMessage = e.toString();
        _isLoadingBanners = false;
      });
    }
  }

  Future<void> _fetchApps() async {
    try {
      final apps = await _appService.fetchApps();
      setState(() {
        _apps = apps;
        _isLoadingApps = false;
      });
    } catch (e) {
      setState(() {
        _appErrorMessage = e.toString();
        _isLoadingApps = false;
      });
    }
  }

  Future<void> _fetchInfo() async {
    try {
      final info = await _infoService.fetchInfo();
      if (mounted) {
        setState(() {
          _infoItems = info;
          _isLoadingInfo = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _infoErrorMessage = e.toString();
          _isLoadingInfo = false;
        });
      }
    }
  }

  Widget _buildBannerSection() {
    final localizations = AppLocalizations.of(context);
    
    if (_isLoadingBanners) {
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_bannerErrorMessage != null) {
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(
                localizations.failedToLoadBanners,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoadingBanners = true;
                    _bannerErrorMessage = null;
                  });
                  _fetchBanners();
                },
                child: Text(localizations.retry),
              ),
            ],
          ),
        ),
      );
    }

    return BannerWidget(banners: _banners);
  }

  Widget _buildAppSection() {
    if (_isLoadingApps) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (index) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_appErrorMessage != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (index) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.error, color: Colors.red, size: 24),
            ),
          ),
        ),
      );
    }

    return AppGridWidget(
      apps: _apps,
      onAppTap: (app) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialsScreen(app: app),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection() {
    final localizations = AppLocalizations.of(context);
    
    if (_isLoadingInfo) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20, 
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              localizations.loadingUpdates,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    }

    if (_infoErrorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                localizations.failedToLoadUpdates,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    if (_infoItems.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'PLEASE ENTER YOUR NOTE HERE TO ALERT YOUR USERS',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ScrollingTextWidget(infoItems: _infoItems),
    );
  }

  Widget _buildCountryAppsGrid(String country) {
    if (_isLoadingApps) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) => 
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      );
    }

    if (_appErrorMessage != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) => 
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.error, color: Colors.red, size: 24),
            ),
          ),
        ),
      );
    }

    // Filter apps by country (case-insensitive)
    final filteredApps = _apps.where((app) {
      final appCountry = app.country.toUpperCase();
      return appCountry == country.toUpperCase() || 
             (country == 'USA' && (appCountry == 'US' || appCountry == 'UNITED STATES'));
    }).toList();

    // If no apps found for this country, show placeholder
    if (filteredApps.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) => 
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'App',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Show apps in a grid layout
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.spaceEvenly,
      children: filteredApps.take(8).map((app) => 
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TutorialsScreen(app: app),
              ),
            );
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: app.icon.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: app.getIconUrl(),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          app.name.length > 6 ? app.name.substring(0, 6) : app.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    app.name.length > 6 ? app.name.substring(0, 6) : app.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
          ),
        ),
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking authentication
    if (_isLoadingUser) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _selectedIndex == 0 
          ? SafeArea(
              child: Column(
                children: [
                  // Top header with logo and notification
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo section
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.teal, width: 2),
                                  ),
                                  child: const Icon(Icons.key, color: Colors.amber, size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'KEY WORLD',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        // Notification icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Main content area
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info section with blue background (using existing info functionality)
                            _buildInfoSection(),
                            
                            const SizedBox(height: 24),
                            
                            // Five circular buttons row (Stories - placeholder for now)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(5, (index) => 
                                GestureDetector(
                                  onTap: () {
                                    // TODO: Implement stories functionality when API is ready
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Stories coming soon!')),
                                    );
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade700,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Banner section (using existing banner functionality)
                            _buildBannerSection(),
                            
                            const SizedBox(height: 16),
                            
                            // Banner indicators (show only if banners are loaded)
                            if (!_isLoadingBanners && _banners.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade700,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 30,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade700,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                            
                            const SizedBox(height: 32),
                            
                            // USA section (apps filtered by country)
                            Text(
                              'USA',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // USA apps grid (filtered by country = 'USA' or 'US')
                            _buildCountryAppsGrid('USA'),
                            
                            const SizedBox(height: 32),
                            
                            // CHINA section (apps filtered by country)
                            Text(
                              'CHINA',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // CHINA apps grid - filtered by country
                            _buildCountryAppsGrid('CHINA'),
                            
                            const SizedBox(height: 120), // Extra space for bottom navigation
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : _selectedIndex == 1
              ? const TransportsScreen()
              : _selectedIndex == 2
                  ? const PriceListScreen()
                  : _selectedIndex == 3
                      ? ProfileScreen(user: _currentUser)
                      : Center(
                          child: Text(
                            'Page $_selectedIndex',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
      
      // Bottom navigation bar with floating search button
      bottomNavigationBar: Stack(
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
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.blue.shade700,
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
                  icon: SizedBox.shrink(), // Empty space for floating button
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
                ),
              ],
            ),
          ),
          // Floating search button
          Positioned(
            top: -25,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
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
      ),
    );
  }
}
