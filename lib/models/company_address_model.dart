class CompanyAddressModel {
  final String id;
  final String name;       // English name
  final String aname;      // Arabic name
  final String kname;      // Kurdish name
  final String phone;

  CompanyAddressModel({
    required this.id,
    required this.name,
    required this.aname,
    required this.kname,
    required this.phone,
  });

  factory CompanyAddressModel.fromJson(Map<String, dynamic> json) {
    return CompanyAddressModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      aname: json['aname'] as String? ?? '',
      kname: json['kname'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  // Get localized name based on language code
  String getLocalizedName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return aname.isNotEmpty ? aname : name.isNotEmpty ? name : kname;
      case 'fa': // Kurdish
        return kname.isNotEmpty ? kname : name.isNotEmpty ? name : aname;
      default: // English
        return name.isNotEmpty ? name : aname.isNotEmpty ? aname : kname;
    }
  }
} 