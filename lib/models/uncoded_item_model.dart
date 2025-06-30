class UncodedItemModel {
  final String id;
  final String itemCode;
  final String image;
  final String weight;
  final String cbm;
  final String description;
  final String createdAt;

  UncodedItemModel({
    required this.id,
    required this.itemCode,
    required this.image,
    required this.weight,
    required this.cbm,
    required this.description,
    required this.createdAt,
  });

  factory UncodedItemModel.fromJson(Map<String, dynamic> json) {
    return UncodedItemModel(
      id: json['id'] as String,
      itemCode: json['item_code'] as String,
      image: json['image'] as String,
      weight: json['weight'] as String,
      cbm: json['cbm'] as String,
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_code': itemCode,
      'image': image,
      'weight': weight,
      'cbm': cbm,
      'description': description,
      'created_at': createdAt,
    };
  }

  // Helper method to get formatted weight
  String getFormattedWeight() {
    return '$weight KG';
  }

  // Helper method to get formatted CBM
  String getFormattedCbm() {
    return '$cbm CBM';
  }
} 