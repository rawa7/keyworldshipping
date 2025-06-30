import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/address_model.dart';
import '../models/user_model.dart';
import '../models/transport_model.dart';
import '../services/address_service.dart';
import '../services/auth_service.dart';
import '../services/transport_service.dart';
import '../utils/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/language_provider.dart';
import '../main.dart';
import 'address2_detail_screen.dart';
import 'transport_detail_screen.dart';
import 'item_detail_screen.dart';
import 'search_not_found_screen.dart';

class Addresses2Screen extends StatefulWidget {
  const Addresses2Screen({Key? key}) : super(key: key);

  @override
  State<Addresses2Screen> createState() => _Addresses2ScreenState();
}

class _Addresses2ScreenState extends State<Addresses2Screen> 
    with AutomaticKeepAliveClientMixin {
  final AddressService _addressService = AddressService();
  final AuthService _authService = AuthService();
  final TransportService _transportService = TransportService();
  List<Address2Model> _addresses = [];
  UserModel? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedIndex = 1; // List is selected
  
  // Add flag to prevent multiple simultaneous calls
  bool _isFetchingAddresses = false;
  String? _currentLanguageCode;

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
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Check if language has changed
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final newLanguageCode = languageProvider.currentLanguage.code;
    
    if (_currentLanguageCode != null && _currentLanguageCode != newLanguageCode) {
      print('🌐 Language changed from $_currentLanguageCode to $newLanguageCode');
      _currentLanguageCode = newLanguageCode;
      // No need to refetch addresses since they contain all language versions
      setState(() {}); // Just trigger a rebuild to update the UI
    }
    
    _currentLanguageCode = newLanguageCode;
  }

  Future<void> _loadInitialData() async {
    await _loadUserData();
    await _fetchAddresses();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getLocalUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _fetchAddresses() async {
    if (_isFetchingAddresses) return; // Prevent multiple simultaneous calls
    
    _isFetchingAddresses = true;
    try {
      final addresses = await _addressService.fetchAddresses2();
      if (mounted) {
        setState(() {
          _addresses = addresses;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    } finally {
      _isFetchingAddresses = false;
    }
  }

  String _getCustomerCode() {
    return _currentUser?.username ?? 'account';
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
                  message: 'An error occurred while searching. Please try again.',
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

  Widget _buildAddressCard(Address2Model address) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage.code;
    
    // Get localized title and note
    final title = address.getTitleByLanguage(currentLanguage);
    final note = address.getNoteByLanguage(currentLanguage);
    final processedAddress = address.processLongAddress(_getCustomerCode());
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Address2DetailScreen(
              address: address,
              customerCode: _getCustomerCode(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title at the top
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlueShade(700),
                  ),
                  textDirection: currentLanguage == 'ar' || currentLanguage == 'fa' 
                      ? TextDirection.rtl 
                      : TextDirection.ltr,
                ),
              ),
            
            // Header with location icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueShade(700),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).shippingAddresses,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      if (note.isNotEmpty)
                        Text(
                          note,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                          textDirection: currentLanguage == 'ar' || currentLanguage == 'fa' 
                              ? TextDirection.rtl 
                              : TextDirection.ltr,
                        ),
                    ],
                  ),
                ),
                // Tap to view icon
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Address details (truncated for card view)
            Text(
              processedAddress.length > 150 
                  ? '${processedAddress.substring(0, 150)}...'
                  : processedAddress,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            
            // Copy button
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _copyToClipboard(processedAddress),
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColors.primaryBlueShade(700),
                  ),
                  label: Text(
                    'COPY',
                    style: TextStyle(
                      color: AppColors.primaryBlueShade(700),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address copied to clipboard'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title placeholder
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'SAMPLE ${AppLocalizations.of(context).shippingAddresses}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlueShade(700),
              ),
            ),
          ),
          
          // Header with location icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueShade(700),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).shippingAddresses,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      'only 5 kelos',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Address details placeholder
          Text(
            'Sample address: Name: Sample Customer, Phone: 17760242125, Location: Sample City, Sample Street, Detailed Address: Sample detailed address information would appear here...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          
          // Copy button
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.copy,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
                label: Text(
                  'COPY',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading shipping addresses...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null || _addresses.isEmpty) {
      // Show placeholder cards when no data is available
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              _buildPlaceholderCard(),
              _buildPlaceholderCard(),
              _buildPlaceholderCard(),
              const SizedBox(height: 120), // Space for bottom navigation
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ...(_addresses.map((address) => _buildAddressCard(address)).toList()),
            const SizedBox(height: 120), // Space for bottom navigation
          ],
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
            currentIndex: 1, // LIST tab
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

  Widget _buildSearchOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Material(
          borderRadius: BorderRadius.circular(16),
          elevation: 10,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.primaryBlueShade(700),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Search Transport',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlueShade(700),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _toggleSearchOverlay,
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter transport code...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(
                    Icons.local_shipping,
                    color: AppColors.primaryBlueShade(600),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryBlueShade(300)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryBlueShade(300)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryBlueShade(600), width: 2),
                  ),
                ),
                onSubmitted: _searchTransport,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _toggleSearchOverlay,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSearching
                          ? null
                          : () => _searchTransport(_searchController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlueShade(700),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSearching
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context).shippingAddresses,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                elevation: 0,
                centerTitle: true,
              ),
              body: _buildContent(),
              bottomNavigationBar: _buildBottomNavigation(),
            ),
            if (_isSearchOverlayVisible) _buildSearchOverlay(),
          ],
        );
      },
    );
  }
} 