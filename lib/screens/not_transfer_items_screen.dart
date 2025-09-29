import 'package:flutter/material.dart';
import '../models/not_transfer_item_model.dart';
import '../services/not_transfer_item_service.dart';
import '../utils/app_localizations.dart';
import '../utils/app_colors.dart';
import '../main.dart';

class NotTransferItemsScreen extends StatefulWidget {
  const NotTransferItemsScreen({Key? key}) : super(key: key);

  @override
  State<NotTransferItemsScreen> createState() => _NotTransferItemsScreenState();
}

class _NotTransferItemsScreenState extends State<NotTransferItemsScreen> with AutomaticKeepAliveClientMixin {
  final NotTransferItemService _notTransferItemService = NotTransferItemService();
  List<NotTransferItemModel> _notTransferItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedIndex = 1; // List is selected (Not Transfer Items is in the List section)
  
  // Add flag to prevent multiple simultaneous calls
  bool _isFetchingItems = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Add a small delay to prevent immediate multiple calls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotTransferItems();
    });
  }

  Future<void> _fetchNotTransferItems() async {
    if (_isFetchingItems) return; // Prevent multiple simultaneous calls
    
    _isFetchingItems = true;
    try {
      final items = await _notTransferItemService.fetchNotTransferItems();
      if (mounted) {
        setState(() {
          _notTransferItems = items;
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
      _isFetchingItems = false;
    }
  }

  Widget _buildTableHeader() {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              localizations.itemType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              localizations.itemExample,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(NotTransferItemModel item, bool isEven) {
    final localizations = AppLocalizations.of(context);
    
    // Get the localized item type and example based on current language
    String itemType = item.getLocalizedItemType(localizations.locale.languageCode);
    String itemExample = item.getLocalizedItemExample(localizations.locale.languageCode);
    
    return Container(
      decoration: BoxDecoration(
        color: isEven ? Colors.grey[100] : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              itemType,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              itemExample,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTable() {
    final localizations = AppLocalizations.of(context);
    
    final List<Map<String, String>> placeholderData = [
      {'type': 'Electronic Big', 'example': 'Refrigerators and Freezers'},
      {'type': 'Hazardous Materials', 'example': 'Chemicals and Batteries'},
      {'type': 'Fragile Items', 'example': 'Glass and Ceramics'},
      {'type': 'Liquid Items', 'example': 'Perfumes and Cosmetics'},
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...placeholderData.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> data = entry.value;
            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.grey[100] : Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      data['type']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      data['example']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNotTransferItemsTable() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ..._notTransferItems.asMap().entries.map((entry) {
            int index = entry.key;
            NotTransferItemModel item = entry.value;
            return _buildTableRow(item, index % 2 == 0);
          }),
        ],
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
              color: AppColors.primaryBlueWithOpacity(0.3),
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

  Widget _buildContent() {
    final localizations = AppLocalizations.of(context);
    
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              localizations.loadingNotTransferItems,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null || _notTransferItems.isEmpty) {
      // Show placeholder table when no data is available
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              _buildPlaceholderTable(),
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
            _buildNotTransferItemsTable(),
            const SizedBox(height: 120), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          localizations.notTransferItems,
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
    );
  }
}
