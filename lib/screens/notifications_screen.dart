import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../services/notification_service.dart';
import '../services/auth_service.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
          // Filter out price notifications - they should only appear in price notifications screen
          _notifications = notifications.where((n) => n.type.toLowerCase() != 'price').toList();
          _isLoading = false;
        });
        
        // Mark all non-price notifications as read when screen opens
        _markAllNonPriceNotificationsAsRead();
        
        // Mark global non-price notifications as locally seen
        _markGlobalNotificationsAsLocallySeen();
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

  Future<void> _markAllNonPriceNotificationsAsRead() async {
    if (_currentUser == null) return;
    
    try {
      // Get all notifications
      final allNotifications = await _notificationService.getNotifications(_currentUser!.id);
      
      // Filter unread non-price notifications that are specifically for this user
      // Don't auto-mark global notifications (user_id: -1) as read
      final unreadNonPriceNotifications = allNotifications
          .where((n) => n.type.toLowerCase() != 'price' && 
                       n.isUnread && 
                       n.userId == _currentUser!.id) // Only mark user-specific notifications
          .toList();
      
      // Mark each as read
      for (final notification in unreadNonPriceNotifications) {
        await _notificationService.markNotificationAsRead(notification.id);
      }
    } catch (e) {
      print('❌ Error marking non-price notifications as read: $e');
    }
  }

  Future<void> _markGlobalNotificationsAsLocallySeen() async {
    if (_currentUser == null) return;
    
    try {
      // Get all notifications
      final allNotifications = await _notificationService.getNotifications(_currentUser!.id);
      
      // Mark global non-price notifications as locally seen
      await _notificationService.markGlobalNotificationsAsLocallySeen(allNotifications, 'info');
    } catch (e) {
      print('❌ Error marking global notifications as locally seen: $e');
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'price':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      case 'warning':
        return Colors.amber;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'price':
        return Icons.attach_money;
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
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
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
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
    final typeColor = _getTypeColor(notification.type);
    final typeIcon = _getTypeIcon(notification.type);
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
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: notification.isUnread
            ? Border.all(color: Colors.red, width: 2)
            : null,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      typeIcon,
                      color: typeColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                displayTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: notification.isUnread 
                                      ? FontWeight.bold 
                                      : FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (notification.isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              _formatDate(notification.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            if (notification.itemCode != null) ...[
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  notification.itemCode!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
} 