class TutorialModel {
  final String id;
  final String title;
  final String videoUrl;
  final String note;
  final String coverimg;
  final String image;
  final String? language;

  // Address fields
  final String? firstName;
  final String? familyName;
  final String? place;
  final String? state;
  final String? city;
  final String? district;
  final String? street;
  final String? addressLine1;
  final String? addressLine2;
  final String? zipCode;
  final String? phone1;
  final String? phone2;
  final String? longaddress;
  final String? addressNote;
  final String? addressTitle;

  TutorialModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.note,
    required this.coverimg,
    required this.image,
    this.language,
    this.firstName,
    this.familyName,
    this.place,
    this.state,
    this.city,
    this.district,
    this.street,
    this.addressLine1,
    this.addressLine2,
    this.zipCode,
    this.phone1,
    this.phone2,
    this.longaddress,
    this.addressNote,
    this.addressTitle,
  });

  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    // Parse nested address object
    final addressData = json['address'] as Map<String, dynamic>?;
    
    return TutorialModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      videoUrl: (json['vedio_url'] ?? json['video_url'])?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      coverimg: json['coverimg']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      language: json['language']?.toString() ?? 'en',
      
      // Parse address fields from nested address object
      firstName: addressData?['first_name']?.toString(),
      familyName: addressData?['family_name']?.toString(),
      place: addressData?['place']?.toString(),
      state: addressData?['state']?.toString(),
      city: addressData?['city']?.toString(),
      district: addressData?['district']?.toString(),
      street: addressData?['street']?.toString(),
      addressLine1: addressData?['address_line1']?.toString(),
      addressLine2: addressData?['address_line2']?.toString(),
      zipCode: addressData?['zip_code']?.toString(),
      phone1: addressData?['phone1']?.toString(),
      phone2: addressData?['phone2']?.toString(),
      longaddress: addressData?['longaddress']?.toString(),
      addressNote: addressData?['note']?.toString(),
      addressTitle: addressData?['title']?.toString(),
    );
  }

  String getYoutubeVideoId() {
    // Extract YouTube video ID from URL
    RegExp regExp = RegExp(
      r'.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    if (videoUrl.isNotEmpty) {
      final match = regExp.firstMatch(videoUrl);
      if (match != null && match.groupCount >= 1) {
        return match.group(1)!;
      }
    }
    return '';
  }

  String getCoverImageUrl() {
    if (image.isNotEmpty && image != 'https://keyworldcargo.com/') {
      // Fix double slashes in URL
      String cleanUrl = image.replaceAll(r'\\', '');
      cleanUrl = cleanUrl.replaceAll('//', '/');
      if (cleanUrl.startsWith('https:/')) {
        cleanUrl = 'https://' + cleanUrl.substring(7);
      }
      return cleanUrl;
    }
    return '';
  }

  String get fullName => '${firstName ?? ''} ${familyName ?? ''}'.trim();
  
  String get fullAddress {
    List<String> addressParts = [];
    if (addressLine1?.isNotEmpty == true) addressParts.add(addressLine1!);
    if (street?.isNotEmpty == true) addressParts.add(street!);
    if (city?.isNotEmpty == true) addressParts.add(city!);
    if (state?.isNotEmpty == true) addressParts.add(state!);
    if (zipCode?.isNotEmpty == true) addressParts.add(zipCode!);
    return addressParts.join(', ');
  }
  
  String get primaryPhone => phone1?.isNotEmpty == true ? phone1! : (phone2 ?? '');
  
  bool get hasAddressInfo => 
    firstName?.isNotEmpty == true || 
    addressLine1?.isNotEmpty == true || 
    phone1?.isNotEmpty == true;
} 