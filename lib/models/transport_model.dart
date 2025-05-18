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
      id: json['id'] as String,
      transportCode: json['transport_code'] as String,
      startDate: json['start_date'] as String,
      arrivalDate: json['arrival_date'] as String,
      itemCodes: json['item_codes'] as String,
      transportTypeId: json['transport_type_id'] as String,
      transportType: json['transport_type'] as String,
      transportTypeAname: json['transport_type_aname'] as String,
      transportTypeKname: json['transport_type_kname'] as String,
      cityId: json['city_id'] as String,
      cityName: json['city_name'] as String,
      cityAname: json['city_aname'] as String,
      cityKname: json['city_kname'] as String ?? '',
      statusId: json['status_id'] as String,
      statusName: json['status_name'] as String,
      statusAname: json['status_aname'] as String ?? '',
      statusKname: json['status_kname'] as String ?? '',
      isActive: json['is_active'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  // Get number of items
  int getItemCount() {
    return itemCodes.split(',').length;
  }
} 