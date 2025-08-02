import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  // Helper method to keep the code in the widgets concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
  
  // Static member to have access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
  
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'appTitle': 'Key World',
      'loading': 'Loading...',
      'retry': 'Retry',
      'noData': 'No data available',
      'cancel': 'Cancel',
      'close': 'Close',
      'save': 'Save',
      'submit': 'Submit',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'error': 'Error',
      'success': 'Success',
      'welcome': 'Welcome',
      'exitApp': 'Exit App',
      'exitAppMessage': 'Are you sure you want to exit the app?',
      'exit': 'Exit',
      
      // Navigation
      'home': 'Home',
      'profile': 'PROFILE',
      'inventory': 'Inventory',
      'prices': 'Prices',
      'list': 'LIST',
      
      // List Screen Items
      'transportationFees': 'TRANSPORTATION FEES',
      'addresses': 'ADDRESSES',
      'shippingAddresses': 'SHIPPING ADDRESSES',
      'uncodedGoods': 'UNCODED GOODS',
      'chineseCompanies': 'CHINESE COMPANIES',
      
      // Common UI Text
      'notProvided': 'Not provided',
      'copiedToClipboard': 'copied to clipboard',
      'copy': 'Copy',
      'tapToView': 'Tap to view',
      'fullName': 'Full Name',
      'primaryPhone': 'Primary Phone',
      'secondaryPhone': 'Secondary Phone',
      'fullAddress': 'Full Address',
      
      // Loading and Error Messages
      'loadingTransportationFees': 'Loading transportation fees...',
      'loadingAddresses': 'Loading addresses...',
      'loadingUncodedGoods': 'Loading uncoded goods...',
      'loadingChineseCompanies': 'Loading Chinese companies...',
      'errorLoadingUncodedGoods': 'Error loading uncoded goods',
      'errorLoadingChineseCompanies': 'Error loading Chinese companies',
      'noUncodedGoodsAvailable': 'No uncoded goods available',
      'noChineseCompaniesAvailable': 'No Chinese companies available',
      'noDescriptionAvailable': 'No description available',
      'imageNotAvailable': 'Image not available',
      'loadingImage': 'Loading image...',
      
      // Transport Info
      'toErbil': 'TO ERBIL',
      'airFreight': 'Air Freight',
      'seaFreight': 'Sea Freight',
      'landFreight': 'Land Freight',
      
      // Account & Profile
      'account': 'ACCOUNT',
      'accountName': 'Account Name',
      'username': 'Username',
      'phoneNumber': 'Phone Number',
      'accountType': 'Account Type',
      'standard': 'Standard',
      'accountInfo': 'Account Info',
      'accountStatement': 'Account Statement',
      'languageSettings': 'Language Settings',
      'logoutConfirmation': 'Logout Confirmation',
      'logoutConfirmationMessage': 'Are you sure you want to logout?',
      'logout': 'Logout',
      'guestUser': 'Guest User',
      'noUsername': 'No username',
      'currentBalance': 'Current Balance',
      'transactionHistory': 'Transaction History',
      'availableBalance': 'Available balance',
      'youOweThisAmount': 'You owe this amount',
      'noTransactionsFound': 'No transactions found',
      
      // Auth
      'login': 'Login',
      'register': 'Register',
      'forgotPassword': 'Forgot Password?',
      'createAccount': 'Create Account',
      'alreadyHaveAccount': 'Already have an account?',
      'dontHaveAccount': 'Don\'t have an account?',
      'signUp': 'Sign Up',
      'signIn': 'Sign In',
      'enterPhone': 'Enter phone number',
      'enterCode': 'Enter verification code',
      'sendCode': 'Send Code',
      'resendCode': 'Resend Code',
      'verifyCode': 'Verify Code',
      'phoneVerification': 'Phone Verification',
      'weWillSendCode': 'We will send a verification code to your phone',
      'enterCodeSent': 'Enter the code sent to your phone',
      
      // About & Contact
      'aboutUs': 'About Us',
      'contactUs': 'Contact Us',
      'privacyInfo': 'Privacy Information',
      'ourStory': 'Our Story',
      'ourMission': 'Our Mission',
      'getInTouch': 'Get in Touch',
      'sendMessage': 'Send Message',
      'yourName': 'Your Name',
      'email': 'Email',
      'message': 'Message',
      'address': 'Address',
      'phoneContact': 'Phone',
      
      // Price List
      'priceList': 'Price List',
      'category': 'Category',
      'item': 'Item',
      'price': 'Price',
      'currency': 'USD',
      'viewDetails': 'View Details',
      'lastUpdated': 'Last Updated',
      
      // Transportation Fee Table Headers
      'note': 'Note',
      'receivedCountry': 'Received Country',
      
      // Transports
      'transports': 'Transports',
      'transport': 'Transport',
      'transportType': 'Transport Type',
      'transportDetails': 'Transport Details',
      'distance': 'Distance',
      'duration': 'Duration',
      'startLocation': 'Start Location',
      'endLocation': 'End Location',
      'bookTransport': 'Book Transport',
      'transportHistory': 'Transport History',
      'status': 'Status',
      'enterTruckNumber': 'ENTER TRUCK NUMBER...',
      'searchTransport': 'Search Transport',
      'loadingTransports': 'Loading transports...',
      'failedToLoadTransports': 'Failed to load transports',
      'noTransportsAvailable': 'No transports available',
      
      // Search & Items
      'searchResult': 'Search Result',
      'itemDetails': 'Item Details',
      'itemInformation': 'Item Information',
      'transportInformation': 'Transport Information',
      'codeNotFound': 'Code Not Found',
      'codeNotFoundMessage': 'The code you searched for was not found in our transport or item records. Please check the code and try again.',
      'suggestions': 'Suggestions',
      'checkSpelling': 'Check the spelling of your code',
      'removeSpaces': 'Remove any extra spaces',
      'checkFormat': 'Ensure the code format is correct',
      'contactSupport': 'Contact customer support if you need help',
      'goBack': 'Go Back',
      'searchAgain': 'Search Again',
      
      // Tutorials
      'tutorials': 'Tutorials',
      'tutorial': 'Tutorial',
      'tutorialDetails': 'Tutorial Details',
      'steps': 'Steps',
      'watchVideo': 'Watch Video',
      'readMore': 'Read More',
      
      // Home Screen
      'loadingUpdates': 'Loading updates...',
      'failedToLoadUpdates': 'Failed to load updates',
      'noUpdatesAvailable': 'No updates available',
      'failedToLoadBanners': 'Failed to load banners',
      
      // Stories
      'loadingStories': 'Loading stories...',
      'failedToLoadStories': 'Failed to load stories',
      'noStoriesAvailable': 'No stories available',
      
      // Transport Detail Screen
      'trackingDetails': 'Tracking Details',
      'shippingMethod': 'Shipping Method',
      'shippingRoute': 'Shipping Route',
      'timeline': 'Timeline',
      'statusDescription': 'Status Description',
      'origin': 'Origin',
      'destination': 'Destination',
      
      // Address Detail Screen
      'personalInfo': 'Personal Information',
      'contactInfo': 'Contact Information',
      'addressInfo': 'Address Information',
      'phoneNumbers': 'Phone Numbers',
      'emails': 'Emails',
      'notes': 'Notes',
      'additionalInfo': 'Additional Information',
      'country': 'Country',
      'state': 'State',
      'city': 'City',
      'zipCode': 'ZIP Code',
      'copyPhone': 'Copy Phone',
      'copyEmail': 'Copy Email',
      'copyAddress': 'Copy Address',
      
      // Uncoded Item Detail Screen
      'itemCode': 'Item Code',
      'itemName': 'Item Name',
      'description': 'Description',
      'weight': 'Weight',
      'dimensions': 'Dimensions',
      'value': 'Value',
      'addedDate': 'Added Date',
      'lastModified': 'Last Modified',
      'itemImage': 'Item Image',
      'tapToEnlarge': 'Tap to enlarge',
      'kg': 'kg',
      'cm': 'cm',
      'usd': 'USD',
      'uncoded': 'Uncoded',
      
      // Chinese Companies Screen
      'companyInfo': 'Company Information',
      'openingApp': 'Opening',
      'noAppsFound': 'No apps found',
      'refreshing': 'Refreshing...',
      'company': 'Company',
      'application': 'Application',
      'retry': 'Retry',
      
      // Item Detail Screen - Additional Keys
      'quantity': 'Quantity',
      'volume': 'Volume',
      'addedOn': 'Added on',
      'transportCode': 'Transport Code',
      'startDate': 'Start Date',
      'arrivalDate': 'Arrival Date',
      'totalItems': 'Total Items',
      'failedToLoad': 'Failed to load',
      'noImageAvailable': 'No Image Available',
      'loadingImage': 'Loading image...',
      
      // Status labels
      'delivered': 'Delivered',
      'completed': 'Completed',
      'inTransit': 'In Transit',
      'shipping': 'Shipping',
      'pending': 'Pending',
      'waiting': 'Waiting',
      'cancelled': 'Cancelled',
      'failed': 'Failed',
      
      // Login Screen
      'welcomeToKeyWorld': 'Welcome to KeyWorld',
      'enterPhoneToLogin': 'Please enter your phone number to login',
      'enterPhoneNumber': 'Enter phone number',
      'invalidPhone': 'Please enter a valid phone number',
      'continueAsGuest': 'Continue as Guest',
      'notRegistered': 'You are not registered',
      'createYourAccount': 'Create Your Account',
      'fillDetails': 'Please fill in your details to create an account',
      'firstName': 'First Name',
      'enterFirstName': 'Enter first name',
      'lastName': 'Last Name',
      'enterLastName': 'Enter last name',
      'selectCity': 'Select your cit and street',
      'haveUsername': 'I have a username',
      'enterUsername': 'Enter username (must start with H.E)',
      'usernameRequired': 'Please enter username',
      'usernameFormat': 'Username must start with H.E',
      'accountCreated': 'Account created successfully!',
      'userExists': 'A user with this phone number already exists. Please try logging in instead.',
      'alreadyHaveAccount': 'Already have an account? Login',
    },
    'ar': {
      // General
      'appTitle': 'Key World ',
      'loading': 'جاري التحميل...',
      'retry': 'إعادة المحاولة',
      'noData': 'لا توجد بيانات متاحة',
      'cancel': 'إلغاء',
      'close': 'إغلاق',
      'save': 'حفظ',
      'submit': 'إرسال',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'error': 'خطأ',
      'success': 'نجاح',
      'welcome': 'مرحبا',
      'exitApp': 'إغلاق التطبيق',
      'exitAppMessage': 'هل أنت متأكد أنك تريد إغلاق التطبيق؟',
      'exit': 'إغلاق',
      
      // Navigation
      'home': 'الرئيسية',
      'profile': 'الملف الشخصي',
      'inventory': 'المخزون',
      'prices': 'الأسعار',
      'list': 'القائمة',
      
      // List Screen Items
      'transportationFees': 'رسوم النقل',
      'addresses': 'العنوان',
      'shippingAddresses': 'عناوين الشحن',
      'uncodedGoods': 'بضائع بدون اسم و الكود',
      'chineseCompanies': 'الشركات الصينية',
      
      // Common UI Text
      'notProvided': 'لم تقدم',
      'copiedToClipboard': 'تم النسخ إلى الملف الخاص',
      'copy': 'نسخ',
      'tapToView': 'اضغط لعرض',
      'fullName': 'الاسم الكامل',
      'primaryPhone': 'الهاتف الرئيسي',
      'secondaryPhone': 'الهاتف الثانوي',
      'fullAddress': 'العنوان الكامل',
      
      // Loading and Error Messages
      'loadingTransportationFees': 'جاري تحميل رسوم النقل...',
      'loadingAddresses': 'جاري تحميل العنوان...',
      'loadingUncodedGoods': 'جاري تحميل البضائع غير المعبرة...',
      'loadingChineseCompanies': 'جاري تحميل الشركات الصينية...',
      'errorLoadingUncodedGoods': 'خطأ في تحميل البضائع غير المعبرة',
      'errorLoadingChineseCompanies': 'خطأ في تحميل الشركات الصينية',
      'noUncodedGoodsAvailable': 'لا توجد بضائع غير معبرة متاحة',
      'noChineseCompaniesAvailable': 'لا توجد شركات صينية متاحة',
      'noDescriptionAvailable': 'لا توجد وصف متاح',
      'imageNotAvailable': 'الصورة غير متاحة',
      'loadingImage': 'جاري تحميل الصورة...',
      
      // Transport Info
      'toErbil': 'إلى الأربيل',
      'airFreight': 'الشحن الجوي',
      'seaFreight': 'الشحن البحري',
      'landFreight': 'الشحن البري',
      
      // Account & Profile
      'account': 'الحساب',
      'accountName': 'اسم الحساب',
      'username': 'اسم المستخدم',
      'phoneNumber': 'رقم الهاتف',
      'accountType': 'نوع الحساب',
      'standard': 'قياسي',
      'accountInfo': 'معلومات الحساب',
      'accountStatement': 'كشف الحساب',
      'languageSettings': 'إعدادات اللغة',
      'logoutConfirmation': 'تأكيد تسجيل الخروج',
      'logoutConfirmationMessage': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'logout': 'تسجيل الخروج',
      'guestUser': 'مستخدم زائر',
      'noUsername': 'لا يوجد اسم مستخدم',
      'currentBalance': 'الرصيد الحالي',
      'transactionHistory': 'سجل المعاملات',
      'availableBalance': 'الرصيد المتاح',
      'youOweThisAmount': 'أنت مدين بهذا المبلغ',
      'noTransactionsFound': 'لم يتم العثور على معاملات',
      
      // Auth
      'login': 'تسجيل الدخول',
      'register': 'التسجيل',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'createAccount': 'إنشاء حساب',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟',
      'dontHaveAccount': 'ليس لديك حساب؟',
      'signUp': 'التسجيل',
      'signIn': 'تسجيل الدخول',
      'enterPhone': 'أدخل رقم الهاتف',
      'enterCode': 'أدخل رمز التحقق',
      'sendCode': 'إرسال الرمز',
      'resendCode': 'إعادة إرسال الرمز',
      'verifyCode': 'التحقق من الرمز',
      'phoneVerification': 'التحقق من الهاتف',
      'weWillSendCode': 'سنرسل رمز التحقق إلى هاتفك',
      'enterCodeSent': 'أدخل الرمز المرسل إلى هاتفك',
      
      // About & Contact
      'aboutUs': 'من نحن',
      'contactUs': 'اتصل بنا',
      'privacyInfo': 'معلومات الخصوصية',
      'ourStory': 'قصتنا',
      'ourMission': 'مهمتنا',
      'getInTouch': 'تواصل معنا',
      'sendMessage': 'إرسال رسالة',
      'yourName': 'اسمك',
      'email': 'البريد الإلكتروني',
      'message': 'الرسالة',
      'address': 'العنوان',
      'phoneContact': 'الهاتف',
      
      // Price List
      'priceList': 'قائمة الأسعار',
      'category': 'الفئة',
      'item': 'العنصر',
      'price': 'السعر',
      'currency': 'دولار',
      'viewDetails': 'عرض التفاصيل',
      'lastUpdated': 'آخر تحديث',
      
      // Transportation Fee Table Headers
      'note': 'ملاحظة',
      'receivedCountry': 'البلد المستلم',
      
      // Transports
      'transports': 'وسائل النقل',
      'transport': 'النقل',
      'transportType': 'نوع النقل',
      'transportDetails': 'تفاصيل النقل',
      'distance': 'المسافة',
      'duration': 'المدة',
      'startLocation': 'موقع البداية',
      'endLocation': 'موقع النهاية',
      'bookTransport': 'حجز النقل',
      'transportHistory': 'سجل النقل',
      'status': 'الحالة',
      'enterTruckNumber': 'أدخل رقم الشاحنة...',
      'searchTransport': 'بحث عن النقل',
      'loadingTransports': 'جاري تحميل وسائل النقل...',
      'failedToLoadTransports': 'فشل في تحميل وسائل النقل',
      'noTransportsAvailable': 'لا توجد وسائل نقل متاحة',
      
      // Search & Items
      'searchResult': 'نتيجة البحث',
      'itemDetails': 'تفاصيل العنصر',
      'itemInformation': 'معلومات العنصر',
      'transportInformation': 'معلومات النقل',
      'codeNotFound': 'الرمز غير موجود',
      'codeNotFoundMessage': 'الرمز الذي بحثت عنه غير موجود في سجلات النقل أو العناصر. يرجى التحقق من الرمز والمحاولة مرة أخرى.',
      'suggestions': 'اقتراحات',
      'checkSpelling': 'تحقق من إملاء الرمز',
      'removeSpaces': 'إزالة أي مسافات إضافية',
      'checkFormat': 'تأكد من صحة تنسيق الرمز',
      'contactSupport': 'اتصل بدعم العملاء إذا كنت بحاجة إلى مساعدة',
      'goBack': 'العودة',
      'searchAgain': 'البحث مرة أخرى',
      
      // Tutorials
      'tutorials': 'الدروس التعليمية',
      'tutorial': 'درس تعليمي',
      'tutorialDetails': 'تفاصيل الدرس التعليمي',
      'steps': 'الخطوات',
      'watchVideo': 'مشاهدة الفيديو',
      'readMore': 'قراءة المزيد',
      
      // Home Screen
      'loadingUpdates': 'جاري تحميل التحديثات...',
      'failedToLoadUpdates': 'فشل في تحميل التحديثات',
      'noUpdatesAvailable': 'لا توجد تحديثات متاحة',
      'failedToLoadBanners': 'فشل في تحميل البانرات',
      
      // Stories
      'loadingStories': 'جاري تحميل القصص...',
      'failedToLoadStories': 'فشل في تحميل القصص',
      'noStoriesAvailable': 'لا توجد قصص متاحة',
      
      // Transport Detail Screen
      'trackingDetails': 'تفاصيل التتبع',
      'shippingMethod': 'طريقة الشحن',
      'shippingRoute': 'مسار الشحن',
      'timeline': 'الجدول الزمني',
      'statusDescription': 'وصف الحالة',
      'origin': 'المنشأ',
      'destination': 'الوجهة',
      
      // Address Detail Screen
      'personalInfo': 'المعلومات الشخصية',
      'contactInfo': 'معلومات التواصل',
      'addressInfo': 'معلومات العنوان',
      'phoneNumbers': 'أرقام الهاتف',
      'emails': 'البريد الإلكتروني',
      'notes': 'ملاحظات',
      'additionalInfo': 'معلومات إضافية',
      'country': 'البلد',
      'state': 'الولاية',
      'city': 'المدينة',
      'zipCode': 'الرمز البريدي',
      'copyPhone': 'نسخ الهاتف',
      'copyEmail': 'نسخ البريد الإلكتروني',
      'copyAddress': 'نسخ العنوان',
      
      // Uncoded Item Detail Screen
      'itemCode': 'رمز العنصر',
      'itemName': 'اسم العنصر',
      'description': 'الوصف',
      'weight': 'الوزن',
      'dimensions': 'الأبعاد',
      'value': 'القيمة',
      'addedDate': 'تاريخ الإضافة',
      'lastModified': 'آخر تعديل',
      'itemImage': 'صورة العنصر',
      'tapToEnlarge': 'اضغط للتكبير',
      'kg': 'كغ',
      'cm': 'سم',
      'usd': 'دولار أمريكي',
      'uncoded': 'غير مُرمز',
      
      // Chinese Companies Screen
      'companyInfo': 'معلومات الشركة',
      'openingApp': 'جاري فتح',
      'noAppsFound': 'لم يتم العثور على تطبيقات',
      'refreshing': 'جاري التحديث...',
      'company': 'شركة',
      'application': 'تطبيق',
      'retry': 'إعادة المحاولة',
      
      // Item Detail Screen - Additional Keys
      'quantity': 'الكمية',
      'volume': 'الحجم',
      'addedOn': 'إضافة على',
      'transportCode': 'رمز النقل',
      'startDate': 'تاريخ البدء',
      'arrivalDate': 'تاريخ الوصول',
      'totalItems': 'إجمالي العناصر',
      'failedToLoad': 'فشل التحميل',
      'noImageAvailable': 'لا توجد صورة متاحة',
      'loadingImage': 'جاري تحميل الصورة...',
      
      // Status labels
      'delivered': 'تم التسليم',
      'completed': 'مكتمل',
      'inTransit': 'في الطريق',
      'shipping': 'الشحن',
      'pending': 'قيد الانتظار',
      'waiting': 'في الانتظار',
      'cancelled': 'ملغي',
      'failed': 'فشل',
      
      // Login Screen
      'welcomeToKeyWorld': 'مرحباً بك في  key World',
      'enterPhoneToLogin': 'الرجاء إدخال رقم هاتفك لتسجيل الدخول',
      'login': 'تسجيل الدخول',
      'register': 'تسجيل',
      'continueAsGuest': 'المتابعة كضيف',
      'notRegistered': 'أنت غير مسجل',
      'phoneNumber': 'رقم الهاتف',
      'enterPhoneNumber': 'أدخل رقم هاتفك',
      'invalidPhone': 'الرجاء إدخال رقم هاتف صحيح',
      
      // Registration Screen
      'createAccount': 'إنشاء حساب',
      'createYourAccount': 'إنشاء حسابك',
      'fillDetails': 'الرجاء ملء بياناتك لإنشاء حساب',
      'firstName': 'الاسم الأول',
      'lastName': 'اسم العائلة',
      'enterFirstName': 'أدخل اسمك الأول',
      'enterLastName': 'أدخل اسم العائلة',
      'city': 'المدينة و الشارع',
      'selectCity': 'اختر مدينتك و منطقتك',
      'username': 'اسم المستخدم',
      'haveUsername': 'لدي اسم مستخدم',
      'noUsername': 'ليس لدي اسم مستخدم',
      'enterUsername': 'أدخل اسم المستخدم (يجب أن يبدأ بـ H.E)',
      'usernameRequired': 'الرجاء إدخال اسم المستخدم',
      'usernameFormat': 'يجب أن يبدأ اسم المستخدم بـ H.E',
      'accountCreated': 'تم إنشاء الحساب بنجاح!',
      'userExists': 'يوجد مستخدم بهذا الرقم. الرجاء تسجيل الدخول بدلاً من ذلك.',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟ تسجيل الدخول',
    },
    'fa': {
      // General
      'appTitle': ' Key World',
      'loading': 'لەبارکردن...',
      'retry': 'دووبارە هەوڵدان',
      'noData': 'زانیاری نییە',
      'cancel': 'هەڵوەشاندنەوە',
      'close': 'داخستن',
      'save': 'پاشەکەوتکردن',
      'submit': 'ناردن',
      'yes': 'بەڵێ',
      'no': 'نەخێر',
      'ok': 'باشە',
      'error': 'هەڵە',
      'success': 'سەرکەوتوویی',
      'welcome': 'بەخێربێیت',
      'exitApp': 'چونە دەرەوە لە بەرنامەکە',
      'exitAppMessage': 'دڵنیایت دەتەوێت لە بەرنامەکە دەرچیت؟',
      'exit': 'دەرچوون',

      // Navigation
      'home': 'ماڵەوە',
      'profile': 'پرۆفایل',
      'inventory': 'مەوجودی',
      'prices': 'نرخەکان',
      'list': 'لیست',

      // List Screen Items
      'transportationFees': 'نرخی گواستنەوەكان',
      'addresses': 'ناونیشانەکان',
      'shippingAddresses': 'ناونیشانی كۆگاكانمان',
      'uncodedGoods': 'کاڵاکانی بێ كۆدەكان',
      'chineseCompanies': 'ناونیشانی كۆمپانیاكان',

      // Common UI Text
      'notProvided': 'دەست نادات',
      'copiedToClipboard': 'کۆپی کرا بۆ کلیپبۆرد',
      'copy': 'کۆپی',
      'tapToView': 'کرتە بکە بۆ بینین',
      'fullName': 'ناوی تەواو',
      'primaryPhone': 'ژمارەی سەرەکی',
      'secondaryPhone': 'ژمارەی دووەم',
      'fullAddress': 'ناونیشانی تەواو',

      // Loading and Error Messages
      'loadingTransportationFees': 'لەبارکردنی خەرجی گواستنەوە...',
      'loadingAddresses': 'لەبارکردنی ناونیشانەکان...',
      'loadingUncodedGoods': 'لەبارکردنی کاڵاکانی نەکۆدکراو...',
      'loadingChineseCompanies': 'لەبارکردنی کۆمپانیاکانی چین...',
      'errorLoadingUncodedGoods': 'هەڵە لە بارکردنی کاڵاکانی نەکۆدکراو',
      'errorLoadingChineseCompanies': 'هەڵە لە بارکردنی کۆمپانیاکانی چین',
      'noUncodedGoodsAvailable': 'کاڵاکانی نەکۆدکراو بەردەست نییە',
      'noChineseCompaniesAvailable': 'کۆمپانیاکانی چین بەردەست نییە',
      'noDescriptionAvailable': 'پێناسه‌ هەیە نییە',
      'imageNotAvailable': 'وێنە بەردەست نییە',
      'loadingImage': 'لەبارکردنی وێنە...',

      // Transport Info
      'toErbil': 'بۆ ھەولێر',
      'airFreight': 'باربەری هەوا',
      'seaFreight': 'باربەری دریا',
      'landFreight': 'باربەری زەوی',

      // Account & Profile
      'account': 'هەژمار',
      'accountName': 'ناوی هەژمار',
      'username': 'ناوی بەکارهێنەر',
      'phoneNumber': 'ژمارەی تەلەفون',
      'accountType': 'جۆری هەژمار',
      'standard': 'ستەندارد',
      'accountInfo': 'زانیاری هەژمار',
      'accountStatement': 'ڕاپۆرتی هەژمار',
      'languageSettings': 'ڕێکخستنی زمان',
      'logoutConfirmation': 'دڵنیابوونەوەی چوونەدەرەوە',
      'logoutConfirmationMessage': 'دڵنیایت دەتەوێت دەرچیت؟',
      'logout': 'دەرچوون',
      'guestUser': 'بەکارهێنەری میوان',
      'noUsername': 'بێ ناوی بەکارهێنەر',
      'currentBalance': 'بالانسى ئێستا',
      'transactionHistory': 'مێژووی مامەڵەکان',
      'availableBalance': 'بالانسى بەردەست',
      'youOweThisAmount': 'ئەم بڕە دەرێژەی تۆیە',
      'noTransactionsFound': 'هیچ مامەڵەیەک نەدۆزرایەوە',

      // Auth
      'login': 'چوونەژوورەوە',
      'register': 'تۆمارکردن',
      'forgotPassword': 'وشەی تێپەڕی لە یادەوە',
      'createAccount': 'دروستکردنی هەژمار',
      'alreadyHaveAccount': 'پێشتر هەژمارت هەیە؟',
      'dontHaveAccount': 'هەژمارت نییە؟',
      'signUp': 'تۆماربوون',
      'signIn': 'چوونەژوورەوە',
      'enterPhone': 'ژمارەی تەلەفون بنووسە',
      'enterCode': 'کۆدی دڵنیاکردن بنووسە',
      'sendCode': 'ناردنی کۆد',
      'resendCode': 'دووبارە ناردنی کۆد',
      'verifyCode': 'دڵنیاکردنی کۆد',
      'phoneVerification': 'دڵنیاکردنی تەلەفون',
      'weWillSendCode': 'کۆدی دڵنیاکردن بۆ تەلەفۆنت نارد دەکرێت',
      'enterCodeSent': 'کۆدی ناردراو بنووسە',

      // About & Contact
      'aboutUs': 'دەربارەی ئێمە',
      'contactUs': 'پەیوەندیمان پێوە بکە',
      'privacyInfo': 'زانیاری تایبەتمەندی',
      'ourStory': 'چیرۆکی ئێمە',
      'ourMission': 'ئامانجی ئێمە',
      'getInTouch': 'پەیوەندیمان پێوە بکە',
      'sendMessage': 'ناردنی نامە',
      'yourName': 'ناوی تۆ',
      'email': 'ئیمەیڵ',
      'message': 'نامە',
      'address': 'ناونیشان',
      'phoneContact': 'تەلەفون',

      // Price List
      'priceList': 'لیستی نرخەکان',
      'category': 'هاوپۆل',
      'item': 'بابەت',
      'price': 'نرخ',
      'currency': 'دۆلار',
      'viewDetails': 'بینینی وردەکارییەکان',
      'lastUpdated': 'دوایین نوێکردنەوە',

      // Transportation Fee Table Headers
      'note': 'تێبینی',
      'receivedCountry': 'وڵاتی وەرگیراو',

      // Transports
      'transports': 'گواستنەوەکان',
      'transport': 'گواستنەوە',
      'transportType': 'جۆری گواستنەوە',
      'transportDetails': 'وردەکارییەکانی گواستنەوە',
      'distance': 'دوور',
      'duration': 'کاتی گەڕان',
      'startLocation': 'شوێنی دەستپێکردن',
      'endLocation': 'شوێنی کۆتایی',
      'bookTransport': 'رزرفکردنی گواستنەوە',
      'transportHistory': 'مێژووی گواستنەوە',
      'status': 'بارودۆخ',
      'enterTruckNumber': 'ژمارەی تریکی بنووسە...',
      'searchTransport': 'گەڕان بۆ گواستنەوە',
      'loadingTransports': 'لەبارکردنی گواستنەوەکان...',
      'failedToLoadTransports': 'لەبارکردنی گواستنەوەکان سەرکەوتوو نەبوو',
      'noTransportsAvailable': 'گواستنەوەکان بەردەست نییە',

      // Search & Items
      'searchResult': 'ئەنجامی گەڕان',
      'itemDetails': 'وردەکاریی بابەت',
      'itemInformation': 'زانیاری بابەت',
      'transportInformation': 'زانیاری گواستنەوە',
      'codeNotFound': 'کۆد نەدۆزرایەوە',
      'codeNotFoundMessage': 'کۆدی گەڕاوەت لە تۆمارەکانی گواستنەوە یان کاڵاکان نەدۆزرایەوە. تکایە کۆدەکە بەدووبارە بسەرچێوە و هەوڵ بدەوە.',
      'suggestions': 'پیشنهادیەکان',
      'checkSpelling': 'نووسینی کۆدەکەت بگۆڕە',
      'removeSpaces': 'فاصلە زۆر لاببە',
      'checkFormat': 'دڵنیابە کە فۆرمات کۆدەکە دروستە',
      'contactSupport': 'ئەگەر یارمەتی پێویستت هەیە پەیوەندی بە پاڵپشتی بکە',
      'goBack': 'گەڕانەوە',
      'searchAgain': 'دووبارە گەڕان',

      // Tutorials
      'tutorials': 'فێرکاریەکان',
      'tutorial': 'فێرکاری',
      'tutorialDetails': 'وردەکاری فێرکاری',
      'steps': 'هەنگاوەکان',
      'watchVideo': 'بینینی ڤیدیۆ',
      'readMore': 'زیاتر بخوێنەوە',

      // Home Screen
      'loadingUpdates': 'لەبارکردنی نوێکردنەوەکان...',
      'failedToLoadUpdates': 'لەبارکردنی نوێکردنەوەکان سەرکەوتوو نەبوو',
      'noUpdatesAvailable': 'نوێکردنەوە نەدۆزرایەوە',
      'failedToLoadBanners': 'لەبارکردنی بانەرەکان سەرکەوتوو نەبوو',

      // Stories
      'loadingStories': 'لەبارکردنی چیرۆکەکان...',
      'failedToLoadStories': 'لەبارکردنی چیرۆکەکان سەرکەوتوو نەبوو',
      'noStoriesAvailable': 'چیرۆکەکان بەردەست نییە',

      // Transport Detail Screen
      'trackingDetails': 'وردەکاری گەڕان',
      'shippingMethod': 'ڕێگای گواستنەوە',
      'shippingRoute': 'ڕێچکەی گواستنەوە',
      'timeline': 'خەطی کات',
      'statusDescription': 'ڕوونکردنەوەی بارودۆخ',
      'origin': 'سەرچاوە',
      'destination': 'شوێن',

      // Address Detail Screen
      'personalInfo': 'زانیاری تایبەتی',
      'contactInfo': 'زانیاری پەیوەندیدان',
      'addressInfo': 'زانیاری ناونیشان',
      'phoneNumbers': 'ژمارە تەلەفونەکان',
      'emails': 'ئیمەیڵەکان',
      'notes': 'تێبینی',
      'additionalInfo': 'زانیاری زیادە',
      'country': 'وڵات',
      'state': 'پارێزگا',
      'city': 'شار',
      'zipCode': 'کۆدی پۆستی',
      'copyPhone': 'کۆپی کردن ژمارەی تەلەفون',
      'copyEmail': 'کۆپی کردن ئیمەیڵ',
      'copyAddress': 'کۆپی کردن ناونیشان',

      // Uncoded Item Detail Screen
      'itemCode': 'کۆدی بابەت',
      'itemName': 'ناوی بابەت',
      'description': 'ڕوونکردنەوە',
      'weight': 'CBM',
      'dimensions': 'قەبارەکان',
      'value': 'نرخی',
      'addedDate': 'ڕۆژی زیادکردن',
      'lastModified': 'دوایین گۆڕانکاری',
      'itemImage': 'وێنەی بابەت',
      'tapToEnlarge': 'بۆ گەورەکردن کرتە بکە',
      'kg': 'کیلۆگرام',
      'cm': 'سانتیمەتەر',
      'usd': 'دۆلاری ئەمەریکا',
      'uncoded': 'نەکۆدکراو',

      // Chinese Companies Screen
      'companyInfo': 'زانیاری کۆمپانیا',
      'openingApp': 'کردنەوە',
      'noAppsFound': 'هیچ پەیوەندیدار نەدۆزرایەوە',
      'refreshing': 'لەبارکردن...',
      'company': 'کۆمپانیا',
      'application': 'وەشانی بەرنامە',
      'retry': 'دووبارە هەوڵبدەوە',

      // Item Detail Screen - Additional Keys
      'quantity': 'ژ.پاكەیج',
      'volume': 'هەجم',
      'addedOn': 'زیادکرا لە',
      'transportCode': 'کۆدی گواستنەوە',
      'startDate': 'ڕۆژی دەستپێکردن',
      'arrivalDate': 'ڕۆژی گەیاندن',
      'totalItems': 'کۆی بابەتەکان',
      'failedToLoad': 'سەرکەوتوو نەبوو لە بارکردن',
      'noImageAvailable': 'وێنەیەک بەردەست نییە',
      'loadingImage': 'لەبارکردنی وێنە...',

      // Status labels
      'delivered': 'گەیاندرا',
      'completed': 'تەواو بوو',
      'inTransit': 'لە رێگەدا',
      'shipping': 'گواستنەوە',
      'pending': 'چاوەڕوان',
      'waiting': 'چاوەڕوان',
      'cancelled': 'لابردرا',
      'failed': 'سەرکەوتوو نەبوو',

      // Login Screen
      'welcomeToKeyWorld': 'بەخێربێیت بۆ Key World',
      'enterPhoneToLogin': 'تکایە ژمارەی تەلەفۆنت بنووسە بۆ چوونەژوورەوە',
      'login': 'چوونەژوورەوە',
      'register': 'تۆمارکردن',
      'continueAsGuest': 'وەک میوان بەردەوام ببه',
      'notRegistered': 'تۆمار نەکراویت',
      'phoneNumber': 'ژمارەی تەلەفون',
      'enterPhoneNumber': 'ژمارەی تەلەفونت بنووسە',
      'invalidPhone': 'تکایە ژمارەیەکی دروست بنووسە',

      // Registration Screen
      'createAccount': 'دروستکردنی هەژمار',
      'createYourAccount': 'هەژماری خۆت دروست بکە',
      'fillDetails': 'تکایە زانیاریەکانت پڕ بکە بۆ دروستکردنی هەژمار',
      'firstName': 'ناوی یەکەم',
      'lastName': 'ناوی باوک',
      'enterFirstName': 'ناوی یەکەمت بنووسە',
      'enterLastName': 'ناوی باوکت بنووسە',
      'city': ' شار و گەڕەك',
      'selectCity': ' شارەکەت و گەڕەكەت هەڵبژێرە',
      'username': 'ناوی بەکارهێنەر',
      'haveUsername': 'من ناوی بەکارهێنەر هەیە',
      'noUsername': 'من ناوی بەکارهێنەر نییە',
      'enterUsername': 'ناوی بەکارهێنەر بنووسە (دەبێت بە H.E دەست پێ بکات)',
      'usernameRequired': 'تکایە ناوی بەکارهێنەر بنووسە',
      'usernameFormat': 'ناوی بەکارهێنەر دەبێت بە H.E دەست پێ بکات',
      'accountCreated': 'هەژمار بە سەرکەوتوویی دروستکرا!',
      'userExists': 'بەکارهێنەرێک بەو ژمارەیە هەیە. تکایە چوونەژوورەوە بکە.',
      'alreadyHaveAccount': 'پێشتر هەژمارت هەیە؟ چوونەژوورەوە',
    },
  };
  
  // General
  String get appTitle => _localizedValues[locale.languageCode]?['appTitle'] ?? _localizedValues['en']!['appTitle']!;
  String get loading => _localizedValues[locale.languageCode]?['loading'] ?? _localizedValues['en']!['loading']!;
  String get retry => _localizedValues[locale.languageCode]?['retry'] ?? _localizedValues['en']!['retry']!;
  String get noData => _localizedValues[locale.languageCode]?['noData'] ?? _localizedValues['en']!['noData']!;
  String get cancel => _localizedValues[locale.languageCode]?['cancel'] ?? _localizedValues['en']!['cancel']!;
  String get close => _localizedValues[locale.languageCode]?['close'] ?? _localizedValues['en']!['close']!;
  String get save => _localizedValues[locale.languageCode]?['save'] ?? _localizedValues['en']!['save']!;
  String get submit => _localizedValues[locale.languageCode]?['submit'] ?? _localizedValues['en']!['submit']!;
  String get yes => _localizedValues[locale.languageCode]?['yes'] ?? _localizedValues['en']!['yes']!;
  String get no => _localizedValues[locale.languageCode]?['no'] ?? _localizedValues['en']!['no']!;
  String get ok => _localizedValues[locale.languageCode]?['ok'] ?? _localizedValues['en']!['ok']!;
  String get error => _localizedValues[locale.languageCode]?['error'] ?? _localizedValues['en']!['error']!;
  String get success => _localizedValues[locale.languageCode]?['success'] ?? _localizedValues['en']!['success']!;
  String get welcome => _localizedValues[locale.languageCode]?['welcome'] ?? _localizedValues['en']!['welcome']!;
  String get exitApp => _localizedValues[locale.languageCode]?['exitApp'] ?? _localizedValues['en']!['exitApp']!;
  String get exitAppMessage => _localizedValues[locale.languageCode]?['exitAppMessage'] ?? _localizedValues['en']!['exitAppMessage']!;
  String get exit => _localizedValues[locale.languageCode]?['exit'] ?? _localizedValues['en']!['exit']!;
  
  // Navigation
  String get home => _localizedValues[locale.languageCode]?['home'] ?? _localizedValues['en']!['home']!;
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? _localizedValues['en']!['profile']!;
  String get inventory => _localizedValues[locale.languageCode]?['inventory'] ?? _localizedValues['en']!['inventory']!;
  String get prices => _localizedValues[locale.languageCode]?['prices'] ?? _localizedValues['en']!['prices']!;
  String get list => _localizedValues[locale.languageCode]?['list'] ?? _localizedValues['en']!['list']!;
  
  // List Screen Items
  String get transportationFees => _localizedValues[locale.languageCode]?['transportationFees'] ?? _localizedValues['en']!['transportationFees']!;
  String get addresses => _localizedValues[locale.languageCode]?['addresses'] ?? _localizedValues['en']!['addresses']!;
  String get shippingAddresses => _localizedValues[locale.languageCode]?['shippingAddresses'] ?? _localizedValues['en']!['shippingAddresses']!;
  String get uncodedGoods => _localizedValues[locale.languageCode]?['uncodedGoods'] ?? _localizedValues['en']!['uncodedGoods']!;
  String get chineseCompanies => _localizedValues[locale.languageCode]?['chineseCompanies'] ?? _localizedValues['en']!['chineseCompanies']!;
  
  // Common UI Text
  String get notProvided => _localizedValues[locale.languageCode]?['notProvided'] ?? _localizedValues['en']!['notProvided']!;
  String get copiedToClipboard => _localizedValues[locale.languageCode]?['copiedToClipboard'] ?? _localizedValues['en']!['copiedToClipboard']!;
  String get copy => _localizedValues[locale.languageCode]?['copy'] ?? _localizedValues['en']!['copy']!;
  String get tapToView => _localizedValues[locale.languageCode]?['tapToView'] ?? _localizedValues['en']!['tapToView']!;
  String get fullName => _localizedValues[locale.languageCode]?['fullName'] ?? _localizedValues['en']!['fullName']!;
  String get primaryPhone => _localizedValues[locale.languageCode]?['primaryPhone'] ?? _localizedValues['en']!['primaryPhone']!;
  String get secondaryPhone => _localizedValues[locale.languageCode]?['secondaryPhone'] ?? _localizedValues['en']!['secondaryPhone']!;
  String get fullAddress => _localizedValues[locale.languageCode]?['fullAddress'] ?? _localizedValues['en']!['fullAddress']!;
  
  // Loading and Error Messages
  String get loadingTransportationFees => _localizedValues[locale.languageCode]?['loadingTransportationFees'] ?? _localizedValues['en']!['loadingTransportationFees']!;
  String get loadingAddresses => _localizedValues[locale.languageCode]?['loadingAddresses'] ?? _localizedValues['en']!['loadingAddresses']!;
  String get loadingUncodedGoods => _localizedValues[locale.languageCode]?['loadingUncodedGoods'] ?? _localizedValues['en']!['loadingUncodedGoods']!;
  String get loadingChineseCompanies => _localizedValues[locale.languageCode]?['loadingChineseCompanies'] ?? _localizedValues['en']!['loadingChineseCompanies']!;
  String get errorLoadingUncodedGoods => _localizedValues[locale.languageCode]?['errorLoadingUncodedGoods'] ?? _localizedValues['en']!['errorLoadingUncodedGoods']!;
  String get errorLoadingChineseCompanies => _localizedValues[locale.languageCode]?['errorLoadingChineseCompanies'] ?? _localizedValues['en']!['errorLoadingChineseCompanies']!;
  String get noUncodedGoodsAvailable => _localizedValues[locale.languageCode]?['noUncodedGoodsAvailable'] ?? _localizedValues['en']!['noUncodedGoodsAvailable']!;
  String get noChineseCompaniesAvailable => _localizedValues[locale.languageCode]?['noChineseCompaniesAvailable'] ?? _localizedValues['en']!['noChineseCompaniesAvailable']!;
  String get noDescriptionAvailable => _localizedValues[locale.languageCode]?['noDescriptionAvailable'] ?? _localizedValues['en']!['noDescriptionAvailable']!;
  String get imageNotAvailable => _localizedValues[locale.languageCode]?['imageNotAvailable'] ?? _localizedValues['en']!['imageNotAvailable']!;
  // Account & Profile
  String get account => _localizedValues[locale.languageCode]?['account'] ?? _localizedValues['en']!['account']!;
  String get accountName => _localizedValues[locale.languageCode]?['accountName'] ?? _localizedValues['en']!['accountName']!;
  String get username => _localizedValues[locale.languageCode]?['username'] ?? _localizedValues['en']!['username']!;
  String get phoneNumber => _localizedValues[locale.languageCode]?['phoneNumber'] ?? _localizedValues['en']!['phoneNumber']!;
  String get accountType => _localizedValues[locale.languageCode]?['accountType'] ?? _localizedValues['en']!['accountType']!;
  String get standard => _localizedValues[locale.languageCode]?['standard'] ?? _localizedValues['en']!['standard']!;
  String get accountInfo => _localizedValues[locale.languageCode]?['accountInfo'] ?? _localizedValues['en']!['accountInfo']!;
  String get accountStatement => _localizedValues[locale.languageCode]?['accountStatement'] ?? _localizedValues['en']!['accountStatement']!;
  String get languageSettings => _localizedValues[locale.languageCode]?['languageSettings'] ?? _localizedValues['en']!['languageSettings']!;
  String get logoutConfirmation => _localizedValues[locale.languageCode]?['logoutConfirmation'] ?? _localizedValues['en']!['logoutConfirmation']!;
  String get logoutConfirmationMessage => _localizedValues[locale.languageCode]?['logoutConfirmationMessage'] ?? _localizedValues['en']!['logoutConfirmationMessage']!;
  String get logout => _localizedValues[locale.languageCode]?['logout'] ?? _localizedValues['en']!['logout']!;
  String get guestUser => _localizedValues[locale.languageCode]?['guestUser'] ?? _localizedValues['en']!['guestUser']!;
  String get noUsername => _localizedValues[locale.languageCode]?['noUsername'] ?? _localizedValues['en']!['noUsername']!;
  String get currentBalance => _localizedValues[locale.languageCode]?['currentBalance'] ?? _localizedValues['en']!['currentBalance']!;
  String get transactionHistory => _localizedValues[locale.languageCode]?['transactionHistory'] ?? _localizedValues['en']!['transactionHistory']!;
  String get availableBalance => _localizedValues[locale.languageCode]?['availableBalance'] ?? _localizedValues['en']!['availableBalance']!;
  String get youOweThisAmount => _localizedValues[locale.languageCode]?['youOweThisAmount'] ?? _localizedValues['en']!['youOweThisAmount']!;
  String get noTransactionsFound => _localizedValues[locale.languageCode]?['noTransactionsFound'] ?? _localizedValues['en']!['noTransactionsFound']!;
  
  // Auth
  String get login => _localizedValues[locale.languageCode]?['login'] ?? _localizedValues['en']!['login']!;
  String get register => _localizedValues[locale.languageCode]?['register'] ?? _localizedValues['en']!['register']!;
  String get forgotPassword => _localizedValues[locale.languageCode]?['forgotPassword'] ?? _localizedValues['en']!['forgotPassword']!;
  String get createAccount => _localizedValues[locale.languageCode]?['createAccount'] ?? _localizedValues['en']!['createAccount']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]?['alreadyHaveAccount'] ?? _localizedValues['en']!['alreadyHaveAccount']!;
  String get dontHaveAccount => _localizedValues[locale.languageCode]?['dontHaveAccount'] ?? _localizedValues['en']!['dontHaveAccount']!;
  String get signUp => _localizedValues[locale.languageCode]?['signUp'] ?? _localizedValues['en']!['signUp']!;
  String get signIn => _localizedValues[locale.languageCode]?['signIn'] ?? _localizedValues['en']!['signIn']!;
  String get enterPhone => _localizedValues[locale.languageCode]?['enterPhone'] ?? _localizedValues['en']!['enterPhone']!;
  String get enterCode => _localizedValues[locale.languageCode]?['enterCode'] ?? _localizedValues['en']!['enterCode']!;
  String get sendCode => _localizedValues[locale.languageCode]?['sendCode'] ?? _localizedValues['en']!['sendCode']!;
  String get resendCode => _localizedValues[locale.languageCode]?['resendCode'] ?? _localizedValues['en']!['resendCode']!;
  String get verifyCode => _localizedValues[locale.languageCode]?['verifyCode'] ?? _localizedValues['en']!['verifyCode']!;
  String get phoneVerification => _localizedValues[locale.languageCode]?['phoneVerification'] ?? _localizedValues['en']!['phoneVerification']!;
  String get weWillSendCode => _localizedValues[locale.languageCode]?['weWillSendCode'] ?? _localizedValues['en']!['weWillSendCode']!;
  String get enterCodeSent => _localizedValues[locale.languageCode]?['enterCodeSent'] ?? _localizedValues['en']!['enterCodeSent']!;
  
  // About & Contact
  String get aboutUs => _localizedValues[locale.languageCode]?['aboutUs'] ?? _localizedValues['en']!['aboutUs']!;
  String get contactUs => _localizedValues[locale.languageCode]?['contactUs'] ?? _localizedValues['en']!['contactUs']!;
  String get privacyInfo => _localizedValues[locale.languageCode]?['privacyInfo'] ?? _localizedValues['en']!['privacyInfo']!;
  String get ourStory => _localizedValues[locale.languageCode]?['ourStory'] ?? _localizedValues['en']!['ourStory']!;
  String get ourMission => _localizedValues[locale.languageCode]?['ourMission'] ?? _localizedValues['en']!['ourMission']!;
  String get getInTouch => _localizedValues[locale.languageCode]?['getInTouch'] ?? _localizedValues['en']!['getInTouch']!;
  String get sendMessage => _localizedValues[locale.languageCode]?['sendMessage'] ?? _localizedValues['en']!['sendMessage']!;
  String get yourName => _localizedValues[locale.languageCode]?['yourName'] ?? _localizedValues['en']!['yourName']!;
  String get email => _localizedValues[locale.languageCode]?['email'] ?? _localizedValues['en']!['email']!;
  String get message => _localizedValues[locale.languageCode]?['message'] ?? _localizedValues['en']!['message']!;
  String get address => _localizedValues[locale.languageCode]?['address'] ?? _localizedValues['en']!['address']!;
  String get phoneContact => _localizedValues[locale.languageCode]?['phoneContact'] ?? _localizedValues['en']!['phoneContact']!;
  
  // Price List
  String get priceList => _localizedValues[locale.languageCode]?['priceList'] ?? _localizedValues['en']!['priceList']!;
  String get category => _localizedValues[locale.languageCode]?['category'] ?? _localizedValues['en']!['category']!;
  String get item => _localizedValues[locale.languageCode]?['item'] ?? _localizedValues['en']!['item']!;
  String get price => _localizedValues[locale.languageCode]?['price'] ?? _localizedValues['en']!['price']!;
  String get currency => _localizedValues[locale.languageCode]?['currency'] ?? _localizedValues['en']!['currency']!;
  String get viewDetails => _localizedValues[locale.languageCode]?['viewDetails'] ?? _localizedValues['en']!['viewDetails']!;
  String get lastUpdated => _localizedValues[locale.languageCode]?['lastUpdated'] ?? _localizedValues['en']!['lastUpdated']!;
  
  // Transportation Fee Table Headers
  String get note => _localizedValues[locale.languageCode]?['note'] ?? _localizedValues['en']!['note']!;
  String get receivedCountry => _localizedValues[locale.languageCode]?['receivedCountry'] ?? _localizedValues['en']!['receivedCountry']!;
  
  // Transports
  String get transports => _localizedValues[locale.languageCode]?['transports'] ?? _localizedValues['en']!['transports']!;
  String get transport => _localizedValues[locale.languageCode]?['transport'] ?? _localizedValues['en']!['transport']!;
  String get transportType => _localizedValues[locale.languageCode]?['transportType'] ?? _localizedValues['en']!['transportType']!;
  String get transportDetails => _localizedValues[locale.languageCode]?['transportDetails'] ?? _localizedValues['en']!['transportDetails']!;
  String get airFreight => _localizedValues[locale.languageCode]?['airFreight'] ?? _localizedValues['en']!['airFreight']!;
  String get seaFreight => _localizedValues[locale.languageCode]?['seaFreight'] ?? _localizedValues['en']!['seaFreight']!;
  String get landFreight => _localizedValues[locale.languageCode]?['landFreight'] ?? _localizedValues['en']!['landFreight']!;
  String get distance => _localizedValues[locale.languageCode]?['distance'] ?? _localizedValues['en']!['distance']!;
  String get duration => _localizedValues[locale.languageCode]?['duration'] ?? _localizedValues['en']!['duration']!;
  String get startLocation => _localizedValues[locale.languageCode]?['startLocation'] ?? _localizedValues['en']!['startLocation']!;
  String get endLocation => _localizedValues[locale.languageCode]?['endLocation'] ?? _localizedValues['en']!['endLocation']!;
  String get bookTransport => _localizedValues[locale.languageCode]?['bookTransport'] ?? _localizedValues['en']!['bookTransport']!;
  String get transportHistory => _localizedValues[locale.languageCode]?['transportHistory'] ?? _localizedValues['en']!['transportHistory']!;
  String get status => _localizedValues[locale.languageCode]?['status'] ?? _localizedValues['en']!['status']!;
  String get enterTruckNumber => _localizedValues[locale.languageCode]?['enterTruckNumber'] ?? _localizedValues['en']!['enterTruckNumber']!;
  String get searchTransport => _localizedValues[locale.languageCode]?['searchTransport'] ?? _localizedValues['en']!['searchTransport']!;
  String get loadingTransports => _localizedValues[locale.languageCode]?['loadingTransports'] ?? _localizedValues['en']!['loadingTransports']!;
  String get failedToLoadTransports => _localizedValues[locale.languageCode]?['failedToLoadTransports'] ?? _localizedValues['en']!['failedToLoadTransports']!;
  String get noTransportsAvailable => _localizedValues[locale.languageCode]?['noTransportsAvailable'] ?? _localizedValues['en']!['noTransportsAvailable']!;
  
  // Search & Items
  String get searchResult => _localizedValues[locale.languageCode]?['searchResult'] ?? _localizedValues['en']!['searchResult']!;
  String get itemDetails => _localizedValues[locale.languageCode]?['itemDetails'] ?? _localizedValues['en']!['itemDetails']!;
  String get itemInformation => _localizedValues[locale.languageCode]?['itemInformation'] ?? _localizedValues['en']!['itemInformation']!;
  String get transportInformation => _localizedValues[locale.languageCode]?['transportInformation'] ?? _localizedValues['en']!['transportInformation']!;
  String get codeNotFound => _localizedValues[locale.languageCode]?['codeNotFound'] ?? _localizedValues['en']!['codeNotFound']!;
  String get codeNotFoundMessage => _localizedValues[locale.languageCode]?['codeNotFoundMessage'] ?? _localizedValues['en']!['codeNotFoundMessage']!;
  String get suggestions => _localizedValues[locale.languageCode]?['suggestions'] ?? _localizedValues['en']!['suggestions']!;
  String get checkSpelling => _localizedValues[locale.languageCode]?['checkSpelling'] ?? _localizedValues['en']!['checkSpelling']!;
  String get removeSpaces => _localizedValues[locale.languageCode]?['removeSpaces'] ?? _localizedValues['en']!['removeSpaces']!;
  String get checkFormat => _localizedValues[locale.languageCode]?['checkFormat'] ?? _localizedValues['en']!['checkFormat']!;
  String get contactSupport => _localizedValues[locale.languageCode]?['contactSupport'] ?? _localizedValues['en']!['contactSupport']!;
  String get goBack => _localizedValues[locale.languageCode]?['goBack'] ?? _localizedValues['en']!['goBack']!;
  String get searchAgain => _localizedValues[locale.languageCode]?['searchAgain'] ?? _localizedValues['en']!['searchAgain']!;
  
  // Tutorials
  String get tutorials => _localizedValues[locale.languageCode]?['tutorials'] ?? _localizedValues['en']!['tutorials']!;
  String get tutorial => _localizedValues[locale.languageCode]?['tutorial'] ?? _localizedValues['en']!['tutorial']!;
  String get tutorialDetails => _localizedValues[locale.languageCode]?['tutorialDetails'] ?? _localizedValues['en']!['tutorialDetails']!;
  String get steps => _localizedValues[locale.languageCode]?['steps'] ?? _localizedValues['en']!['steps']!;
  String get watchVideo => _localizedValues[locale.languageCode]?['watchVideo'] ?? _localizedValues['en']!['watchVideo']!;
  String get readMore => _localizedValues[locale.languageCode]?['readMore'] ?? _localizedValues['en']!['readMore']!;
  
  // Home Screen
  String get loadingUpdates => _localizedValues[locale.languageCode]?['loadingUpdates'] ?? _localizedValues['en']!['loadingUpdates']!;
  String get failedToLoadUpdates => _localizedValues[locale.languageCode]?['failedToLoadUpdates'] ?? _localizedValues['en']!['failedToLoadUpdates']!;
  String get noUpdatesAvailable => _localizedValues[locale.languageCode]?['noUpdatesAvailable'] ?? _localizedValues['en']!['noUpdatesAvailable']!;
  String get failedToLoadBanners => _localizedValues[locale.languageCode]?['failedToLoadBanners'] ?? _localizedValues['en']!['failedToLoadBanners']!;
  
  // Stories
  String get loadingStories => _localizedValues[locale.languageCode]?['loadingStories'] ?? _localizedValues['en']!['loadingStories']!;
  String get failedToLoadStories => _localizedValues[locale.languageCode]?['failedToLoadStories'] ?? _localizedValues['en']!['failedToLoadStories']!;
  String get noStoriesAvailable => _localizedValues[locale.languageCode]?['noStoriesAvailable'] ?? _localizedValues['en']!['noStoriesAvailable']!;
  
  // Transport Detail Screen
  String get trackingDetails => _localizedValues[locale.languageCode]?['trackingDetails'] ?? _localizedValues['en']!['trackingDetails']!;
  String get shippingMethod => _localizedValues[locale.languageCode]?['shippingMethod'] ?? _localizedValues['en']!['shippingMethod']!;
  String get shippingRoute => _localizedValues[locale.languageCode]?['shippingRoute'] ?? _localizedValues['en']!['shippingRoute']!;
  String get timeline => _localizedValues[locale.languageCode]?['timeline'] ?? _localizedValues['en']!['timeline']!;
  String get statusDescription => _localizedValues[locale.languageCode]?['statusDescription'] ?? _localizedValues['en']!['statusDescription']!;
  String get origin => _localizedValues[locale.languageCode]?['origin'] ?? _localizedValues['en']!['origin']!;
  String get destination => _localizedValues[locale.languageCode]?['destination'] ?? _localizedValues['en']!['destination']!;
  
  // Address Detail Screen
  String get personalInfo => _localizedValues[locale.languageCode]?['personalInfo'] ?? _localizedValues['en']!['personalInfo']!;
  String get contactInfo => _localizedValues[locale.languageCode]?['contactInfo'] ?? _localizedValues['en']!['contactInfo']!;
  String get addressInfo => _localizedValues[locale.languageCode]?['addressInfo'] ?? _localizedValues['en']!['addressInfo']!;
  String get phoneNumbers => _localizedValues[locale.languageCode]?['phoneNumbers'] ?? _localizedValues['en']!['phoneNumbers']!;
  String get emails => _localizedValues[locale.languageCode]?['emails'] ?? _localizedValues['en']!['emails']!;
  String get notes => _localizedValues[locale.languageCode]?['notes'] ?? _localizedValues['en']!['notes']!;
  String get additionalInfo => _localizedValues[locale.languageCode]?['additionalInfo'] ?? _localizedValues['en']!['additionalInfo']!;
  String get country => _localizedValues[locale.languageCode]?['country'] ?? _localizedValues['en']!['country']!;
  String get state => _localizedValues[locale.languageCode]?['state'] ?? _localizedValues['en']!['state']!;
  String get city => _localizedValues[locale.languageCode]?['city'] ?? _localizedValues['en']!['city']!;
  String get zipCode => _localizedValues[locale.languageCode]?['zipCode'] ?? _localizedValues['en']!['zipCode']!;
  String get copyPhone => _localizedValues[locale.languageCode]?['copyPhone'] ?? _localizedValues['en']!['copyPhone']!;
  String get copyEmail => _localizedValues[locale.languageCode]?['copyEmail'] ?? _localizedValues['en']!['copyEmail']!;
  String get copyAddress => _localizedValues[locale.languageCode]?['copyAddress'] ?? _localizedValues['en']!['copyAddress']!;
  
  // Uncoded Item Detail Screen
  String get itemCode => _localizedValues[locale.languageCode]?['itemCode'] ?? _localizedValues['en']!['itemCode']!;
  String get itemName => _localizedValues[locale.languageCode]?['itemName'] ?? _localizedValues['en']!['itemName']!;
  String get description => _localizedValues[locale.languageCode]?['description'] ?? _localizedValues['en']!['description']!;
  String get weight => _localizedValues[locale.languageCode]?['weight'] ?? _localizedValues['en']!['weight']!;
  String get dimensions => _localizedValues[locale.languageCode]?['dimensions'] ?? _localizedValues['en']!['dimensions']!;
  String get value => _localizedValues[locale.languageCode]?['value'] ?? _localizedValues['en']!['value']!;
  String get addedDate => _localizedValues[locale.languageCode]?['addedDate'] ?? _localizedValues['en']!['addedDate']!;
  String get lastModified => _localizedValues[locale.languageCode]?['lastModified'] ?? _localizedValues['en']!['lastModified']!;
  String get itemImage => _localizedValues[locale.languageCode]?['itemImage'] ?? _localizedValues['en']!['itemImage']!;
  String get tapToEnlarge => _localizedValues[locale.languageCode]?['tapToEnlarge'] ?? _localizedValues['en']!['tapToEnlarge']!;
  String get kg => _localizedValues[locale.languageCode]?['kg'] ?? _localizedValues['en']!['kg']!;
  String get cm => _localizedValues[locale.languageCode]?['cm'] ?? _localizedValues['en']!['cm']!;
  String get usd => _localizedValues[locale.languageCode]?['usd'] ?? _localizedValues['en']!['usd']!;
  String get uncoded => _localizedValues[locale.languageCode]?['uncoded'] ?? _localizedValues['en']!['uncoded']!;
  
  // Chinese Companies Screen
  String get companyInfo => _localizedValues[locale.languageCode]?['companyInfo'] ?? _localizedValues['en']!['companyInfo']!;
  String get openingApp => _localizedValues[locale.languageCode]?['openingApp'] ?? _localizedValues['en']!['openingApp']!;
  String get noAppsFound => _localizedValues[locale.languageCode]?['noAppsFound'] ?? _localizedValues['en']!['noAppsFound']!;
  String get refreshing => _localizedValues[locale.languageCode]?['refreshing'] ?? _localizedValues['en']!['refreshing']!;
  String get company => _localizedValues[locale.languageCode]?['company'] ?? _localizedValues['en']!['company']!;
  String get application => _localizedValues[locale.languageCode]?['application'] ?? _localizedValues['en']!['application']!;
  
  // Item Detail Screen - Additional Keys
  String get quantity => _localizedValues[locale.languageCode]?['quantity'] ?? _localizedValues['en']!['quantity']!;
  String get volume => _localizedValues[locale.languageCode]?['volume'] ?? _localizedValues['en']!['volume']!;
  String get addedOn => _localizedValues[locale.languageCode]?['addedOn'] ?? _localizedValues['en']!['addedOn']!;
  String get transportCode => _localizedValues[locale.languageCode]?['transportCode'] ?? _localizedValues['en']!['transportCode']!;
  String get startDate => _localizedValues[locale.languageCode]?['startDate'] ?? _localizedValues['en']!['startDate']!;
  String get arrivalDate => _localizedValues[locale.languageCode]?['arrivalDate'] ?? _localizedValues['en']!['arrivalDate']!;
  String get totalItems => _localizedValues[locale.languageCode]?['totalItems'] ?? _localizedValues['en']!['totalItems']!;
  String get failedToLoad => _localizedValues[locale.languageCode]?['failedToLoad'] ?? _localizedValues['en']!['failedToLoad']!;
  String get noImageAvailable => _localizedValues[locale.languageCode]?['noImageAvailable'] ?? _localizedValues['en']!['noImageAvailable']!;
  String get loadingImage => _localizedValues[locale.languageCode]?['loadingImage'] ?? _localizedValues['en']!['loadingImage']!;
  
  // Status labels
  String get delivered => _localizedValues[locale.languageCode]?['delivered'] ?? _localizedValues['en']!['delivered']!;
  String get completed => _localizedValues[locale.languageCode]?['completed'] ?? _localizedValues['en']!['completed']!;
  String get inTransit => _localizedValues[locale.languageCode]?['inTransit'] ?? _localizedValues['en']!['inTransit']!;
  String get shipping => _localizedValues[locale.languageCode]?['shipping'] ?? _localizedValues['en']!['shipping']!;
  String get pending => _localizedValues[locale.languageCode]?['pending'] ?? _localizedValues['en']!['pending']!;
  String get waiting => _localizedValues[locale.languageCode]?['waiting'] ?? _localizedValues['en']!['waiting']!;
  String get cancelled => _localizedValues[locale.languageCode]?['cancelled'] ?? _localizedValues['en']!['cancelled']!;
  String get failed => _localizedValues[locale.languageCode]?['failed'] ?? _localizedValues['en']!['failed']!;
  
  // Helper method to get name based on language
  String getLocalizedName(String? englishName, String? arabicName, String? kurdishName) {
    if (englishName == null && arabicName == null && kurdishName == null) {
      return '';
    }
    
    switch (locale.languageCode) {
      case 'ar':
        return arabicName ?? englishName ?? kurdishName ?? '';
      case 'fa': // Persian for Kurdish
        return kurdishName ?? englishName ?? arabicName ?? '';
      default: // 'en'
        return englishName ?? arabicName ?? kurdishName ?? '';
    }
  }
  
  String get welcomeToKeyWorld => _localizedValues[locale.languageCode]!['welcomeToKeyWorld']!;
  String get enterPhoneToLogin => _localizedValues[locale.languageCode]!['enterPhoneToLogin']!;
  String get enterPhoneNumber => _localizedValues[locale.languageCode]!['enterPhoneNumber']!;
  String get invalidPhone => _localizedValues[locale.languageCode]!['invalidPhone']!;
  String get continueAsGuest => _localizedValues[locale.languageCode]!['continueAsGuest']!;
  String get notRegistered => _localizedValues[locale.languageCode]!['notRegistered']!;
  String get createYourAccount => _localizedValues[locale.languageCode]!['createYourAccount']!;
  String get fillDetails => _localizedValues[locale.languageCode]!['fillDetails']!;
  String get firstName => _localizedValues[locale.languageCode]!['firstName']!;
  String get enterFirstName => _localizedValues[locale.languageCode]!['enterFirstName']!;
  String get lastName => _localizedValues[locale.languageCode]!['lastName']!;
  String get enterLastName => _localizedValues[locale.languageCode]!['enterLastName']!;
  String get selectCity => _localizedValues[locale.languageCode]!['selectCity']!;
  String get haveUsername => _localizedValues[locale.languageCode]!['haveUsername']!;
  String get enterUsername => _localizedValues[locale.languageCode]!['enterUsername']!;
  String get usernameRequired => _localizedValues[locale.languageCode]!['usernameRequired']!;
  String get usernameFormat => _localizedValues[locale.languageCode]!['usernameFormat']!;
  String get accountCreated => _localizedValues[locale.languageCode]!['accountCreated']!;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'fa'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
} 