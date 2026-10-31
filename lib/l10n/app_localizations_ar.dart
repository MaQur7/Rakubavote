// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Rakubavote';

  @override
  String get tagline => 'صوتك، في العلن.';

  @override
  String get chooseDeviceMode => 'لأي غرض سيُستخدم هذا الجهاز؟';

  @override
  String get modeAdmin => 'إدارة المركز';

  @override
  String get modeAdminHint =>
      'حاسوب محمول. إعداد الانتخاب وتسجيل الناخبين وإغلاق الاقتراع وطباعة النتائج.';

  @override
  String get modeCheckin => 'مكتب التحقق';

  @override
  String get modeCheckinHint =>
      'حاسوب محمول أو جهاز لوحي. ابحث عن الناخب وأعطه رمز التصويت.';

  @override
  String get modeBooth => 'كشك التصويت';

  @override
  String get modeBoothHint => 'جهاز لوحي. هنا يختار الناخبون مرشحيهم.';

  @override
  String get yourVoteIsSecret => 'صوتك سري.';

  @override
  String get askAnOfficial => 'اطلب المساعدة من أحد المسؤولين.';

  @override
  String get help => 'مساعدة';

  @override
  String get languageName => 'العربية';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get ok => 'موافق';

  @override
  String get offlineSavedLaptop => 'بدون إنترنت · محفوظ على هذا الحاسوب';

  @override
  String get officialUseOnly => 'Rakubavote · للاستخدام الرسمي فقط';

  @override
  String get comingLater => 'هذا الجزء من التطبيق سيأتي في تحديث لاحق.';

  @override
  String get setupDeviceTitle => 'إعداد هذا الجهاز';

  @override
  String get yourName => 'اسمك';

  @override
  String get yourNameHint => 'كما يجب أن يظهر في سجل التدقيق';

  @override
  String get choosePin => 'اختر رمز المسؤول (من 6 إلى 12 رقمًا)';

  @override
  String get confirmPin => 'اكتب الرمز مرة أخرى';

  @override
  String get pinsDoNotMatch => 'الرمزان غير متطابقين.';

  @override
  String get pinRule => 'يجب أن يتكون الرمز من 6 إلى 12 رقمًا.';

  @override
  String get nameRequired => 'اكتب اسمك.';

  @override
  String get setUpButton => 'إعداد هذا الجهاز';

  @override
  String get pinWarning =>
      'احفظ الرمز سرًا. بدونه لا يستطيع أحد فتح البيانات على هذا الجهاز، ولا يمكن استعادته.';

  @override
  String unlockTitle(Object mode) {
    return 'فتح: $mode';
  }

  @override
  String get officerPin => 'رمز المسؤول';

  @override
  String get unlockButton => 'فتح';

  @override
  String get wrongPin => 'الرمز غير صحيح. حاول مرة أخرى.';

  @override
  String get lockDevice => 'قفل';

  @override
  String get adminSuffix => 'الإدارة';

  @override
  String get tabSetup => '1 الإعداد';

  @override
  String get tabRegistration => '2 التسجيل';

  @override
  String get tabReview => '3 المراجعة والقفل';

  @override
  String get tabResults => '4 النتائج';

  @override
  String get newElection => 'انتخاب جديد';

  @override
  String get template => 'النموذج';

  @override
  String get templateSchool => 'مدرسة';

  @override
  String get templateAssociation => 'جمعية مجتمعية';

  @override
  String get templatePartyPrimary => 'انتخابات حزبية أولية';

  @override
  String get templateBlank => 'فارغ';

  @override
  String get orgName => 'اسم المنظمة';

  @override
  String get electionName => 'اسم الانتخاب';

  @override
  String get year => 'السنة';

  @override
  String get stationName => 'اسم المركز';

  @override
  String get ballotLanguages => 'لغات ورقة الاقتراع';

  @override
  String get createElection => 'إنشاء الانتخاب';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب.';

  @override
  String get electionDetails => 'تفاصيل الانتخاب';

  @override
  String get idLabelField => 'اسم حقل الهوية';

  @override
  String get groupLabelField => 'اسم حقل المجموعة';

  @override
  String get organizationLogo => 'شعار المنظمة';

  @override
  String get chooseLogo => 'اختر الشعار';

  @override
  String get registrationFee => 'رسوم التسجيل';

  @override
  String get chargeFee => 'فرض رسوم';

  @override
  String get amount => 'المبلغ';

  @override
  String get currency => 'العملة';

  @override
  String get currencyEither => 'جنيه جنوب سوداني أو دولار';

  @override
  String get unpaidPolicy => 'إذا لم يدفع الشخص';

  @override
  String get unpaidBlock => 'لا تسجله';

  @override
  String get unpaidAllow => 'سجله مع وضع علامة غير مدفوع';

  @override
  String get feeNote => 'تُحدد قبل بدء التسجيل. تُقفل عند تسجيل أول ناخب.';

  @override
  String get feeLockedNote => 'مقفلة: يوجد ناخبون مسجلون.';

  @override
  String get saveFee => 'حفظ الرسوم';

  @override
  String get feeSaved => 'تم حفظ الرسوم.';

  @override
  String get schoolConsent => 'موافقة المدرسة';

  @override
  String get schoolConsentText =>
      'أعطت المدرسة موافقتها على تسجيل الطلاب دون 18 سنة.';

  @override
  String schoolConsentRecordedBy(Object name) {
    return 'سجلها $name';
  }

  @override
  String get positions => 'المناصب';

  @override
  String get addPosition => 'إضافة منصب';

  @override
  String get newPositionTitle => 'منصب جديد';

  @override
  String candidatesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرشح',
      many: '$count مرشحًا',
      few: '$count مرشحين',
      two: 'مرشحان',
      one: 'مرشح واحد',
      zero: 'لا مرشحين',
    );
    return '$_temp0';
  }

  @override
  String get allowNoChoice => 'السماح بـ «لا اختيار»';

  @override
  String get chooseLabel => 'اختر';

  @override
  String get candidatesSuffix => 'مرشح/مرشحين';

  @override
  String positionTitleIn(Object language) {
    return 'الاسم بـ$language';
  }

  @override
  String get colour => 'اللون';

  @override
  String get moveUp => 'إلى الأعلى';

  @override
  String get moveDown => 'إلى الأسفل';

  @override
  String get deletePosition => 'حذف المنصب';

  @override
  String deletePositionConfirm(Object title) {
    return 'حذف $title ومرشحيه؟';
  }

  @override
  String get colNo => 'الرقم';

  @override
  String get colPhoto => 'الصورة';

  @override
  String get colName => 'الاسم';

  @override
  String get colSymbol => 'الرمز';

  @override
  String get addCandidate => 'إضافة مرشح (التقاط صورة)';

  @override
  String get editCandidate => 'تعديل المرشح';

  @override
  String get candidateNumber => 'رقم المرشح';

  @override
  String get candidateName => 'اسم المرشح';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get chooseSymbol => 'اختر الرمز';

  @override
  String get removeImage => 'إزالة';

  @override
  String get deleteCandidate => 'حذف المرشح';

  @override
  String get printSampleBallot => 'طباعة نموذج ورقة الاقتراع';

  @override
  String get saveAndSignBallot => 'حفظ وتوقيع ورقة الاقتراع';

  @override
  String get ballotSigned => 'تم توقيع ورقة الاقتراع';

  @override
  String ballotFingerprint(Object code) {
    return 'البصمة: $code';
  }

  @override
  String get ballotNotSigned => 'ورقة الاقتراع غير موقعة بعد.';

  @override
  String get ballotSignedNote => 'موقعة. أي تغيير يحتاج إلى توقيع جديد.';

  @override
  String get noPositionSelected => 'أضف منصبًا من الجهة الأخرى للبدء.';

  @override
  String get errFeeLocked => 'لا يمكن تغيير الرسوم: يوجد ناخبون مسجلون.';

  @override
  String get errBallotFrozen => 'لا يمكن تغيير ورقة الاقتراع بعد قفل السجل.';

  @override
  String errBallotInvalid(Object details) {
    return 'ورقة الاقتراع غير مكتملة. $details';
  }

  @override
  String get errDuplicateNumber => 'يوجد مرشح آخر بنفس الرقم.';

  @override
  String get errLowContrast =>
      'هذا اللون فاتح جدًا للنص الأبيض. اختر لونًا أغمق.';

  @override
  String get errInvalidValue => 'تحقق من القيم وحاول مرة أخرى.';

  @override
  String get registerAVoter => 'تسجيل ناخب';

  @override
  String get photo => 'الصورة';

  @override
  String get photoUse =>
      'تُستخدم فقط للتحقق من الهوية يوم الانتخاب. تُحذف بعد الانتخاب.';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get fullNameHint => 'كما هو معروف في المجتمع';

  @override
  String feeLine(Object amount, Object currency) {
    return 'رسوم التسجيل: $amount $currency';
  }

  @override
  String get paid => 'مدفوع';

  @override
  String get receiptNo => 'رقم الإيصال';

  @override
  String get possibleDuplicate => 'تكرار محتمل:';

  @override
  String duplicateNameText(Object number) {
    return 'يوجد ناخب باسم مشابه في نفس المجموعة (رقم الناخب $number). تحقق قبل الحفظ.';
  }

  @override
  String duplicateIdText(Object number) {
    return 'يوجد ناخب بنفس رقم الهوية (رقم الناخب $number). تحقق قبل الحفظ.';
  }

  @override
  String get clear => 'مسح';

  @override
  String get saveAndPrintCard => 'حفظ وطباعة بطاقة الناخب';

  @override
  String get registeredVoters => 'الناخبون المسجلون';

  @override
  String get searchNameOrNumber => 'ابحث بالاسم أو الرقم';

  @override
  String get colVoterNo => 'رقم الناخب';

  @override
  String get colGroup => 'المجموعة';

  @override
  String get colFee => 'الرسوم';

  @override
  String get colCard => 'البطاقة';

  @override
  String get feeNotPaid => 'غير مدفوع';

  @override
  String get cardNotPrinted => 'لم تُطبع';

  @override
  String showingVoters(Object shown, Object total) {
    return 'عرض $shown من $total ناخبًا مسجلًا';
  }

  @override
  String get feeSummary => 'ملخص الرسوم';

  @override
  String get importCsv => 'استيراد قائمة (CSV)';

  @override
  String get backupUsb => 'نسخ احتياطي إلى USB';

  @override
  String voterSaved(Object number) {
    return 'تم الحفظ. رقم الناخب $number.';
  }

  @override
  String get errConsentMissing =>
      'سجل موافقة المدرسة في الإعداد قبل تسجيل الطلاب.';

  @override
  String get errNameRequired => 'اكتب الاسم الكامل.';

  @override
  String get errFeeUnpaidBlocked => 'هذا الانتخاب يسجل فقط من دفع الرسوم.';

  @override
  String get errReceiptRequired => 'اكتب رقم الإيصال.';

  @override
  String get errCurrencyNotAccepted => 'اختر الجنيه أو الدولار.';

  @override
  String get errRegisterLocked => 'السجل مقفل. لا يمكن إضافة أسماء.';

  @override
  String get errNoElection => 'أنشئ الانتخاب في الإعداد أولًا.';

  @override
  String importDone(Object duplicates, Object imported, Object skipped) {
    return 'تم استيراد $imported. تم تخطي $skipped. تكرارات محتملة: $duplicates.';
  }

  @override
  String importSkippedLine(Object line, Object reason) {
    return 'السطر $line: $reason';
  }

  @override
  String backupDone(Object path) {
    return 'تم حفظ النسخة الاحتياطية في $path';
  }

  @override
  String get backupFailed =>
      'تعذر حفظ النسخة الاحتياطية. تحقق من ذاكرة USB وحاول مرة أخرى.';

  @override
  String get totalsByCurrency => 'المجاميع حسب العملة';

  @override
  String get totalsByOfficial => 'المجاميع حسب المسؤول';

  @override
  String paidCount(Object count) {
    return 'مدفوع: $count';
  }

  @override
  String unpaidCount(Object count) {
    return 'غير مدفوع: $count';
  }

  @override
  String flaggedCount(Object count) {
    return 'سُجلوا دون دفع: $count';
  }

  @override
  String get noFee => 'لا توجد رسوم تسجيل في هذا الانتخاب.';

  @override
  String get photoFailed => 'لم تُلتقط صورة. يمكنك المحاولة مرة أخرى.';
}
