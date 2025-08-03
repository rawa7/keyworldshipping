class UpdateModel {
  final String currentVersion;
  final String latestVersion;
  final bool isUpdateRequired;
  final bool isUpdateAvailable;
  final String title;
  final String message;
  final String androidUrl;
  final String iosUrl;
  final List<String> features;
  final DateTime releaseDate;
  final String releaseNotes;

  UpdateModel({
    required this.currentVersion,
    required this.latestVersion,
    required this.isUpdateRequired,
    required this.isUpdateAvailable,
    required this.title,
    required this.message,
    required this.androidUrl,
    required this.iosUrl,
    required this.features,
    required this.releaseDate,
    required this.releaseNotes,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json, String currentVersion) {
    final latestVersion = json['latest_version']?.toString() ?? '1.0.0';
    final isUpdateAvailable = _isVersionGreater(latestVersion, currentVersion);
    final isUpdateRequired = json['force_update'] == true || json['is_required'] == true;

    return UpdateModel(
      currentVersion: currentVersion,
      latestVersion: latestVersion,
      isUpdateRequired: isUpdateRequired,
      isUpdateAvailable: isUpdateAvailable,
      title: json['title']?.toString() ?? 'Update Available',
      message: json['message']?.toString() ?? 'A new version of the app is available. Please update to enjoy the latest features and improvements.',
      androidUrl: json['android_url']?.toString() ?? '',
      iosUrl: json['ios_url']?.toString() ?? '',
      features: List<String>.from(json['features'] ?? []),
      releaseDate: DateTime.tryParse(json['release_date']?.toString() ?? '') ?? DateTime.now(),
      releaseNotes: json['release_notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_version': currentVersion,
      'latest_version': latestVersion,
      'is_update_required': isUpdateRequired,
      'is_update_available': isUpdateAvailable,
      'title': title,
      'message': message,
      'android_url': androidUrl,
      'ios_url': iosUrl,
      'features': features,
      'release_date': releaseDate.toIso8601String(),
      'release_notes': releaseNotes,
    };
  }

  /// Compare two version strings and return true if version1 is greater than version2
  static bool _isVersionGreater(String version1, String version2) {
    // Remove any build numbers (e.g., "1.0.1+2" becomes "1.0.1")
    String cleanVersion1 = version1.split('+').first;
    String cleanVersion2 = version2.split('+').first;
    
    List<int> v1Parts = cleanVersion1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> v2Parts = cleanVersion2.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    
    // Ensure both version arrays have the same length
    int maxLength = v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;
    while (v1Parts.length < maxLength) v1Parts.add(0);
    while (v2Parts.length < maxLength) v2Parts.add(0);
    
    for (int i = 0; i < maxLength; i++) {
      if (v1Parts[i] > v2Parts[i]) {
        return true;
      } else if (v1Parts[i] < v2Parts[i]) {
        return false;
      }
    }
    
    return false; // Versions are equal
  }

  /// Get the appropriate store URL based on platform
  String getStoreUrl(bool isAndroid) {
    return isAndroid ? androidUrl : iosUrl;
  }

  /// Check if update should be shown to user
  bool shouldShowUpdate() {
    return isUpdateAvailable && (androidUrl.isNotEmpty || iosUrl.isNotEmpty);
  }

  @override
  String toString() {
    return 'UpdateModel(currentVersion: $currentVersion, latestVersion: $latestVersion, isUpdateRequired: $isUpdateRequired, isUpdateAvailable: $isUpdateAvailable)';
  }
}