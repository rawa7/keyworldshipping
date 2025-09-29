class ShopItemModel {
  final String id;
  final String itemCode;
  final String image1;
  final String image2;
  final String? image3;
  final String? image4;
  final String? image5;
  final String price;
  final String weight;
  final String cbm;
  final String description;
  final String createdAt;

  ShopItemModel({
    required this.id,
    required this.itemCode,
    required this.image1,
    required this.image2,
    this.image3,
    this.image4,
    this.image5,
    required this.price,
    required this.weight,
    required this.cbm,
    required this.description,
    required this.createdAt,
  });

  factory ShopItemModel.fromJson(Map<String, dynamic> json) {
    return ShopItemModel(
      id: json['id'] as String,
      itemCode: json['item_code'] as String? ?? '',
      image1: json['image1'] as String? ?? '',
      image2: json['image2'] as String? ?? '',
      image3: json['image3'] as String?,
      image4: json['image4'] as String?,
      image5: json['image5'] as String?,
      price: json['price'] as String? ?? '0.00',
      weight: json['weight'] as String? ?? '0.00',
      cbm: json['cbm'] as String? ?? '0.0000',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  // Get the primary image (image1)
  String get primaryImage => image1;

  // Get all available images
  List<String> get allImages {
    List<String> images = [image1, image2];
    if (image3 != null && image3!.isNotEmpty) images.add(image3!);
    if (image4 != null && image4!.isNotEmpty) images.add(image4!);
    if (image5 != null && image5!.isNotEmpty) images.add(image5!);
    return images;
  }

  // Get formatted price
  String getFormattedPrice() {
    try {
      double priceValue = double.parse(price);
      return '\$${priceValue.toStringAsFixed(2)}';
    } catch (e) {
      return '\$$price';
    }
  }

  // Get formatted weight
  String getFormattedWeight() {
    try {
      double weightValue = double.parse(weight);
      return '${weightValue.toStringAsFixed(2)} KG';
    } catch (e) {
      return '$weight KG';
    }
  }

  // Get formatted CBM
  String getFormattedCbm() {
    try {
      double cbmValue = double.parse(cbm);
      return '${cbmValue.toStringAsFixed(4)} CBM';
    } catch (e) {
      return '$cbm CBM';
    }
  }
}
