class StoryModel {
  final String id;
  final String userId;
  final String mediaUrl;
  final String mediaType;
  final String caption;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;

  StoryModel({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.mediaType,
    required this.caption,
    required this.createdAt,
    this.expiresAt,
    required this.isActive,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      mediaUrl: json['media_url'] ?? '',
      mediaType: json['media_type'] ?? 'image',
      caption: json['caption'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      isActive: json['is_active'] == '1' || json['is_active'] == true,
    );
  }

  // Check if story is still valid (not expired)
  bool get isValid {
    if (!isActive) return false;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }

  // Get full media URL
  String get fullMediaUrl {
    if (mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return 'https://keyworldcargo.com/uploads/stories/$mediaUrl';
  }
} 