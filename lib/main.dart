import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/banner_model.dart';
import 'models/app_model.dart';
import 'models/user_model.dart';
import 'models/info_model.dart';
import 'models/story_model.dart';
import 'models/transport_model.dart';
import 'models/search_response_model.dart';
import 'models/notification_model.dart';
import 'models/update_model.dart';
import 'services/banner_service.dart';
import 'services/app_service.dart';
import 'services/auth_service.dart';
import 'services/info_service.dart';
import 'services/story_service.dart';
import 'services/transport_service.dart';
import 'services/notification_service.dart';
import 'services/app_update_service.dart';
import 'screens/tutorials_screen.dart';
import 'screens/transports_screen.dart';
import 'screens/list_screen.dart';
import 'screens/price_list_screen.dart';
import 'screens/addresses2_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/pre_auth_screen.dart';
import 'screens/account_statement_screen.dart';
import 'screens/story_viewer_screen.dart';
import 'screens/uncoded_goods_screen.dart';
import 'screens/chinese_companies_screen.dart';
import 'screens/not_transfer_items_screen.dart';
import 'screens/shop_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/transport_detail_screen.dart';
import 'screens/item_detail_screen.dart';
import 'screens/search_not_found_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/price_notifications_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/tutorial_detail_screen.dart';
import 'screens/transport_type_screen.dart';
import 'utils/app_localizations.dart';
import 'utils/language_provider.dart';
import 'utils/app_colors.dart';
import 'widgets/language_selector_widget.dart';
import 'widgets/banner_widget.dart';
import 'widgets/app_grid_widget.dart';
import 'widgets/scrolling_text_widget.dart';
import 'widgets/stories_widget.dart';
import 'widgets/whatsapp_floating_button.dart';
import 'widgets/update_dialog.dart';
import 'package:flutter/services.dart';

class AppController {
  static const platform = MethodChannel('app_control');
  
  static Future<void> forceExit() async {
    try {
      await platform.invokeMethod('forceExit');
    } on PlatformException catch (e) {
      print("Failed to force exit: '${e.message}'.");
      // Fallback to SystemNavigator.pop()
      SystemNavigator.pop();
    }
  }
}

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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
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
        '/language-selection': (context) => const LanguageSelectionScreen(),
        '/home': (context) => const HomePage(),
        '/auth': (context) => const PreAuthScreen(),
        '/price-list': (context) => const PriceListScreen(),
        '/price-notifications': (context) => const PriceNotificationsScreen(),
        '/addresses2': (context) => const Addresses2Screen(),
        '/uncoded-goods': (context) => const UncodedGoodsScreen(),
        '/chinese-companies': (context) => const ChineseCompaniesScreen(),
        '/not-transfer-items': (context) => const NotTransferItemsScreen(),
        '/shop': (context) => const ShopScreen(),
        '/notifications': (context) => const NotificationsScreen(),
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
  final AppUpdateService _updateService = AppUpdateService();
  
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }
  
  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1500)); // Slight delay for splash screen
    
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('is_first_time') ?? true;
    final isLoggedIn = await _authService.isLoggedIn();
    
    if (!mounted) return;
    
    // Check for app updates first
    await _checkForUpdates();
    
    if (!mounted) return;
    
    if (isFirstTime) {
      // Show language selection screen for first-time users
      Navigator.pushReplacementNamed(context, '/language-selection');
      // Mark that the user has seen the language selection screen
      await prefs.setBool('is_first_time', false);
    } else if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }
  
  Future<void> _checkForUpdates() async {
    try {
      final updateModel = await _updateService.checkForUpdate();
      
      if (updateModel != null && 
          updateModel.shouldShowUpdate() && 
          !await _updateService.isVersionSkipped(updateModel.latestVersion)) {
        
        if (!mounted) return;
        
        // Show update dialog
        await UpdateDialog.show(
          context,
          updateModel,
          onUpdateSkipped: () {
            print('✅ User skipped update to version ${updateModel.latestVersion}');
          },
          onUpdatePostponed: () {
            print('⏰ User postponed update to version ${updateModel.latestVersion}');
          },
          onUpdateStarted: () {
            print('🚀 User started update to version ${updateModel.latestVersion}');
          },
        );
      }
    } catch (e) {
      print('❌ Error during update check: $e');
      // Continue with normal app flow even if update check fails
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
                color: AppColors.primaryBlueShade(100),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryBlue, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.key, color: Colors.amber, size: 40);
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.appTitle,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final int initialIndex;
  
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late int _selectedIndex;
  final BannerService _bannerService = BannerService();
  final AppService _appService = AppService();
  final AuthService _authService = AuthService();
  final InfoService _infoService = InfoService();
  final StoryService _storyService = StoryService();
  final TransportService _transportService = TransportService();
  final NotificationService _notificationService = NotificationService();
  List<BannerModel> _banners = [];
  List<AppModel> _apps = [];
  List<InfoModel> _infoItems = [];
  List<StoryModel> _stories = [];
  List<TransportModel> _transports = [];
  List<NotificationModel> _notifications = [];
  UserModel? _currentUser;
  bool _isLoadingBanners = true;
  bool _isLoadingApps = true;
  bool _isLoadingUser = true;
  bool _isLoadingInfo = true;
  bool _isLoadingStories = true;
  bool _isLoadingTransports = true;
  bool _isLoadingNotifications = true;
  String? _bannerErrorMessage;
  String? _appErrorMessage;
  String? _infoErrorMessage;
  String? _storyErrorMessage;
  String? _transportErrorMessage;
  int _unreadNotificationCount = 0;
  int _unreadPriceNotificationCount = 0;
  
  // Add flags to prevent multiple simultaneous calls
  bool _isFetchingBanners = false;
  bool _isFetchingApps = false;
  bool _isFetchingInfo = false;
  bool _isFetchingStories = false;
  bool _isFetchingTransports = false;
  bool _isFetchingNotifications = false;

  // Search functionality
  bool _isSearchOverlayVisible = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  TransportModel? _searchResult;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    WidgetsBinding.instance.addObserver(this);
    // Add a small delay to prevent immediate multiple calls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBanners();
      _fetchApps();
      _loadUserData();
      _fetchInfo();
      _fetchStories();
      _fetchTransports();
      _fetchNotifications();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    
    // Cancel any ongoing operations
    _isFetchingBanners = false;
    _isFetchingApps = false;
    _isFetchingInfo = false;
    _isFetchingStories = false;
    _isFetchingTransports = false;
    _isFetchingNotifications = false;
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in the foreground
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App is in the background or being closed
        // Force cancel any running timers or background processes
        _cancelAllOperations();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _cancelAllOperations() {
    // Stop all background fetching operations
    _isFetchingBanners = false;
    _isFetchingApps = false;
    _isFetchingInfo = false;
    _isFetchingStories = false;
    _isFetchingTransports = false;
    _isFetchingNotifications = false;
  }

  void _toggleSearchOverlay() {
    setState(() {
      _isSearchOverlayVisible = !_isSearchOverlayVisible;
      if (!_isSearchOverlayVisible) {
        _searchController.clear();
        _searchResult = null;
        _isSearching = false;
      }
    });
  }

  Future<void> _searchTransport(String transportCode) async {
    if (transportCode.isEmpty) {
      setState(() {
        _searchResult = null;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final searchResponse = await _transportService.searchByCode(transportCode);
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        
        _toggleSearchOverlay(); // Close search overlay
        
        // Navigate based on search status
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            if (searchResponse.isTransportOnly && searchResponse.transport != null) {
              // Status 1: Show transport details only
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransportDetailScreen(transport: searchResponse.transport!),
                ),
              );
            } else if (searchResponse.isTransportWithItem && 
                       searchResponse.transport != null && 
                       searchResponse.item != null) {
              // Status 2: Show both transport and item details
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(
                    transport: searchResponse.transport!,
                    item: searchResponse.item!,
                  ),
                ),
              );
            } else if (searchResponse.isNotFound) {
              // Status 0: Show not found screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchNotFoundScreen(
                    searchCode: transportCode,
                    message: searchResponse.message,
                    onSearchAgain: () {
                      Navigator.pop(context);
                      _toggleSearchOverlay();
                    },
                  ),
                ),
              );
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResult = null;
          _isSearching = false;
        });
        
        _toggleSearchOverlay(); // Close search overlay
        
        // Navigate to error screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchNotFoundScreen(
                  searchCode: transportCode,
                  message: 'Network error: ${e.toString()}',
                  onSearchAgain: () {
                    Navigator.pop(context);
                    _toggleSearchOverlay();
                  },
                ),
              ),
            );
          }
        });
      }
    }
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
      } else {
        // Fetch notifications after user is loaded
        _fetchNotifications();
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
    if (_isFetchingBanners) return; // Prevent multiple simultaneous calls
    
    _isFetchingBanners = true;
    try {
      final banners = await _bannerService.fetchBanners();
      if (mounted) {
        setState(() {
          _banners = banners;
          _isLoadingBanners = false;
          _bannerErrorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _bannerErrorMessage = e.toString();
          _isLoadingBanners = false;
        });
      }
    } finally {
      _isFetchingBanners = false;
    }
  }

  Future<void> _fetchApps() async {
    if (_isFetchingApps) return; // Prevent multiple simultaneous calls
    
    _isFetchingApps = true;
    try {
      final apps = await _appService.fetchApps();
      if (mounted) {
        setState(() {
          _apps = apps;
          _isLoadingApps = false;
          _appErrorMessage = null;
          
          // Extract unique countries from apps
          _updateCountriesFromApps();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _appErrorMessage = e.toString();
          _isLoadingApps = false;
        });
      }
    } finally {
      _isFetchingApps = false;
    }
  }

  void _updateCountriesFromApps() {
    // Extract countries in the order they appear in the API response
    List<String> countriesInApiOrder = [];
    Set<String> seenCountries = {};
    
    for (var app in _apps) {
      if (app.country.isNotEmpty) {
        String country = app.country.toUpperCase();
        // Handle different variations of USA
        if (country == 'US' || country == 'UNITED STATES') {
          country = 'USA';
        }
        
        // Add country to list only if we haven't seen it before
        // This preserves the API order (first occurrence determines position)
        if (!seenCountries.contains(country)) {
          countriesInApiOrder.add(country);
          seenCountries.add(country);
        }
      }
    }
    
    // The countries are now in the exact order they appear in the API response
    _countries = countriesInApiOrder;
  }

  Future<void> _fetchInfo() async {
    if (_isFetchingInfo) return; // Prevent multiple simultaneous calls
    
    _isFetchingInfo = true;
    try {
      final info = await _infoService.fetchInfo();
      if (mounted) {
        setState(() {
          _infoItems = info;
          _isLoadingInfo = false;
          _infoErrorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _infoErrorMessage = e.toString();
          _isLoadingInfo = false;
        });
      }
    } finally {
      _isFetchingInfo = false;
    }
  }

  Future<void> _fetchStories() async {
    if (_isFetchingStories) return; // Prevent multiple simultaneous calls
    
    _isFetchingStories = true;
    try {
      final stories = await _storyService.fetchStories();
      if (mounted) {
        setState(() {
          _stories = stories;
          _isLoadingStories = false;
          _storyErrorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _storyErrorMessage = e.toString();
          _isLoadingStories = false;
        });
      }
    } finally {
      _isFetchingStories = false;
    }
  }

  Future<void> _fetchTransports() async {
    if (_isFetchingTransports) return; // Prevent multiple simultaneous calls
    
    _isFetchingTransports = true;
    try {
      final transports = await _transportService.fetchTransports();
      if (mounted) {
        setState(() {
          _transports = transports;
          _isLoadingTransports = false;
          _transportErrorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _transportErrorMessage = e.toString();
          _isLoadingTransports = false;
        });
      }
    } finally {
      _isFetchingTransports = false;
    }
  }

  Future<void> _fetchNotifications() async {
    if (_isFetchingNotifications) return; // Prevent multiple simultaneous calls
    if (_currentUser == null || _authService.isGuestUser(_currentUser)) return; // Don't fetch for guests
    
    _isFetchingNotifications = true;
    try {
      final notifications = await _notificationService.getNotifications(_currentUser!.id);
      // Use the service methods that consider locally seen global notifications
      final unreadCount = await _notificationService.getUnreadNonPriceCount(_currentUser!.id);
      final unreadPriceCount = await _notificationService.getUnreadPriceCount(_currentUser!.id);
      
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _unreadNotificationCount = unreadCount;
          _unreadPriceNotificationCount = unreadPriceCount;
          _isLoadingNotifications = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      if (mounted) {
        setState(() {
          _isLoadingNotifications = false;
        });
      }
    } finally {
      _isFetchingNotifications = false;
    }
  }

  Future<void> _handleRefresh() async {
    // Reset loading states
    if (mounted) {
      setState(() {
        _isLoadingBanners = true;
        _isLoadingApps = true;
        _isLoadingInfo = true;
        _isLoadingStories = true;
        _isLoadingTransports = true;
        _isLoadingNotifications = true;
        
        // Clear error messages
        _bannerErrorMessage = null;
        _appErrorMessage = null;
        _infoErrorMessage = null;
        _storyErrorMessage = null;
        _transportErrorMessage = null;
      });
    }

    // Fetch all data concurrently
    await Future.wait([
      _fetchBanners(),
      _fetchApps(),
      _fetchInfo(),
      _fetchStories(),
      _fetchTransports(),
      _fetchNotifications(),
    ]);
  }

  Widget _buildBannerSection() {
    final localizations = AppLocalizations.of(context);
    
    if (_isLoadingBanners) {
      return Container(
        width: double.infinity,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primaryBlue, width: 2),
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
          border: Border.all(color: AppColors.primaryBlue, width: 2),
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
                  if (!_isFetchingBanners) {
                    setState(() {
                      _isLoadingBanners = true;
                      _bannerErrorMessage = null;
                    });
                    _fetchBanners();
                  }
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueShade(700),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ScrollingTextWidget(infoItems: _infoItems),
    );
  }

  Widget _buildStorySection() {
    final localizations = AppLocalizations.of(context);
    
    if (_isLoadingStories) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
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
              localizations.loadingStories,
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

    if (_storyErrorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                localizations.failedToLoadStories,
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

    if (_stories.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          localizations.noStoriesAvailable,
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

    return StoriesWidget(stories: _stories);
  }

  Widget _buildTransportSection() {
    final localizations = AppLocalizations.of(context);
    
    if (_isLoadingTransports) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
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
              localizations.loadingTransports,
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

    if (_transportErrorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                localizations.failedToLoadTransports,
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

    if (_transports.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlueShade(700),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          localizations.noTransportsAvailable,
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
        color: AppColors.primaryBlueShade(700),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Transport Section',
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

  Widget _buildSearchOverlay() {
    final localizations = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    
    return Positioned(
      bottom: bottomInset + 90, // Move up with keyboard
      left: 20,
      right: 20,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add a visual connection indicator
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: AppColors.primaryBlue,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    localizations.searchTransport ?? 'Search Transport',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _toggleSearchOverlay,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: localizations.enterTruckNumber ?? 'ENTER TRUCK NUMBER...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                          filled: false,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchResult = null;
                                    });
                                  },
                                )
                              : null,
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSubmitted: (value) {
                          _searchTransport(value);
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _searchResult = null;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: _isSearching
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search, color: Colors.white, size: 22),
                      onPressed: () {
                        if (!_isSearching) {
                          _searchTransport(_searchController.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Show loading indicator while checking authentication
    if (_isLoadingUser) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    final localizations = AppLocalizations.of(context);
    
    return WillPopScope(
      onWillPop: () async {
        // If search overlay is visible, hide it first
        if (_isSearchOverlayVisible) {
          _toggleSearchOverlay();
          return false;
        }
        
        // If we're not on the home tab, go to home tab first
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        
        // If we're on home tab, show exit confirmation
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(localizations.exitApp ?? 'Exit App'),
            content: Text(localizations.exitAppMessage ?? 'Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(localizations.cancel ?? 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  // Force exit the app
                  AppController.forceExit();
                },
                child: Text(localizations.exit ?? 'Exit'),
              ),
            ],
          ),
        ) ?? false;
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.grey[100],
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomePage(),
                const ListScreen(),
                const TransportsScreen(),
                const TransportsScreen(),
                ProfileScreen(user: _currentUser),
                      ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    ),
    WhatsAppFloatingButton(user: _currentUser),
    if (_isSearchOverlayVisible) _buildSearchOverlay(),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppColors.primaryBlue,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(),
                      const SizedBox(height: 24),
                      _buildStorySection(),
                      const SizedBox(height: 24),
                      _buildBannerSection(),
                      const SizedBox(height: 16),
                      _buildBannerIndicators(),
                      const SizedBox(height: 32),
                      ..._buildCountrySections(),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryBlue, width: 1.5),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.key, color: Colors.amber, size: 24);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'KEY WORLD',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlueShade(700),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Price notifications icon
              if (_notifications.any((n) => n.type == 'price'))
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/price-notifications').then((_) {
                      // Refresh notifications when coming back from price notifications screen
                      _fetchNotifications();
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      if (_unreadPriceNotificationCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              _unreadPriceNotificationCount > 99 ? '99+' : '$_unreadPriceNotificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              if (_notifications.any((n) => n.type == 'price'))
                const SizedBox(width: 8),
              // Regular notifications icon
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/notifications').then((_) {
                    // Refresh notifications when coming back from notifications screen
                    _fetchNotifications();
                  });
                },
                child: Stack(
                  children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueShade(700),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 24,
            ),
                    ),
                    if (_unreadNotificationCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            _unreadNotificationCount > 99 ? '99+' : '$_unreadNotificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerIndicators() {
    if (_isLoadingBanners || _banners.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return const SizedBox.shrink();
  }

  // List of countries in the order they should appear (populated from API)
  List<String> _countries = [];

  List<Widget> _buildCountrySections() {
    List<Widget> sections = [];
    
    for (int i = 0; i < _countries.length; i++) {
      sections.add(_buildCountrySection(_countries[i]));
      
      // Add spacing between sections (except after the last one)
      if (i < _countries.length - 1) {
        sections.add(const SizedBox(height: 32));
      }
    }
    
    return sections;
  }

  Widget _buildCountrySection(String country) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          country,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        _buildCountryAppsGrid(country),
      ],
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
              if (index != 2) {
                setState(() {
                  _selectedIndex = index;
                });
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
          child: GestureDetector(
            onTap: _toggleSearchOverlay,
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
        ),
      ],
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
      alignment: WrapAlignment.start,
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
}
