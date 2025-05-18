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
      createdAt: json['created_at'] as String,
    );
  }

  String getFormattedPrice() {
    return '$price\$';
  }
} 