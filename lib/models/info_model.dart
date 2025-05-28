class InfoModel {
  final String id;
  final String title;
  final String atitle;
  final String ktitle;

  InfoModel({
    required this.id,
    required this.title,
    required this.atitle,
    required this.ktitle,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      atitle: json['atitle'] ?? '',
      ktitle: json['ktitle'] ?? '',
    );
  }
} 