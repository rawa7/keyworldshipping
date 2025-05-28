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
      'appTitle': 'KeyWorld',
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
      
      // Navigation
      'home': 'Home',
      'profile': 'PROFILE',
      'inventory': 'Inventory',
      'prices': 'Prices',
      
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
      'failedToLoadBanners': 'Failed to load banners'
    },
    'ar': {
      // General
      'appTitle': 'عالم المفاتيح',
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
      
      // Navigation
      'home': 'الرئيسية',
      'profile': 'الملف الشخصي',
      'inventory': 'المخزون',
      'prices': 'الأسعار',
      
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
      'failedToLoadBanners': 'فشل في تحميل البانرات'
    },
    'fa': {
      // General
      'appTitle': 'دنیای کلید',
      'loading': 'در حال بارگذاری...',
      'retry': 'تلاش مجدد',
      'noData': 'اطلاعاتی موجود نیست',
      'cancel': 'لغو',
      'close': 'بستن',
      'save': 'ذخیره',
      'submit': 'ارسال',
      'yes': 'بله',
      'no': 'خیر',
      'ok': 'تایید',
      'error': 'خطا',
      'success': 'موفقیت',
      'welcome': 'خوش آمدید',
      
      // Navigation
      'home': 'خانه',
      'profile': 'پروفایل',
      'inventory': 'موجودی',
      'prices': 'قیمت‌ها',
      
      // Account & Profile
      'account': 'حساب',
      'accountName': 'نام حساب',
      'username': 'نام کاربری',
      'phoneNumber': 'شماره تلفن',
      'accountType': 'نوع حساب',
      'standard': 'استاندارد',
      'accountInfo': 'اطلاعات حساب',
      'accountStatement': 'صورتحساب',
      'languageSettings': 'تنظیمات زبان',
      'logoutConfirmation': 'تایید خروج',
      'logoutConfirmationMessage': 'آیا مطمئن هستید که می خواهید خارج شوید؟',
      'logout': 'خروج',
      'guestUser': 'کاربر مهمان',
      'noUsername': 'بدون نام کاربری',
      'currentBalance': 'موجودی فعلی',
      'transactionHistory': 'تاریخچه تراکنش',
      'availableBalance': 'موجودی قابل استفاده',
      'youOweThisAmount': 'شما این مبلغ را بدهکار هستید',
      'noTransactionsFound': 'هیچ تراکنشی یافت نشد',
      
      // Auth
      'login': 'ورود',
      'register': 'ثبت نام',
      'forgotPassword': 'رمز عبور را فراموش کرده‌اید؟',
      'createAccount': 'ایجاد حساب',
      'alreadyHaveAccount': 'قبلاً حساب کاربری دارید؟',
      'dontHaveAccount': 'حساب کاربری ندارید؟',
      'signUp': 'ثبت نام',
      'signIn': 'ورود',
      'enterPhone': 'شماره تلفن را وارد کنید',
      'enterCode': 'کد تایید را وارد کنید',
      'sendCode': 'ارسال کد',
      'resendCode': 'ارسال مجدد کد',
      'verifyCode': 'تایید کد',
      'phoneVerification': 'تایید تلفن',
      'weWillSendCode': 'ما یک کد تایید به تلفن شما ارسال خواهیم کرد',
      'enterCodeSent': 'کد ارسال شده به تلفن خود را وارد کنید',
      
      // About & Contact
      'aboutUs': 'درباره ما',
      'contactUs': 'تماس با ما',
      'privacyInfo': 'اطلاعات حریم خصوصی',
      'ourStory': 'داستان ما',
      'ourMission': 'ماموریت ما',
      'getInTouch': 'در تماس باشید',
      'sendMessage': 'ارسال پیام',
      'yourName': 'نام شما',
      'email': 'ایمیل',
      'message': 'پیام',
      'address': 'آدرس',
      'phoneContact': 'تلفن',
      
      // Price List
      'priceList': 'لیست قیمت',
      'category': 'دسته‌بندی',
      'item': 'مورد',
      'price': 'قیمت',
      'currency': 'دلار',
      'viewDetails': 'مشاهده جزئیات',
      'lastUpdated': 'آخرین بروزرسانی',
      
      // Transports
      'transports': 'حمل و نقل',
      'transport': 'حمل و نقل',
      'transportType': 'نوع حمل و نقل',
      'transportDetails': 'جزئیات حمل و نقل',
      'distance': 'مسافت',
      'duration': 'مدت زمان',
      'startLocation': 'مکان شروع',
      'endLocation': 'مکان پایان',
      'bookTransport': 'رزرو حمل و نقل',
      'transportHistory': 'تاریخچه حمل و نقل',
      'status': 'وضعیت',
      'enterTruckNumber': 'آدرس تریک را وارد کنید...',
      
      // Tutorials
      'tutorials': 'آموزش‌ها',
      'tutorial': 'آموزش',
      'tutorialDetails': 'جزئیات آموزش',
      'steps': 'مراحل',
      'watchVideo': 'تماشای ویدیو',
      'readMore': 'بیشتر بخوانید',
      
      // Home Screen
      'loadingUpdates': 'در حال بارگذاری به‌روزرسانی‌ها...',
      'failedToLoadUpdates': 'بارگذاری به‌روزرسانی‌ها ناموفق بود',
      'noUpdatesAvailable': 'به‌روزرسانی در دسترس نیست',
      'failedToLoadBanners': 'بارگذاری بنرها ناموفق بود'
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
  
  // Navigation
  String get home => _localizedValues[locale.languageCode]?['home'] ?? _localizedValues['en']!['home']!;
  String get profile => _localizedValues[locale.languageCode]?['profile'] ?? _localizedValues['en']!['profile']!;
  String get inventory => _localizedValues[locale.languageCode]?['inventory'] ?? _localizedValues['en']!['inventory']!;
  String get prices => _localizedValues[locale.languageCode]?['prices'] ?? _localizedValues['en']!['prices']!;
  
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
  
  // Transports
  String get transports => _localizedValues[locale.languageCode]?['transports'] ?? _localizedValues['en']!['transports']!;
  String get transport => _localizedValues[locale.languageCode]?['transport'] ?? _localizedValues['en']!['transport']!;
  String get transportType => _localizedValues[locale.languageCode]?['transportType'] ?? _localizedValues['en']!['transportType']!;
  String get transportDetails => _localizedValues[locale.languageCode]?['transportDetails'] ?? _localizedValues['en']!['transportDetails']!;
  String get distance => _localizedValues[locale.languageCode]?['distance'] ?? _localizedValues['en']!['distance']!;
  String get duration => _localizedValues[locale.languageCode]?['duration'] ?? _localizedValues['en']!['duration']!;
  String get startLocation => _localizedValues[locale.languageCode]?['startLocation'] ?? _localizedValues['en']!['startLocation']!;
  String get endLocation => _localizedValues[locale.languageCode]?['endLocation'] ?? _localizedValues['en']!['endLocation']!;
  String get bookTransport => _localizedValues[locale.languageCode]?['bookTransport'] ?? _localizedValues['en']!['bookTransport']!;
  String get transportHistory => _localizedValues[locale.languageCode]?['transportHistory'] ?? _localizedValues['en']!['transportHistory']!;
  String get status => _localizedValues[locale.languageCode]?['status'] ?? _localizedValues['en']!['status']!;
  String get enterTruckNumber => _localizedValues[locale.languageCode]?['enterTruckNumber'] ?? _localizedValues['en']!['enterTruckNumber']!;
  
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