class ItemModel {
  final int id;
  final int quantity;
  final String weight;
  final String volume;
  final String code;
  final String image;
  final int transportId;
  final String createdAt;

  ItemModel({
    required this.id,
    required this.quantity,
    required this.weight,
    required this.volume,
    required this.code,
    required this.image,
    required this.transportId,
    required this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      quantity: json['quantity'] is int ? json['quantity'] : int.parse(json['quantity'].toString()),
      weight: json['weight'].toString(),
      volume: json['volume'].toString(),
      code: json['code'] as String,
      image: json['image'].toString(),
      transportId: json['transport_id'] is int ? json['transport_id'] : int.parse(json['transport_id'].toString()),
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'weight': weight,
      'volume': volume,
      'code': code,
      'image': image,
      'transport_id': transportId,
      'created_at': createdAt,
    };
  }
} 