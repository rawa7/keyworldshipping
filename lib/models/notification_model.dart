class NotificationModel {
  final int id;
  final int userId;
  final String title;
  final String message;
  final String atitle;  // Arabic title
  final String ktitle;  // Kurdish title
  final String amessage;  // Arabic message
  final String kmessage;  // Kurdish message
  final String type;
  final int isRead;
  final int? transportId;
  final String? itemCode;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.atitle,
    required this.ktitle,
    required this.amessage,
    required this.kmessage,
    required this.type,
    required this.isRead,
    this.transportId,
    this.itemCode,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      atitle: json['atitle'] ?? '',
      ktitle: json['ktitle'] ?? '',
      amessage: json['amessage'] ?? '',
      kmessage: json['kmessage'] ?? '',
      type: json['type'] ?? 'info',
      isRead: json['is_read'] is String ? int.parse(json['is_read']) : json['is_read'],
      transportId: json['transport_id'] != null 
          ? (json['transport_id'] is String ? int.parse(json['transport_id']) : json['transport_id'])
          : null,
      itemCode: json['item_code'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'atitle': atitle,
      'ktitle': ktitle,
      'amessage': amessage,
      'kmessage': kmessage,
      'type': type,
      'is_read': isRead,
      'transport_id': transportId,
      'item_code': itemCode,
      'created_at': createdAt,
    };
  }

  bool get isUnread => isRead == 0;
} 