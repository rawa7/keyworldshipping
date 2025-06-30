class AddressModel {
  final String id;
  final String firstName;
  final String familyName;
  final String place;
  final String state;
  final String city;
  final String street;
  final String addressLine1;
  final String addressLine2;
  final String zipCode;
  final String phone1;
  final String phone2;
  final String isActive;
  final String createdAt;
  final String? note;
  final String? longaddress;
  final String? title;
  final String? titleAname;
  final String? titleKname; 
  final String? district;

  AddressModel({
    required this.id,
    required this.firstName,
    required this.familyName,
    required this.place,
    required this.state,
    required this.city,
    required this.street,
    required this.addressLine1,
    required this.addressLine2,
    required this.zipCode,
    required this.phone1,
    required this.phone2,
    required this.isActive,
    required this.createdAt,
    this.note,
    this.longaddress,
    this.title,
    this.titleAname,
    this.titleKname,
    this.district,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      familyName: json['family_name'] as String,
      place: json['place'] as String? ?? '',
      state: json['state'] as String,
      city: json['city'] as String,
      street: json['street'] as String,
      addressLine1: json['address_line1'] as String,
      addressLine2: json['address_line2'] as String? ?? '',
      zipCode: json['zip_code'] as String,
      phone1: json['phone1'] as String,
      phone2: json['phone2'] as String? ?? '',
      isActive: json['is_active'] as String,
      createdAt: json['created_at'] as String,
      note: json['note'] as String?,
      longaddress: json['longaddress'] as String?,
      title: json['title'] as String?,
      titleAname: json['title_aname'] as String?,
      titleKname: json['title_kname'] as String?,
      district: json['district'] as String?,
      );
  }

  String get fullName => '$firstName $familyName'.trim();
  
  String get fullAddress {
    List<String> addressParts = [];
    if (addressLine1.isNotEmpty) addressParts.add(addressLine1);
    if (street.isNotEmpty) addressParts.add(street);
    if (city.isNotEmpty) addressParts.add(city);
    if (state.isNotEmpty) addressParts.add(state);
    if (zipCode.isNotEmpty) addressParts.add(zipCode);
    return addressParts.join(', ');
  }
  
  String get primaryPhone => phone1.isNotEmpty ? phone1 : phone2;
}

// New model for the address2 API response
class Address2Model {
  final String id;
  final String longaddress;
  final String title;
  final String atitle;
  final String ktitle;
  final String note;
  final String anote;
  final String knote;
  final String isActive;

  Address2Model({
    required this.id,
    required this.longaddress,
    required this.title,
    required this.atitle,
    required this.ktitle,
    required this.note,
    required this.anote,
    required this.knote,
    required this.isActive,
  });

  factory Address2Model.fromJson(Map<String, dynamic> json) {
    return Address2Model(
      id: json['id'] as String,
      longaddress: json['longaddress'] as String,
      title: json['title'] as String,
      atitle: json['atitle'] as String,
      ktitle: json['ktitle'] as String,
      note: json['note'] as String,
      anote: json['anote'] as String,
      knote: json['knote'] as String,
      isActive: json['is_active'] as String,
    );
  }

  // Process the long address by replacing *c* with customer code
  String processLongAddress(String customerCode) {
    return longaddress.replaceAll('*c*', customerCode);
  }

  // Get title based on language
  String getTitleByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'ar':
        return atitle;
      case 'ku':
        return ktitle;
      default:
        return title;
    }
  }

  // Get note based on language
  String getNoteByLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'ar':
        return anote;
      case 'ku':
        return knote;
      default:
        return note;
    }
  }
} 