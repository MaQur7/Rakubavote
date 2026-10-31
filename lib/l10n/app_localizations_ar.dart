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
}
