import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationService {
  final String baseUrl = 'https://keyworldcargo.com/api';
  static const String _seenGlobalNotificationsKey = 'seen_global_notifications';

  // Get notifications for a user
  Future<List<NotificationModel>> getNotifications(int userId) async {
    try {
      final url = '$baseUrl/get_notifications.php?user_id=$userId';
      print('🔔 Fetching notifications with URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
      );
      
      print('🔔 Get notifications response status: ${response.statusCode}');
      print('🔔 Get notifications response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['notifications'] != null) {
          List<NotificationModel> notifications = [];
          for (var notification in data['notifications']) {
            notifications.add(NotificationModel.fromJson(notification));
          }
          return notifications;
        }
        return [];
      } else {
        throw Exception('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  // Mark notification as read
  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      final url = '$baseUrl/mark_notification_as_complete.php';
      print('✅ Marking notification as read with URL: $url');
      print('✅ Notification ID: $notificationId');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'id': notificationId.toString(),
        },
      );
      
      print('✅ Mark notification response status: ${response.statusCode}');
      print('✅ Mark notification response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      return false;
    }
  }

  // Get unread notification count (all types)
  Future<int> getUnreadCount(int userId) async {
    try {
      final notifications = await getNotifications(userId);
      return notifications.where((n) => n.isUnread).length;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  // Get unread notification count for non-price notifications only
  Future<int> getUnreadNonPriceCount(int userId) async {
    try {
      final notifications = await getNotifications(userId);
      final seenGlobalIds = await _getSeenGlobalNotificationIds();
      return notifications.where((n) => 
        n.isUnread && 
        n.type.toLowerCase() != 'price' &&
        !_isGlobalNotificationSeen(n, seenGlobalIds)
      ).length;
    } catch (e) {
      print('❌ Error getting unread non-price count: $e');
      return 0;
    }
  }

  // Get unread notification count for price notifications only
  Future<int> getUnreadPriceCount(int userId) async {
    try {
      final notifications = await getNotifications(userId);
      final seenGlobalIds = await _getSeenGlobalNotificationIds();
      return notifications.where((n) => 
        n.isUnread && 
        n.type.toLowerCase() == 'price' &&
        !_isGlobalNotificationSeen(n, seenGlobalIds)
      ).length;
    } catch (e) {
      print('❌ Error getting unread price count: $e');
      return 0;
    }
  }

  // Mark all notifications as read for a user
  Future<bool> markAllNotificationsAsRead(int userId) async {
    try {
      // First get all notifications for the user
      final notifications = await getNotifications(userId);
      final unreadNotifications = notifications.where((n) => n.isUnread).toList();
      
      if (unreadNotifications.isEmpty) {
        return true; // No unread notifications to mark
      }
      
      // Mark each unread notification as read
      bool allSuccess = true;
      for (final notification in unreadNotifications) {
        final success = await markNotificationAsRead(notification.id);
        if (!success) {
          allSuccess = false;
        }
      }
      
      return allSuccess;
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
      return false;
    }
  }

  // Mark global notifications as locally seen (for notifications with userId = -1)
  Future<void> markGlobalNotificationsAsLocallySeen(List<NotificationModel> notifications, String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seenIds = await _getSeenGlobalNotificationIds();
      
      // Add global notifications of the specified type to the seen list
      for (final notification in notifications) {
        if (notification.userId == -1 && 
            notification.type.toLowerCase() == type.toLowerCase() && 
            notification.isUnread) {
          seenIds.add(notification.id);
        }
      }
      
      // Save back to local storage
      await prefs.setStringList(_seenGlobalNotificationsKey, seenIds.map((id) => id.toString()).toList());
      print('✅ Marked ${type} global notifications as locally seen');
    } catch (e) {
      print('❌ Error marking global notifications as locally seen: $e');
    }
  }

  // Get locally seen global notification IDs
  Future<Set<int>> _getSeenGlobalNotificationIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final seenStringIds = prefs.getStringList(_seenGlobalNotificationsKey) ?? [];
      return seenStringIds.map((id) => int.parse(id)).toSet();
    } catch (e) {
      print('❌ Error getting seen global notification IDs: $e');
      return <int>{};
    }
  }

  // Check if a global notification has been locally seen
  bool _isGlobalNotificationSeen(NotificationModel notification, Set<int> seenGlobalIds) {
    // If it's not a global notification (userId != -1), it's not locally seen
    if (notification.userId != -1) {
      return false;
    }
    
    // If it's a global notification, check if it's in the seen list
    return seenGlobalIds.contains(notification.id);
  }

  // Clear locally seen global notifications (useful for testing or reset)
  Future<void> clearLocallySeenGlobalNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_seenGlobalNotificationsKey);
      print('✅ Cleared locally seen global notifications');
    } catch (e) {
      print('❌ Error clearing locally seen global notifications: $e');
    }
  }
} 