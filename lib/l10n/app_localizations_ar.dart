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
      'حاسوب محمول. إعداد الانتخاب وتسجيل الناخبين وإغلاق الاقتراع وعرض النتائج.';

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
  String importDone(Object imported, Object skipped, Object duplicates) {
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

  @override
  String get registeredVotersStat => 'الناخبون المسجلون';

  @override
  String get displayPeriod => 'فترة العرض العام';

  @override
  String displayPeriodRange(Object start, Object end) {
    return 'من $start إلى $end';
  }

  @override
  String get displayPeriodNotSet => 'لم تُحدد بعد';

  @override
  String get setDates => 'تحديد التواريخ';

  @override
  String get startDate => 'اليوم الأول';

  @override
  String get endDate => 'اليوم الأخير';

  @override
  String get openObjections => 'اعتراضات مفتوحة';

  @override
  String get objectionsTitle => 'الاعتراضات والتصحيحات';

  @override
  String get objectionsNote =>
      'يُحفظ كل قرار في سجل التدقيق مع اسم المسؤول والوقت.';

  @override
  String get noObjections =>
      'لا توجد اعتراضات مسجلة. تظهر هنا الاعتراضات المقدمة أثناء العرض العام.';

  @override
  String get raiseObjection => 'تسجيل اعتراض';

  @override
  String get checkDuplicates => 'البحث عن التكرارات';

  @override
  String get objectionKind => 'ما هو الاعتراض؟';

  @override
  String get kindDuplicate => 'تكرار محتمل';

  @override
  String get kindMissing => 'اسم مفقود';

  @override
  String get kindOther => 'أخرى';

  @override
  String get voterNumberField => 'رقم الناخب';

  @override
  String get otherVoterNumberField => 'تكرار محتمل لرقم الناخب';

  @override
  String get claimantNameField => 'اسم الشخص المفقود';

  @override
  String get raisedByField => 'اسم المعترض';

  @override
  String get detailField => 'التفاصيل';

  @override
  String duplicateTitle(Object subject, Object other) {
    return 'رقم الناخب $subject · تكرار محتمل لـ $other';
  }

  @override
  String missingTitle(Object name) {
    return 'اسم مفقود: $name';
  }

  @override
  String otherTitle(Object subject, Object detail) {
    return 'رقم الناخب $subject: $detail';
  }

  @override
  String raisedByLine(Object name, Object date) {
    return 'قدمه $name في $date';
  }

  @override
  String decidedLine(Object name, Object date, Object decision) {
    return 'قرره $name في $date: $decision';
  }

  @override
  String get keepBoth => 'إبقاء الاثنين';

  @override
  String removeVoter(Object number) {
    return 'حذف $number';
  }

  @override
  String get addVoter => 'إضافة ناخب';

  @override
  String get reject => 'رفض';

  @override
  String get upheld => 'مقبول';

  @override
  String get rejected => 'مرفوض';

  @override
  String get decisionKeepBoth => 'أُبقي الاثنان';

  @override
  String get decisionRemove => 'حُذف';

  @override
  String get decisionAdd => 'أُضيف';

  @override
  String get decisionReject => 'رُفض';

  @override
  String get decisionUpheld => 'قُبل';

  @override
  String get decisionRejected => 'رُفض';

  @override
  String get noDuplicatesFound => 'لم يُعثر على تكرارات محتملة.';

  @override
  String get duplicatePairsTitle => 'تكرارات محتملة';

  @override
  String duplicatePairLine(Object a, Object b) {
    return '$a و$b';
  }

  @override
  String get raiseThis => 'تسجيل كاعتراض';

  @override
  String get lockTitle => 'قفل السجل';

  @override
  String get lockText =>
      'بعد القفل لا يمكن إضافة أسماء أو حذفها. ينشئ الحاسوب نسخة موقعة ورمز بصمة يمكن لأي شخص التحقق منه.';

  @override
  String get printRegister => 'طباعة السجل للوحة الإعلانات';

  @override
  String get lockButton => 'قفل السجل';

  @override
  String lockButtonBlocked(Object count) {
    return 'قفل السجل (احسم $count اعتراضات أولًا)';
  }

  @override
  String get lockConfirm => 'قفل السجل الآن؟ لا يمكن التراجع عن ذلك.';

  @override
  String get afterLockingTitle => 'بعد القفل:';

  @override
  String get afterLockingText =>
      'افتح الاقتراع في يوم الانتخاب؛ يستخدم مكتب التحقق والأجهزة اللوحية السجل المقفل عبر شبكة Wi-Fi الخاصة بالمحطة. أعطِ رمز البصمة لوكلاء الأحزاب والمراقبين.';

  @override
  String get registerLocked => 'السجل مقفل';

  @override
  String get registerFingerprint => 'رمز البصمة';

  @override
  String lockedByLine(Object name, Object date) {
    return 'قفله $name في $date';
  }

  @override
  String get registerCheckValid =>
      'تم التحقق: السجل الموقع يطابق البيانات على هذا الحاسوب.';

  @override
  String get registerCheckBad =>
      'تحذير: السجل الموقع لا يطابق توقيعه. لا تستخدم سجل هذا الحاسوب؛ اتصل برئيس المركز.';

  @override
  String get registerCheckChanged =>
      'تحذير: تغيرت البيانات على هذا الحاسوب منذ قفل السجل. اتصل برئيس المركز.';

  @override
  String get errOpenObjections => 'احسم كل الاعتراضات قبل القفل.';

  @override
  String get errBallotNotSigned =>
      'وقّع ورقة الاقتراع في الإعداد قبل قفل السجل.';

  @override
  String get errEmptyRegister => 'لا يوجد ناخبون في السجل.';

  @override
  String get errVoterNotFound => 'لم يُعثر على رقم الناخب هذا في السجل.';

  @override
  String get errDecisionNotAllowed => 'هذا القرار لا يناسب هذا الاعتراض.';

  @override
  String get errAlreadyDecided => 'تم الحسم في هذا الاعتراض من قبل.';

  @override
  String get errInvalidDates =>
      'يجب أن يكون اليوم الأخير في اليوم الأول أو بعده.';

  @override
  String checkinDeskTitle(Object station) {
    return 'مكتب التحقق · $station';
  }

  @override
  String get findVoter => 'البحث عن ناخب';

  @override
  String get nameOrVoterNumber => 'الاسم أو رقم الناخب';

  @override
  String get scanHint =>
      'لمسح البطاقة، وجّه ماسح USB نحو رمز QR. سيكتب الرقم في هذا المربع.';

  @override
  String get photoFromRegistration => 'صورة التسجيل';

  @override
  String voterNoLine(Object number) {
    return 'رقم الناخب $number';
  }

  @override
  String get statusNotVoted => 'مسجل · لم يصوت';

  @override
  String get statusCheckedIn => 'تم التحقق منه مسبقًا';

  @override
  String get comparePhoto => 'قارن الصورة بالشخص الذي أمامك قبل التأكيد.';

  @override
  String get confirmIssueToken => 'تأكيد وإصدار رمز التصويت';

  @override
  String get tokenTitle => 'رمز تصويت لمرة واحدة';

  @override
  String get tokenNote =>
      'أعطِ هذا الرمز للناخب، مثلًا مكتوبًا على قسيمة. الرمز غير مرتبط بالصوت، لذلك يبقى الاقتراع سريًا.';

  @override
  String get nextVoter => 'الناخب التالي';

  @override
  String get manualTitle => 'لم يُعثر على الناخب أو توجد مشكلة في الجهاز؟';

  @override
  String get manualText =>
      'راجع السجل المطبوع وسجّل السبب، ثم أصدر الرمز يدويًا.';

  @override
  String get manualCheckin => 'تحقق يدوي';

  @override
  String get manualVoterNo => 'رقم الناخب في السجل المطبوع';

  @override
  String get manualReason => 'السبب';

  @override
  String get reasonCardLost => 'البطاقة مفقودة';

  @override
  String get reasonCardUnreadable => 'لا يمكن قراءة البطاقة';

  @override
  String get reasonPhotoMissing => 'لا توجد صورة أو الصورة غير واضحة';

  @override
  String get reasonDeviceProblem => 'مشكلة في الجهاز';

  @override
  String get reasonOther => 'أخرى (اشرح)';

  @override
  String get manualDetails => 'التفاصيل';

  @override
  String get cardReplaced =>
      'تم استبدال هذه البطاقة. اطلب البطاقة الجديدة أو استخدم التحقق اليدوي.';

  @override
  String get cardInvalid =>
      'تعذر التحقق من هذه البطاقة. استخدم السجل المطبوع والتحقق اليدوي.';

  @override
  String get cardNotOnRegister =>
      'رقم الناخب هذا غير موجود في السجل. راجع السجل المطبوع.';

  @override
  String get noVotersFound => 'لم يُعثر على ناخب. تحقق من الاسم أو الرقم.';

  @override
  String checkedInCount(Object count, Object total) {
    return 'تم التحقق: $count من $total';
  }

  @override
  String get alreadyHasToken => 'هذا الناخب حصل على رمز من قبل.';

  @override
  String get errPollsNotOpen =>
      'الاقتراع لم يُفتح بعد. يفتحه رئيس المركز من المراجعة والقفل.';

  @override
  String get errVoterRemoved => 'تم حذف هذا الناخب من السجل.';

  @override
  String get errReasonRequired => 'اختر سببًا وأضف التفاصيل.';

  @override
  String get errRegisterNotLocked => 'اقفل السجل قبل فتح الاقتراع.';

  @override
  String get openPolls => 'فتح الاقتراع';

  @override
  String get openPollsConfirm => 'فتح الاقتراع الآن؟ يمكن بدء التحقق بعد ذلك.';

  @override
  String get pollsOpen => 'الاقتراع مفتوح.';

  @override
  String get openCheckinDesk => 'مكتب التحقق';

  @override
  String get backToAdmin => 'العودة إلى الإدارة';

  @override
  String get statusJustCheckedIn => 'تم التحقق الآن. أعطِ الرمز للناخب.';

  @override
  String get officialBallot => 'ورقة اقتراع رسمية';

  @override
  String get typeCode => 'اكتب الرمز الذي أعطاك إياه المسؤول';

  @override
  String get startVoting => 'ابدأ التصويت';

  @override
  String get secrecyFooter => 'صوتك سري. لا أحد يستطيع أن يرى لمن تصوت.';

  @override
  String get numbersHelp => 'لكل مرشح رقم ورمز لمساعدتك في إيجاده.';

  @override
  String get poweredBy => 'Powered by Rakubavote';

  @override
  String get codeNotFound =>
      'لم يُعثر على هذا الرمز. تحقق من القسيمة أو اطلب مساعدة مسؤول.';

  @override
  String get codeUsed => 'هذا الرمز استُخدم من قبل. اطلب مساعدة مسؤول.';

  @override
  String get tooManyTries =>
      'اطلب مساعدة مسؤول من فضلك. يمكنك المحاولة مرة أخرى بعد دقيقة.';

  @override
  String get helpTitle => 'كيف تصوت';

  @override
  String get helpText =>
      '1. اكتب رمزك واضغط ابدأ التصويت.\n2. لكل منصب، اضغط على المرشح الذي تختاره أو اضغط لا اختيار.\n3. راجع اختياراتك ثم اضغط أكّد صوتي.\n\nصوتك سري. اطلب مساعدة مسؤول إذا احتجت.';

  @override
  String positionOf(Object current, Object total) {
    return 'المنصب $current من $total';
  }

  @override
  String get tapOneOrNoChoice => 'اضغط على مرشح واحد، أو اختر لا اختيار';

  @override
  String get tapOne => 'اضغط على مرشح واحد';

  @override
  String tapUpToOrNoChoice(Object count) {
    return 'اضغط على ما يصل إلى $count مرشحين، أو اختر لا اختيار';
  }

  @override
  String tapUpTo(Object count) {
    return 'اضغط على ما يصل إلى $count مرشحين';
  }

  @override
  String get noChoiceForPosition => 'لا اختيار لهذا المنصب';

  @override
  String get changeNote =>
      'الضغط على خيار آخر يغير اختيارك. يمكنك مراجعة كل شيء قبل التأكيد.';

  @override
  String nextPosition(Object title) {
    return 'التالي: $title';
  }

  @override
  String get reviewButton => 'مراجعة';

  @override
  String bigListHeader(Object count) {
    return '$count مرشحًا. اضغط على واحد، أو اكتب رقمه في الأسفل.';
  }

  @override
  String get candidateNumberLabel => 'رقم المرشح';

  @override
  String get showsMatching => 'يظهر المرشح المطابق';

  @override
  String get yourChoice => 'اختيارك';

  @override
  String get noCandidateWithNumber => 'لا يوجد مرشح بهذا الرقم.';

  @override
  String chosenCount(Object count, Object max) {
    return 'تم اختيار $count من $max';
  }

  @override
  String get checkChoices => 'راجع اختياراتك';

  @override
  String get notSavedUntil => 'لا يُحفظ صوتك حتى تضغط تأكيد.';

  @override
  String get change => 'تغيير';

  @override
  String get confirmMyVote => 'أكّد صوتي';

  @override
  String get cannotChangeAfter => 'بعد التأكيد لا يمكن تغيير اختياراتك.';

  @override
  String get codeUsedElsewhere =>
      'استُخدم هذا الرمز في كشك آخر. اطلب مساعدة مسؤول.';

  @override
  String get endTitle => 'انتهى';

  @override
  String get thankYou => 'شكرًا لك. تم تسجيل صوتك.';

  @override
  String get beepNote => 'يصدر صوت تنبيه طويل لتأكيد حفظ صوتك.';

  @override
  String clearsIn(Object seconds) {
    return 'ستُمسح هذه الشاشة بعد $seconds ثوانٍ للناخب التالي.';
  }

  @override
  String get boothSetupTitle => 'كشك التصويت';

  @override
  String get noBallotYet => 'لم تُحمّل ورقة اقتراع بعد.';

  @override
  String get ballotLoadedTitle => 'تم تحميل ورقة الاقتراع';

  @override
  String get ballotFingerprintCheck =>
      'تحقق من أن هذه البصمة تطابق البصمة على الحاسوب:';

  @override
  String stationIdLine(Object id) {
    return 'الحاسوب: $id';
  }

  @override
  String get startBooth => 'تشغيل كشك التصويت';

  @override
  String votesOnBooth(Object count) {
    return 'الأصوات في هذا الكشك: $count';
  }

  @override
  String get leaveBoothTitle => 'رمز المسؤول لمغادرة شاشة الكشك';

  @override
  String get leaveBooth => 'مغادرة';

  @override
  String get codesNote =>
      'تصل الرموز إلى هذا الكشك من الحاسوب عبر شبكة Wi-Fi الخاصة بالمركز.';

  @override
  String get errPackageMalformed => 'هذا الملف ليس ورقة اقتراع من Rakubavote.';

  @override
  String get errPackageSignature =>
      'توقيع ورقة الاقتراع غير صحيح. لا تستخدم هذا الملف.';

  @override
  String get errPackageWrongStation =>
      'ورقة الاقتراع هذه من حاسوب غير الحاسوب الذي يثق به هذا الكشك.';

  @override
  String get errPackageImage =>
      'صورة في ورقة الاقتراع مفقودة أو تغيرت. لا تستخدم هذا الملف.';

  @override
  String get errVotesExist => 'هذا الكشك يحتوي على أصوات لورقة اقتراع أخرى.';

  @override
  String get addDevice => 'إضافة جهاز لوحي';

  @override
  String get addDeviceNote =>
      'على الجهاز اللوحي اختر الاتصال بالحاسوب، ثم امسح رمز QR هذا أو اكتب العنوان والرمز. قارن معرّف الجهاز قبل الموافقة.';

  @override
  String get approve => 'موافقة';

  @override
  String boothVotesReceived(Object count) {
    return 'الأصوات المستلمة: $count';
  }

  @override
  String get boothVotesTitle => 'الأصوات من الأكشاك';

  @override
  String get boothVotesWaiting => 'في انتظار الأصوات';

  @override
  String boothsMissingConfirm(Object count) {
    return '$count كشك لم يرسل أصواته بعد. هل تعرض النتائج على أي حال؟ يمكنك العد مرة أخرى عند وصولها.';
  }

  @override
  String get checkDiffer => 'عدد المتحقَّق منهم يختلف عن الأصوات';

  @override
  String get checkMatch => 'عدد المتحقَّق منهم يطابق الأصوات';

  @override
  String get closePolls => 'إغلاق الاقتراع';

  @override
  String get closePollsConfirm =>
      'إغلاق الاقتراع الآن؟ لا يمكن التحقق من ناخبين آخرين.';

  @override
  String get closePollsNote =>
      'يتوقف التحقق. تُنهي الأكشاك عملها وترسل أصواتها إلى هذا الحاسوب.';

  @override
  String get connect => 'اتصال';

  @override
  String get connectToLaptop => 'الاتصال بالحاسوب';

  @override
  String get connectToLaptopNote =>
      'اطلب من رئيس المركز فتح الأجهزة على الحاسوب وإظهار رمز الاقتران.';

  @override
  String get connected => 'متصل';

  @override
  String get connectedToLaptop => 'متصل بالحاسوب';

  @override
  String get countAgain => 'العد مرة أخرى';

  @override
  String deviceIdLine(Object id) {
    return 'معرّف الجهاز: $id';
  }

  @override
  String get devicesTitle => 'الأجهزة';

  @override
  String get errBadBatch => 'تعذر التحقق من هذه الأصوات. لا تستخدم هذا الملف.';

  @override
  String get errCannotReachLaptop =>
      'تعذر الوصول إلى الحاسوب. تأكد أن هذا الجهاز على شبكة Wi-Fi الخاصة بالمركز.';

  @override
  String get errNotPaired =>
      'هذا الجهاز لم يعد مقترنًا بالحاسوب. أعد الاقتران.';

  @override
  String get errOlderBatch => 'لدى الحاسوب أصوات أحدث من هذا الكشك.';

  @override
  String get errOtherElectionBatch => 'هذه الأصوات لانتخاب آخر.';

  @override
  String get errPairingCode =>
      'لم يُقبل رمز الاقتران. تحقق من الرمز على الحاسوب.';

  @override
  String get errPairingRejected => 'لم يوافق الحاسوب على هذا الجهاز.';

  @override
  String get errPairingTimedOut =>
      'لم يرد الحاسوب في الوقت المحدد. حاول مرة أخرى.';

  @override
  String get errPollsNotClosed => 'أغلق الاقتراع أولًا.';

  @override
  String get errStartNetwork =>
      'تعذر تشغيل شبكة المركز. تحقق من Wi-Fi الحاسوب.';

  @override
  String get errUnknownBooth => 'هذه الأصوات من كشك لا يعرفه هذا الحاسوب.';

  @override
  String get errWrongLaptop => 'هذا ليس الحاسوب الظاهر في رمز QR.';

  @override
  String get invalidVotes => 'غير صالح';

  @override
  String issueBallotsVsCodes(Object ballots, Object codes) {
    return 'الأصوات ($ballots) تختلف عن الرموز المستخدمة ($codes).';
  }

  @override
  String get issueDamagedBallots =>
      'بعض أوراق الاقتراع كانت ناقصة أو تالفة ولم تُحسب. راجع سجل التدقيق.';

  @override
  String issueManual(Object count) {
    return '$count تحقق يدوي: راجع سجل التدقيق لمعرفة الأسباب.';
  }

  @override
  String issueNeverIssued(Object count) {
    return '$count رمز استُخدم في كشك ولم يصدره الحاسوب.';
  }

  @override
  String issueTwoBooths(Object count) {
    return '$count رمز استُخدم في كشكين أثناء انقطاع Wi-Fi.';
  }

  @override
  String issueUnusedCodes(Object count) {
    return '$count ناخب تم التحقق منه ولم يصوت.';
  }

  @override
  String laptopAddress(Object address) {
    return 'عنوان الحاسوب: $address';
  }

  @override
  String get laptopAddressField => 'عنوان الحاسوب';

  @override
  String laptopIdLine(Object id) {
    return 'معرّف الحاسوب: $id';
  }

  @override
  String get networkRunning => 'شبكة المركز تعمل.';

  @override
  String get noPairedBooths => 'لا توجد أكشاك مقترنة بعد.';

  @override
  String get noPairedDevices =>
      'لا توجد أجهزة لوحية مقترنة بعد. اعرض رمز الاقتران أعلاه لإضافة جهاز.';

  @override
  String get noWifiAddress =>
      'لا يوجد عنوان Wi-Fi لهذا الحاسوب. وصّله بموجّه المركز أو شغّل نقطة الاتصال.';

  @override
  String get notConnected => 'غير متصل';

  @override
  String pairRequestLine(Object label, Object role, Object id) {
    return '$label ($role) يريد الاتصال. معرّف الجهاز: $id';
  }

  @override
  String get pairedDevices => 'الأجهزة اللوحية المقترنة';

  @override
  String get pairingCode => 'رمز الاقتران';

  @override
  String get pairingCodeValid => 'يعمل الرمز لمدة 10 دقائق.';

  @override
  String get pollsClosedNote => 'شكرًا لك. اطلب مساعدة مسؤول إذا احتجت.';

  @override
  String get pollsClosedTitle => 'تم إغلاق الاقتراع';

  @override
  String get reconnecting => 'غير متصل. جارٍ المحاولة مرة أخرى…';

  @override
  String get removeDevice => 'إزالة';

  @override
  String removeDeviceConfirm(Object label) {
    return 'إزالة $label؟ لن تُحسب أصواته بعد ذلك.';
  }

  @override
  String get resultsAfterClosing => 'تظهر النتائج بعد إغلاق الاقتراع.';

  @override
  String resultsFingerprint(Object code) {
    return 'بصمة النتائج: $code';
  }

  @override
  String resultsSavedIn(Object path) {
    return 'تم حفظ النتائج في $path';
  }

  @override
  String get saveSignedFile => 'حفظ الملف الموقع على USB';

  @override
  String get scanLaptopQr => 'امسح رمز QR الخاص بالحاسوب';

  @override
  String get scanQrCard => 'مسح بطاقة QR';

  @override
  String get sendOnline => 'إرسال عبر الإنترنت (عند توفره)';

  @override
  String get sendOnlineOff => 'الإرسال عبر الإنترنت متوقف في هذا الانتخاب.';

  @override
  String get shareResults => 'مشاركة النتائج';

  @override
  String get shareResultsNote =>
      'ينسخ وكلاء الأحزاب والمراقبون رمز البصمة أو يمسحون رمز QR الموقع.';

  @override
  String get showPairingCode => 'إظهار رمز الاقتران';

  @override
  String get showResults => 'عرض النتائج';

  @override
  String get showSignedQr => 'إظهار رمز QR الموقع';

  @override
  String get startNetwork => 'تشغيل شبكة المركز';

  @override
  String get statCheck => 'التحقق';

  @override
  String get statCheckedIn => 'تم التحقق منهم';

  @override
  String get statRegistered => 'المسجلون';

  @override
  String get statVotes => 'الأصوات في الأجهزة';

  @override
  String stationLinkTitle(Object name) {
    return 'الحاسوب: $name';
  }

  @override
  String get stationNetwork => 'شبكة المركز';

  @override
  String get stationNetworkNote =>
      'تتصل الأجهزة اللوحية بهذا الحاسوب عبر شبكة Wi-Fi الخاصة بالمركز. لا يُستخدم الإنترنت.';

  @override
  String tieNotice(Object count, Object votes) {
    return 'تعادل: $count مرشحين لديهم $votes أصوات. تقرر اللجنة وفق قواعد الانتخاب.';
  }

  @override
  String votesSentToLaptop(Object count) {
    return 'الأصوات المرسلة إلى الحاسوب: $count';
  }

  @override
  String waitingApproval(Object id) {
    return 'في انتظار موافقة الحاسوب. تحقق على الحاسوب أن معرّف الجهاز هو $id.';
  }

  @override
  String get cardTitle => 'بطاقة تسجيل الناخب';

  @override
  String get cardFullName => 'الاسم الكامل';

  @override
  String get cardVoterNo => 'رقم الناخب';

  @override
  String get cardFee => 'الرسوم';

  @override
  String cardRegisteredLine(Object date, Object station) {
    return 'سُجل في $date في $station. غير قابلة للتحويل.';
  }

  @override
  String get cardQrNote => 'رقم الناخب + التوقيع فقط. لا بيانات شخصية.';

  @override
  String get cardOfficialSignature => 'مسؤول التسجيل: الاسم والتوقيع';

  @override
  String get cardOfficialSeal => 'الختم الرسمي';

  @override
  String feePaidReceipt(Object receipt) {
    return 'مدفوع · $receipt';
  }

  @override
  String get printCardsTitle => 'طباعة بطاقات الناخبين';

  @override
  String get cardLayout => 'حجم البطاقة';

  @override
  String get cardLayoutIdA4 =>
      'بطاقات بحجم الهوية على ورق A4 (10 في الصفحة، تُقص)';

  @override
  String get cardLayoutIdSingle => 'بطاقة هوية واحدة في الصفحة (طابعة بطاقات)';

  @override
  String get cardLayoutA6 => 'بطاقة A6 (أكبر)';

  @override
  String get printButton => 'طباعة';

  @override
  String get savePdf => 'حفظ PDF';

  @override
  String pdfSavedIn(Object path) {
    return 'تم حفظ PDF في $path';
  }

  @override
  String get cardPrinted => 'مطبوعة';

  @override
  String get cardNeedsReprint => 'بطاقة جديدة للطباعة';

  @override
  String printUnprinted(Object count) {
    return 'طباعة البطاقات غير المطبوعة ($count)';
  }

  @override
  String get noCardsToPrint => 'كل البطاقات مطبوعة.';

  @override
  String get printCard => 'طباعة البطاقة';

  @override
  String get replaceCard => 'استبدال بطاقة مفقودة';

  @override
  String get replaceReason => 'لماذا تحتاج بطاقة جديدة؟';

  @override
  String get replaceReasonLost => 'البطاقة مفقودة';

  @override
  String get replaceReasonDamaged => 'البطاقة تالفة';

  @override
  String get replaceCardDone =>
      'صدرت بطاقة جديدة. البطاقة القديمة لم تعد تعمل.';

  @override
  String cardIssueLine(Object issue) {
    return 'إصدار البطاقة: $issue';
  }

  @override
  String voterDetails(Object number) {
    return 'الناخب $number';
  }

  @override
  String get registerTitle => 'سجل الناخبين';

  @override
  String get registerDraftNote => 'مسودة: السجل غير مقفل بعد.';

  @override
  String registerLockedNote(Object code) {
    return 'سجل مقفل. البصمة: $code';
  }

  @override
  String printedOn(Object date) {
    return 'طُبع في $date';
  }

  @override
  String pageOf(Object page, Object pages) {
    return 'صفحة $page من $pages';
  }

  @override
  String registerTotal(Object count) {
    return '$count ناخبًا';
  }

  @override
  String get printRegisterTitle => 'طباعة السجل';

  @override
  String get printRegisterNote =>
      'للوحة الإعلانات وكنسخة احتياطية للتحقق اليدوي. الأسماء والأرقام والهويات والمجموعات فقط: لا صور ولا تفاصيل رسوم.';

  @override
  String get ballotComesFromLaptop =>
      'اتصل بالحاسوب. تصل ورقة الاقتراع من الحاسوب تلقائيًا.';

  @override
  String get poolTitle => 'رموز محمّلة مسبقًا (عند تعطل Wi-Fi)';

  @override
  String get poolLaptopNote =>
      'جهّز مجموعة الرموز قبل فتح الاقتراع وجميع الأكشاك متصلة. كل رمز يعطيه مكتب التحقق يعمل أيضًا في كشك فقد الاتصال بشبكة Wi-Fi.';

  @override
  String poolLaptopStatus(Object remaining, Object issued) {
    return '$remaining رمزًا جاهزًا، $issued أُعطيت';
  }

  @override
  String get poolPrepare => 'تجهيز مجموعة الرموز';

  @override
  String poolBoothReady(Object count) {
    return 'يحمل هذا الكشك $count رمزًا محمّلًا مسبقًا.';
  }

  @override
  String get poolBoothNote =>
      'استخدمها فقط إذا تعذر على هذا الكشك الوصول إلى الحاسوب. يلزم رمز المسؤول، ويُسجَّل التحويل.';

  @override
  String get poolStart => 'Wi-Fi متعطل: استخدم الرموز المحمّلة مسبقًا';

  @override
  String get poolStop => 'عاد Wi-Fi: أوقف استخدام الرموز المحمّلة مسبقًا';

  @override
  String get poolModeOn => 'الرموز المحمّلة مسبقًا مستخدمة في هذا الكشك.';

  @override
  String get kioskFull =>
      'قفل الكشك: كامل. لا يستطيع الناخبون مغادرة شاشة التصويت.';

  @override
  String get kioskPinningOnly =>
      'قفل الكشك: تثبيت الشاشة فقط. اطلب من الفني إعداد هذا الجهاز ككشك مقفل (راجع الدليل).';

  @override
  String get loadingDevice => 'جارٍ فتح هذا الجهاز…';

  @override
  String get loadingElection => 'جارٍ فتح الانتخاب…';

  @override
  String get loadingDuplicates => 'جارٍ البحث عن أسماء متشابهة في السجل…';

  @override
  String get deviceOpenFailed =>
      'تعذّر فتح البيانات المحفوظة على هذا الجهاز. أغلق Rakubavote وافتحه مرة أخرى. إذا تكرر ذلك، اطلب المساعدة من الشخص الذي أعدّ هذا الجهاز.';

  @override
  String get noVotersYet =>
      'لا يوجد ناخبون بعد. سجّل أول ناخب في النموذج على اليمين، أو استورد قائمة.';

  @override
  String get noVotersMatch =>
      'لا يوجد ناخب يطابق هذا البحث. تحقق من الإملاء أو الرقم.';
}
