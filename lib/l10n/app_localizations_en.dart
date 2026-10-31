// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Rakubavote';

  @override
  String get tagline => 'Your vote, in the open.';

  @override
  String get chooseDeviceMode => 'What will this device be used for?';

  @override
  String get modeAdmin => 'Station admin';

  @override
  String get modeAdminHint =>
      'Laptop. Set up the election, register voters, close the polls and print results.';

  @override
  String get modeCheckin => 'Check-in desk';

  @override
  String get modeCheckinHint =>
      'Laptop or tablet. Find voters and give each one a voting code.';

  @override
  String get modeBooth => 'Voting booth';

  @override
  String get modeBoothHint => 'Tablet. Voters choose their candidates here.';

  @override
  String get yourVoteIsSecret => 'Your vote is secret.';

  @override
  String get askAnOfficial => 'Ask an official if you need help.';

  @override
  String get help => 'Help';

  @override
  String get languageName => 'English';
}
