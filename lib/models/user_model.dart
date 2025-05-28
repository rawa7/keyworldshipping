class UserModel {
  final int id;
  final String name;
  final String aname; // Arabic name
  final String kname; // Kurdish name
  final String email;
  final String role;
  final int isActive;
  final String createdAt;
  final String updatedAt;
  final String username;
  final String phone;
  final String city;

  UserModel({
    required this.id,
    required this.name,
    this.aname = '',
    this.kname = '',
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.phone,
    this.city = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '',
      aname: json['aname'] ?? '',
      kname: json['kname'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['is_active'] is String 
          ? int.parse(json['is_active']) 
          : json['is_active'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'aname': aname,
      'kname': kname,
      'email': email,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'username': username,
      'phone': phone,
      'city': city,
    };
  }
} 