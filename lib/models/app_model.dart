class AppModel {
  final String id;
  final String name;
  final String icon;
  final String description;

  AppModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  factory AppModel.fromJson(Map<String, dynamic> json) {
    return AppModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
    );
  }
  
  String getIconUrl() {
    if (icon.isNotEmpty) {
      // Fix double slashes in URL
      String cleanUrl = icon.replaceAll(r'\\', '');
      cleanUrl = cleanUrl.replaceAll('//', '/');
      if (cleanUrl.startsWith('https:/')) {
        cleanUrl = 'https://' + cleanUrl.substring(7);
      }
      return cleanUrl;
    }
    return '';
  }
} 