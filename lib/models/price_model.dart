class PriceModel {
  final String id;
  final String cityId;
  final String cityEn;
  final String cityAr;
  final String cityKu;
  final String transportTypeId;
  final String transportEn;
  final String transportAr;
  final String transportKu;
  final String price;
  final String? note;
  final String? anote;
  final String? knote;
  final String createdAt;

  PriceModel({
    required this.id,
    required this.cityId,
    required this.cityEn,
    required this.cityAr,
    required this.cityKu,
    required this.transportTypeId,
    required this.transportEn,
    required this.transportAr,
    required this.transportKu,
    required this.price,
    this.note,
    this.anote,
    this.knote,
    required this.createdAt,
  });

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      id: json['id'] as String,
      cityId: json['city_id'] as String,
      cityEn: json['city_en'] as String,
      cityAr: json['city_ar'] as String,
      cityKu: json['city_ku'] as String,
      transportTypeId: json['transport_type_id'] as String,
      transportEn: json['transport_en'] as String,
      transportAr: json['transport_ar'] as String,
      transportKu: json['transport_ku'] as String,
      price: json['price'] as String,
      note: json['note'] as String?,
      anote: json['anote'] as String?,
      knote: json['knote'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  String getFormattedPrice() {
    return '$price\$';
  }

  // Helper method to get localized note based on language
  String getLocalizedNote(String languageCode, String fallbackText) {
    switch (languageCode) {
      case 'ar':
        return anote?.isNotEmpty == true 
            ? anote! 
            : (note?.isNotEmpty == true ? note! : fallbackText);
      case 'fa':
        return knote?.isNotEmpty == true 
            ? knote! 
            : (note?.isNotEmpty == true ? note! : fallbackText);
      default: // 'en'
        return note?.isNotEmpty == true ? note! : fallbackText;
    }
  }
} 