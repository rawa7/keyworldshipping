import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';

class PriceNotificationsScreen extends StatefulWidget {
  const PriceNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<PriceNotificationsScreen> createState() => _PriceNotificationsScreenState();
}

class _PriceNotificationsScreenState extends State<PriceNotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  final AuthService _authService = AuthService();
  
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Load user data first
      final user = await _authService.getLocalUser();
      if (user != null && !_authService.isGuestUser(user)) {
        setState(() {
          _currentUser = user;
        });
        await _loadNotifications();
      } else {
        setState(() {
          _errorMessage = 'Please log in to view notifications';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load user data';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNotifications() async {
    if (_currentUser == null) return;
    
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final notifications = await _notificationService.getNotifications(_currentUser!.id);
      
      if (mounted) {
        setState(() {
          // Filter only price notifications
          _notifications = notifications.where((n) => n.type.toLowerCase() == 'price').toList();
          _isLoading = false;
        });
        
        // Mark all price notifications as read when screen opens
        _markAllPriceNotificationsAsRead();
        
        // Mark global price notifications as locally seen
        _markGlobalPriceNotificationsAsLocallySeen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _markAllPriceNotificationsAsRead() async {
    if (_currentUser == null) return;
    
    try {
      // Get all notifications
      final allNotifications = await _notificationService.getNotifications(_currentUser!.id);
      
      // Filter unread price notifications that are specifically for this user
      // Don't auto-mark global notifications (user_id: -1) as read
      final unreadPriceNotifications = allNotifications
          .where((n) => n.type.toLowerCase() == 'price' && 
                       n.isUnread && 
                       n.userId == _currentUser!.id) // Only mark user-specific notifications
          .toList();
      
      // Mark each as read
      for (final notification in unreadPriceNotifications) {
        await _notificationService.markNotificationAsRead(notification.id);
      }
    } catch (e) {
      print('❌ Error marking price notifications as read: $e');
    }
  }

  Future<void> _markGlobalPriceNotificationsAsLocallySeen() async {
    if (_currentUser == null) return;
    
    try {
      // Get all notifications
      final allNotifications = await _notificationService.getNotifications(_currentUser!.id);
      
      // Mark global price notifications as locally seen
      await _notificationService.markGlobalNotificationsAsLocallySeen(allNotifications, 'price');
    } catch (e) {
      print('❌ Error marking global price notifications as locally seen: $e');
    }
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (notification.isUnread) {
      final success = await _notificationService.markNotificationAsRead(notification.id);
      if (success) {
        // Reload notifications to reflect the change
        await _loadNotifications();
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification marked as read'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Notifications'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.attach_money,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No price notifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up with price updates!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final localizations = AppLocalizations.of(context);
    
    // Get the appropriate title and message based on the current language
    String displayTitle;
    String displayMessage;
    
    if (localizations.locale.languageCode == 'ar') {
      displayTitle = notification.atitle;
      displayMessage = notification.amessage;
    } else if (localizations.locale.languageCode == 'fa') {
      displayTitle = notification.ktitle;
      displayMessage = notification.kmessage;
    } else {
      displayTitle = notification.title;
      displayMessage = notification.message;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isUnread ? Colors.orange : Colors.grey.shade200,
          width: notification.isUnread ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _markAsRead(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(notification.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (notification.isUnread)
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                displayMessage,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 