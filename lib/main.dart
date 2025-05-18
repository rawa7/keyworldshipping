import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'models/banner_model.dart';
import 'models/app_model.dart';
import 'services/banner_service.dart';
import 'services/app_service.dart';
import 'widgets/banner_widget.dart';
import 'widgets/app_grid_widget.dart';
import 'screens/tutorials_screen.dart';
import 'screens/transports_screen.dart';
import 'screens/price_list_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeyWorld',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
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
  List<BannerModel> _banners = [];
  List<AppModel> _apps = [];
  bool _isLoadingBanners = true;
  bool _isLoadingApps = true;
  String? _bannerErrorMessage;
  String? _appErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
    _fetchApps();
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

  Widget _buildBannerSection() {
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
                'Failed to load banners',
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
                child: const Text('Retry'),
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
          5,
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
          5,
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

    // If we have fewer than 5 apps, add empty containers to fill the space
    if (_apps.length < 5) {
      final appWidgets = <Widget>[];
      appWidgets.addAll(
        _apps.map((app) => _buildAppItem(app)).toList(),
      );
      
      // Add empty containers
      for (int i = _apps.length; i < 5; i++) {
        appWidgets.add(
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'APP',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: appWidgets,
      );
    }

    // If we have exactly 5 apps or more (show the first 5)
    return AppGridWidget(
      apps: _apps.take(5).toList(),
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

  Widget _buildAppItem(AppModel app) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorialsScreen(app: app),
          ),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: app.getIconUrl(),
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 24,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              app.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 
          ? SafeArea(
              child: Column(
                children: [
                  // Top navigation bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.apps, color: Colors.blue),
                        Icon(Icons.notifications, color: Colors.blue),
                      ],
                    ),
                  ),
                  
                  // Main content area
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Banner section with rounded corners
                          _buildBannerSection(),
                          
                          const SizedBox(height: 16),
                          
                          // Info section
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'INFO',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Row of app buttons from API
                          _buildAppSection(),
                        ],
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
                      ? const ProfileScreen()
                      : Center(
                          child: Text(
                            'Page $_selectedIndex',
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
      
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Prices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
