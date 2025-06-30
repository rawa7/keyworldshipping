import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/address_model.dart';
import '../utils/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/language_provider.dart';
import '../main.dart';

class Address2DetailScreen extends StatefulWidget {
  final Address2Model address;
  final String customerCode;

  const Address2DetailScreen({
    Key? key,
    required this.address,
    required this.customerCode,
  }) : super(key: key);

  @override
  State<Address2DetailScreen> createState() => _Address2DetailScreenState();
}

class _Address2DetailScreenState extends State<Address2DetailScreen> {
  
  void _copyToClipboard(String text, String fieldName) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fieldName copied to clipboard'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage.code;
    
    // Get localized content based on current language
    final localizedTitle = widget.address.getTitleByLanguage(currentLanguage);
    final localizedNote = widget.address.getNoteByLanguage(currentLanguage);
    final processedAddress = widget.address.processLongAddress(widget.customerCode);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          localizedTitle.isNotEmpty ? localizedTitle.toUpperCase() : AppLocalizations.of(context).shippingAddresses,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Current Language Title (big display)
            if (localizedTitle.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBlueShade(700),
                      AppColors.primaryBlueShade(500),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlueShade(300).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            localizedTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textDirection: currentLanguage == 'ar' || currentLanguage == 'fa' 
                                ? TextDirection.rtl 
                                : TextDirection.ltr,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyToClipboard(localizedTitle, 'Title'),
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.white,
                            size: 20,
                          ),
                          tooltip: 'Copy Title',
                        ),
                      ],
                    ),
                    if (localizedNote.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        localizedNote,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textDirection: currentLanguage == 'ar' || currentLanguage == 'fa' 
                            ? TextDirection.rtl 
                            : TextDirection.ltr,
                      ),
                    ],
                  ],
                ),
              ),
            
            // Long address section in big box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home, color: Colors.green.shade700, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'FULL SHIPPING ADDRESS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _copyToClipboard(processedAddress, 'Full Address'),
                        icon: Icon(
                          Icons.copy,
                          color: Colors.green.shade700,
                          size: 20,
                        ),
                        tooltip: 'Copy Full Address',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    processedAddress,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade800,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (widget.customerCode != 'account')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Customer Code: ${widget.customerCode}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            
            // Additional title section (only if different from main title)
            if (localizedTitle != widget.address.processLongAddress(widget.customerCode) && localizedTitle.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.label, color: Colors.blue.shade700, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'ADDITIONAL INFO',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _copyToClipboard(localizedTitle, 'Additional Info'),
                          icon: Icon(
                            Icons.copy,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          tooltip: 'Copy Additional Info',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizedTitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade800,
                        height: 1.4,
                      ),
                      textDirection: currentLanguage == 'ar' || currentLanguage == 'fa' 
                          ? TextDirection.rtl 
                          : TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            
            // Notes section (only show current language)
            if (localizedNote.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.note, color: Colors.orange.shade700, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'NOTES & INSTRUCTIONS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _copyToClipboard(localizedNote, 'Notes'),
                          icon: Icon(
                            Icons.copy,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          tooltip: 'Copy Notes',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizedNote,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade800,
                        height: 1.4,
                      ),
                      textDirection: currentLanguage == 'ar' || currentLanguage == 'fa' 
                          ? TextDirection.rtl 
                          : TextDirection.ltr,
                    ),
                  ],
                ),
              ),
            
            // Basic info card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.grey.shade700, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'ADDRESS DETAILS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address ID:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.address.id,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  widget.address.isActive == '1' ? Icons.check_circle : Icons.cancel,
                                  size: 16,
                                  color: widget.address.isActive == '1' ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.address.isActive == '1' ? 'Active' : 'Inactive',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.address.isActive == '1' ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 120), // Space for any floating elements
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
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
} 