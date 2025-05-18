class BannerModel {
  final String id;
  final String image;
  final String link;
  final String position;

  BannerModel({
    required this.id,
    required this.image,
    required this.link,
    required this.position,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      image: json['image'] as String,
      link: json['link'] as String,
      position: json['position'] as String,
    );
  }
} 