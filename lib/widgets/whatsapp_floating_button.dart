import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../utils/url_launcher_helper.dart';
import '../utils/language_provider.dart';
import '../utils/app_colors.dart';

class WhatsAppFloatingButton extends StatefulWidget {
  final UserModel? user;
  final String? heroTag;
  
  const WhatsAppFloatingButton({super.key, this.user, this.heroTag});

  @override
  State<WhatsAppFloatingButton> createState() => _WhatsAppFloatingButtonState();
}

class _WhatsAppFloatingButtonState extends State<WhatsAppFloatingButton> {
  Offset? _position; // Will be null initially
  bool _isDragging = false;
  bool _isFirstTime = true;
  
  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  Future<void> _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    final x = prefs.getDouble('fab_position_x');
    final y = prefs.getDouble('fab_position_y');
    
    if (x != null && y != null) {
      setState(() {
        _position = Offset(x, y);
        _isFirstTime = false;
      });
    }
    // If no saved position, _position remains null and we'll set it in build()
  }

  Future<void> _savePosition(Offset position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fab_position_x', position.dx);
    await prefs.setDouble('fab_position_y', position.dy);
  }

  void _openWhatsApp(BuildContext context) {
    String username = widget.user?.username ?? widget.user?.name ?? 'Guest User';
    String message = 'hi its me user $username';
    
    // Get current language from provider
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    
    // Choose phone number based on language
    String phoneNumber;
    if (languageProvider.currentLanguage.code == 'ar') {
      // Arabic language - use Arabic support number
      phoneNumber = '+9647702487798';
    } else {
      // Kurdish or English - use default number
      phoneNumber = '+9647501792808';
    }
    
    UrlLauncherHelper.launchWhatsApp(
      phoneNumber: phoneNumber,
      message: message,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final fabSize = 56.0; // Standard FAB size
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    // Set default position to bottom-right corner if this is the first time
    if (_position == null) {
      _position = Offset(
        screenSize.width - fabSize - 20, // 20px padding from right edge
        screenSize.height - fabSize - 120, // Increased padding for better visibility
      );
    }
    
    return Positioned(
      left: _position!.dx,
      top: _position!.dy,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            // Calculate new position with bounds checking
            double newX = _position!.dx + details.delta.dx;
            double newY = _position!.dy + details.delta.dy;
            
            // Keep within screen bounds
            newX = newX.clamp(0, screenSize.width - fabSize);
            newY = newY.clamp(0, screenSize.height - fabSize - 100); // 100 for bottom padding
            
            _position = Offset(newX, newY);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
          _savePosition(_position!);
          
          // Snap to edges if close enough
          double snapDistance = 50.0;
          double newX = _position!.dx;
          
          if (_position!.dx < snapDistance) {
            newX = 20.0; // Snap to left edge with padding
          } else if (_position!.dx > screenSize.width - fabSize - snapDistance) {
            newX = screenSize.width - fabSize - 20.0; // Snap to right edge with padding
          }
          
          if (newX != _position!.dx) {
            setState(() {
              _position = Offset(newX, _position!.dy);
            });
            _savePosition(_position!);
          }
        },
        child: AnimatedContainer(
          duration: _isDragging ? Duration.zero : const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_isDragging ? 1.1 : 1.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isDragging ? 0.3 : 0.2),
                  blurRadius: _isDragging ? 12 : 8,
                  offset: Offset(0, _isDragging ? 6 : 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: _isDragging ? null : () => _openWhatsApp(context),
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              heroTag: widget.heroTag ?? "help_fab_${DateTime.now().millisecondsSinceEpoch}",
              shape: const CircleBorder(),
              elevation: 8, // Increased elevation to ensure it appears above other content
              child: ClipOval(
                child: Image.asset(
                  'assets/customer-service.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 28,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 