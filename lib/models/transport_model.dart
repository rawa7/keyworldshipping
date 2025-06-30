class TransportModel {
  final String id;
  final String transportCode;
  final String startDate;
  final String arrivalDate;
  final String itemCodes;
  final String transportTypeId;
  final String transportType;
  final String transportTypeAname;
  final String transportTypeKname;
  final String cityId;
  final String cityName;
  final String cityAname;
  final String cityKname;
  final String statusId;
  final String statusName;
  final String statusAname;
  final String statusKname;
  final String isActive;
  final String createdAt;

  TransportModel({
    required this.id,
    required this.transportCode,
    required this.startDate,
    required this.arrivalDate,
    required this.itemCodes,
    required this.transportTypeId,
    required this.transportType,
    required this.transportTypeAname,
    required this.transportTypeKname,
    required this.cityId,
    required this.cityName,
    required this.cityAname,
    required this.cityKname,
    required this.statusId,
    required this.statusName,
    required this.statusAname,
    required this.statusKname,
    required this.isActive,
    required this.createdAt,
  });

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    return TransportModel(
      id: json['id'].toString(),
      transportCode: json['transport_code'] as String,
      startDate: json['start_date'] as String,
      arrivalDate: json['arrival_date'] as String,
      itemCodes: json['item_codes'] as String,
      transportTypeId: json['transport_type_id'].toString(),
      transportType: json['transport_type'] as String? ?? '',
      transportTypeAname: json['transport_type_aname'] as String? ?? '',
      transportTypeKname: json['transport_type_kname'] as String? ?? '',
      cityId: json['city_id'].toString(),
      cityName: json['city_name'] as String? ?? '',
      cityAname: json['city_aname'] as String? ?? '',
      cityKname: json['city_kname'] as String? ?? '',
      statusId: json['status_id'].toString(),
      statusName: json['status_name'] as String? ?? '',
      statusAname: json['status_aname'] as String? ?? '',
      statusKname: json['status_kname'] as String? ?? '',
      isActive: json['is_active'].toString(),
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transport_code': transportCode,
      'start_date': startDate,
      'arrival_date': arrivalDate,
      'item_codes': itemCodes,
      'transport_type_id': transportTypeId,
      'transport_type': transportType,
      'transport_type_aname': transportTypeAname,
      'transport_type_kname': transportTypeKname,
      'city_id': cityId,
      'city_name': cityName,
      'city_aname': cityAname,
      'city_kname': cityKname,
      'status_id': statusId,
      'status_name': statusName,
      'status_aname': statusAname,
      'status_kname': statusKname,
      'is_active': isActive,
      'created_at': createdAt,
    };
  }

  // Get number of items
  int getItemCount() {
    return itemCodes.split(',').length;
  }
} 