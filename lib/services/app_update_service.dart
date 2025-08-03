import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/update_model.dart';

class AppUpdateService {
  static const String _updateCheckUrl = 'https://keyworldcargo.com/api/app/version-check.php';
  static const String _lastUpdateCheckKey = 'last_update_check';
  static const String _skipVersionKey = 'skip_version_';
  
  // Check for updates every 24 hours
  static const int _checkIntervalHours = 24;

  /// Check if an update is available for the app
  Future<UpdateModel?> checkForUpdate({bool forceCheck = false}) async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      // Check if we should skip this check (rate limiting)
      if (!forceCheck && !await _shouldCheckForUpdate()) {
        return null;
      }

      // Make API request to check for updates
      final updateModel = await _fetchUpdateInfo(currentVersion);
      
      if (updateModel != null) {
        // Store the last check time
        await _storeLastCheckTime();
        return updateModel;
      }

      return null;
    } catch (e) {
      print('❌ Error checking for update: $e');
      return null;
    }
  }

  /// Fetch update information from remote API
  Future<UpdateModel?> _fetchUpdateInfo(String currentVersion) async {
    try {
      // Get device information
      final deviceInfo = DeviceInfoPlugin();
      final platform = Platform.isAndroid ? 'android' : 'ios';
      
      String deviceModel = '';
      String osVersion = '';
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceModel = androidInfo.model;
        osVersion = androidInfo.version.release;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceModel = iosInfo.model;
        osVersion = iosInfo.systemVersion;
      }

      final requestBody = {
        'current_version': currentVersion,
        'platform': platform,
        'device_model': deviceModel,
        'os_version': osVersion,
        'package_name': Platform.isAndroid ? 'com.key.worldship.keyworld' : 'com.keyworld.app',
      };

      final response = await http.post(
        Uri.parse(_updateCheckUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UpdateModel.fromJson(jsonData, currentVersion);
      } else {
        print('❌ Update check failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching update info: $e');
      return null;
    }
  }

  /// Check if we should perform an update check based on timing
  Future<bool> _shouldCheckForUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastCheckTime = prefs.getInt(_lastUpdateCheckKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      final timeDifference = now - lastCheckTime;
      final hoursSinceLastCheck = timeDifference / (1000 * 60 * 60);
      
      return hoursSinceLastCheck >= _checkIntervalHours;
    } catch (e) {
      return true; // If we can't check, assume we should check
    }
  }

  /// Store the timestamp of the last update check
  Future<void> _storeLastCheckTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastUpdateCheckKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('❌ Error storing last check time: $e');
    }
  }

  /// Mark a specific version as skipped by the user
  Future<void> skipVersion(String version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('$_skipVersionKey$version', true);
    } catch (e) {
      print('❌ Error skipping version: $e');
    }
  }

  /// Check if a specific version has been skipped by the user
  Future<bool> isVersionSkipped(String version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('$_skipVersionKey$version') ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Clear all skipped versions (useful for forced updates)
  Future<void> clearSkippedVersions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith(_skipVersionKey));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      print('❌ Error clearing skipped versions: $e');
    }
  }

  /// Get current app version
  Future<String> getCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '1.0.0';
    }
  }

  /// Get current app build number
  Future<String> getBuildNumber() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e) {
      return '1';
    }
  }

  /// Get app package name
  Future<String> getPackageName() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName;
    } catch (e) {
      return '';
    }
  }

  /// Get app name
  Future<String> getAppName() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.appName;
    } catch (e) {
      return 'KeyWorld';
    }
  }
}