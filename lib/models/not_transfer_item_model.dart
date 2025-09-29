class NotTransferItemModel {
  final String id;
  final String itemType;
  final String itemExample;
  final String itemTypeKu;
  final String itemExampleKu;
  final String itemTypeAr;
  final String itemExampleAr;

  NotTransferItemModel({
    required this.id,
    required this.itemType,
    required this.itemExample,
    required this.itemTypeKu,
    required this.itemExampleKu,
    required this.itemTypeAr,
    required this.itemExampleAr,
  });

  factory NotTransferItemModel.fromJson(Map<String, dynamic> json) {
    return NotTransferItemModel(
      id: json['id'] as String,
      itemType: json['item_type'] as String? ?? '',
      itemExample: json['item_example'] as String? ?? '',
      itemTypeKu: json['item_type_ku'] as String? ?? '',
      itemExampleKu: json['item_example_ku'] as String? ?? '',
      itemTypeAr: json['item_type_ar'] as String? ?? '',
      itemExampleAr: json['item_example_ar'] as String? ?? '',
    );
  }

  // Get localized item type based on language
  String getLocalizedItemType(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return itemTypeAr.isNotEmpty ? itemTypeAr : (itemType.isNotEmpty ? itemType : itemTypeKu);
      case 'fa':
        return itemTypeKu.isNotEmpty ? itemTypeKu : (itemType.isNotEmpty ? itemType : itemTypeAr);
      default: // 'en'
        return itemType.isNotEmpty ? itemType : (itemTypeAr.isNotEmpty ? itemTypeAr : itemTypeKu);
    }
  }

  // Get localized item example based on language
  String getLocalizedItemExample(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return itemExampleAr.isNotEmpty ? itemExampleAr : (itemExample.isNotEmpty ? itemExample : itemExampleKu);
      case 'fa':
        return itemExampleKu.isNotEmpty ? itemExampleKu : (itemExample.isNotEmpty ? itemExample : itemExampleAr);
      default: // 'en'
        return itemExample.isNotEmpty ? itemExample : (itemExampleAr.isNotEmpty ? itemExampleAr : itemExampleKu);
    }
  }
}
