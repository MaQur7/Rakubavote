import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_din.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('din'),
    Locale('en'),
  ];

  /// Product name. Never translate or change its spelling.
  ///
  /// In en, this message translates to:
  /// **'Rakubavote'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your vote, in the open.'**
  String get tagline;

  /// No description provided for @chooseDeviceMode.
  ///
  /// In en, this message translates to:
  /// **'What will this device be used for?'**
  String get chooseDeviceMode;

  /// No description provided for @modeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Station admin'**
  String get modeAdmin;

  /// No description provided for @modeAdminHint.
  ///
  /// In en, this message translates to:
  /// **'Laptop. Set up the election, register voters, close the polls and print results.'**
  String get modeAdminHint;

  /// No description provided for @modeCheckin.
  ///
  /// In en, this message translates to:
  /// **'Check-in desk'**
  String get modeCheckin;

  /// No description provided for @modeCheckinHint.
  ///
  /// In en, this message translates to:
  /// **'Laptop or tablet. Find voters and give each one a voting code.'**
  String get modeCheckinHint;

  /// No description provided for @modeBooth.
  ///
  /// In en, this message translates to:
  /// **'Voting booth'**
  String get modeBooth;

  /// No description provided for @modeBoothHint.
  ///
  /// In en, this message translates to:
  /// **'Tablet. Voters choose their candidates here.'**
  String get modeBoothHint;

  /// No description provided for @yourVoteIsSecret.
  ///
  /// In en, this message translates to:
  /// **'Your vote is secret.'**
  String get yourVoteIsSecret;

  /// No description provided for @askAnOfficial.
  ///
  /// In en, this message translates to:
  /// **'Ask an official if you need help.'**
  String get askAnOfficial;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @offlineSavedLaptop.
  ///
  /// In en, this message translates to:
  /// **'Offline · saved on this laptop'**
  String get offlineSavedLaptop;

  /// No description provided for @officialUseOnly.
  ///
  /// In en, this message translates to:
  /// **'Rakubavote · Official use only'**
  String get officialUseOnly;

  /// No description provided for @comingLater.
  ///
  /// In en, this message translates to:
  /// **'This part of the app comes in a later update.'**
  String get comingLater;

  /// No description provided for @setupDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up this device'**
  String get setupDeviceTitle;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'As it should appear in the audit log'**
  String get yourNameHint;

  /// No description provided for @choosePin.
  ///
  /// In en, this message translates to:
  /// **'Choose an officer PIN (6 to 12 digits)'**
  String get choosePin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Type the PIN again'**
  String get confirmPin;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The two PINs are not the same.'**
  String get pinsDoNotMatch;

  /// No description provided for @pinRule.
  ///
  /// In en, this message translates to:
  /// **'The PIN must be 6 to 12 digits.'**
  String get pinRule;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get nameRequired;

  /// No description provided for @setUpButton.
  ///
  /// In en, this message translates to:
  /// **'Set up this device'**
  String get setUpButton;

  /// No description provided for @pinWarning.
  ///
  /// In en, this message translates to:
  /// **'Keep the PIN secret. Without it nobody can open the data on this device, and it cannot be recovered.'**
  String get pinWarning;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock: {mode}'**
  String unlockTitle(Object mode);

  /// No description provided for @officerPin.
  ///
  /// In en, this message translates to:
  /// **'Officer PIN'**
  String get officerPin;

  /// No description provided for @unlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockButton;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'That PIN is not correct. Try again.'**
  String get wrongPin;

  /// No description provided for @lockDevice.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lockDevice;

  /// No description provided for @adminSuffix.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminSuffix;

  /// No description provided for @tabSetup.
  ///
  /// In en, this message translates to:
  /// **'1 Setup'**
  String get tabSetup;

  /// No description provided for @tabRegistration.
  ///
  /// In en, this message translates to:
  /// **'2 Registration'**
  String get tabRegistration;

  /// No description provided for @tabReview.
  ///
  /// In en, this message translates to:
  /// **'3 Review and lock'**
  String get tabReview;

  /// No description provided for @tabResults.
  ///
  /// In en, this message translates to:
  /// **'4 Results'**
  String get tabResults;

  /// No description provided for @newElection.
  ///
  /// In en, this message translates to:
  /// **'New election'**
  String get newElection;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @templateSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get templateSchool;

  /// No description provided for @templateAssociation.
  ///
  /// In en, this message translates to:
  /// **'Community association'**
  String get templateAssociation;

  /// No description provided for @templatePartyPrimary.
  ///
  /// In en, this message translates to:
  /// **'Party primary'**
  String get templatePartyPrimary;

  /// No description provided for @templateBlank.
  ///
  /// In en, this message translates to:
  /// **'Blank'**
  String get templateBlank;

  /// No description provided for @orgName.
  ///
  /// In en, this message translates to:
  /// **'Organization name'**
  String get orgName;

  /// No description provided for @electionName.
  ///
  /// In en, this message translates to:
  /// **'Election name'**
  String get electionName;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @stationName.
  ///
  /// In en, this message translates to:
  /// **'Station name'**
  String get stationName;

  /// No description provided for @ballotLanguages.
  ///
  /// In en, this message translates to:
  /// **'Ballot languages'**
  String get ballotLanguages;

  /// No description provided for @createElection.
  ///
  /// In en, this message translates to:
  /// **'Create election'**
  String get createElection;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This is needed.'**
  String get fieldRequired;

  /// No description provided for @electionDetails.
  ///
  /// In en, this message translates to:
  /// **'Election details'**
  String get electionDetails;

  /// No description provided for @idLabelField.
  ///
  /// In en, this message translates to:
  /// **'Name of the ID field'**
  String get idLabelField;

  /// No description provided for @groupLabelField.
  ///
  /// In en, this message translates to:
  /// **'Name of the group field'**
  String get groupLabelField;

  /// No description provided for @organizationLogo.
  ///
  /// In en, this message translates to:
  /// **'Organization logo'**
  String get organizationLogo;

  /// No description provided for @chooseLogo.
  ///
  /// In en, this message translates to:
  /// **'Choose logo'**
  String get chooseLogo;

  /// No description provided for @registrationFee.
  ///
  /// In en, this message translates to:
  /// **'Registration fee'**
  String get registrationFee;

  /// No description provided for @chargeFee.
  ///
  /// In en, this message translates to:
  /// **'Charge a fee'**
  String get chargeFee;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyEither.
  ///
  /// In en, this message translates to:
  /// **'SSP or USD'**
  String get currencyEither;

  /// No description provided for @unpaidPolicy.
  ///
  /// In en, this message translates to:
  /// **'If someone has not paid'**
  String get unpaidPolicy;

  /// No description provided for @unpaidBlock.
  ///
  /// In en, this message translates to:
  /// **'Do not register them'**
  String get unpaidBlock;

  /// No description provided for @unpaidAllow.
  ///
  /// In en, this message translates to:
  /// **'Register them and mark as not paid'**
  String get unpaidAllow;

  /// No description provided for @feeNote.
  ///
  /// In en, this message translates to:
  /// **'Set before registration starts. Locked once the first voter is registered.'**
  String get feeNote;

  /// No description provided for @feeLockedNote.
  ///
  /// In en, this message translates to:
  /// **'Locked: voters are already registered.'**
  String get feeLockedNote;

  /// No description provided for @saveFee.
  ///
  /// In en, this message translates to:
  /// **'Save fee'**
  String get saveFee;

  /// No description provided for @feeSaved.
  ///
  /// In en, this message translates to:
  /// **'Fee saved.'**
  String get feeSaved;

  /// No description provided for @schoolConsent.
  ///
  /// In en, this message translates to:
  /// **'School consent'**
  String get schoolConsent;

  /// No description provided for @schoolConsentText.
  ///
  /// In en, this message translates to:
  /// **'The school has given consent to register students under 18.'**
  String get schoolConsentText;

  /// No description provided for @schoolConsentRecordedBy.
  ///
  /// In en, this message translates to:
  /// **'Recorded by {name}'**
  String schoolConsentRecordedBy(Object name);

  /// No description provided for @positions.
  ///
  /// In en, this message translates to:
  /// **'Positions'**
  String get positions;

  /// No description provided for @addPosition.
  ///
  /// In en, this message translates to:
  /// **'Add position'**
  String get addPosition;

  /// No description provided for @newPositionTitle.
  ///
  /// In en, this message translates to:
  /// **'New position'**
  String get newPositionTitle;

  /// No description provided for @candidatesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No candidates} =1{1 candidate} other{{count} candidates}}'**
  String candidatesCount(num count);

  /// No description provided for @allowNoChoice.
  ///
  /// In en, this message translates to:
  /// **'Allow “No choice”'**
  String get allowNoChoice;

  /// No description provided for @chooseLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get chooseLabel;

  /// No description provided for @candidatesSuffix.
  ///
  /// In en, this message translates to:
  /// **'candidate(s)'**
  String get candidatesSuffix;

  /// No description provided for @positionTitleIn.
  ///
  /// In en, this message translates to:
  /// **'Title in {language}'**
  String positionTitleIn(Object language);

  /// No description provided for @colour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get colour;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

  /// No description provided for @deletePosition.
  ///
  /// In en, this message translates to:
  /// **'Delete position'**
  String get deletePosition;

  /// No description provided for @deletePositionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {title} and its candidates?'**
  String deletePositionConfirm(Object title);

  /// No description provided for @colNo.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get colNo;

  /// No description provided for @colPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get colPhoto;

  /// No description provided for @colName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get colName;

  /// No description provided for @colSymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get colSymbol;

  /// No description provided for @addCandidate.
  ///
  /// In en, this message translates to:
  /// **'Add candidate (take photo)'**
  String get addCandidate;

  /// No description provided for @editCandidate.
  ///
  /// In en, this message translates to:
  /// **'Edit candidate'**
  String get editCandidate;

  /// No description provided for @candidateNumber.
  ///
  /// In en, this message translates to:
  /// **'Candidate number'**
  String get candidateNumber;

  /// No description provided for @candidateName.
  ///
  /// In en, this message translates to:
  /// **'Candidate name'**
  String get candidateName;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @chooseSymbol.
  ///
  /// In en, this message translates to:
  /// **'Choose symbol'**
  String get chooseSymbol;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeImage;

  /// No description provided for @deleteCandidate.
  ///
  /// In en, this message translates to:
  /// **'Delete candidate'**
  String get deleteCandidate;

  /// No description provided for @printSampleBallot.
  ///
  /// In en, this message translates to:
  /// **'Print sample ballot'**
  String get printSampleBallot;

  /// No description provided for @saveAndSignBallot.
  ///
  /// In en, this message translates to:
  /// **'Save and sign ballot'**
  String get saveAndSignBallot;

  /// No description provided for @ballotSigned.
  ///
  /// In en, this message translates to:
  /// **'Ballot signed'**
  String get ballotSigned;

  /// No description provided for @ballotFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint: {code}'**
  String ballotFingerprint(Object code);

  /// No description provided for @ballotNotSigned.
  ///
  /// In en, this message translates to:
  /// **'The ballot is not signed yet.'**
  String get ballotNotSigned;

  /// No description provided for @ballotSignedNote.
  ///
  /// In en, this message translates to:
  /// **'Signed. Any change will need signing again.'**
  String get ballotSignedNote;

  /// No description provided for @noPositionSelected.
  ///
  /// In en, this message translates to:
  /// **'Add a position on the left to start.'**
  String get noPositionSelected;

  /// No description provided for @errFeeLocked.
  ///
  /// In en, this message translates to:
  /// **'The fee cannot change: voters are already registered.'**
  String get errFeeLocked;

  /// No description provided for @errBallotFrozen.
  ///
  /// In en, this message translates to:
  /// **'The ballot cannot change after the register is locked.'**
  String get errBallotFrozen;

  /// No description provided for @errBallotInvalid.
  ///
  /// In en, this message translates to:
  /// **'The ballot is not complete. {details}'**
  String errBallotInvalid(Object details);

  /// No description provided for @errDuplicateNumber.
  ///
  /// In en, this message translates to:
  /// **'Another candidate already has that number.'**
  String get errDuplicateNumber;

  /// No description provided for @errLowContrast.
  ///
  /// In en, this message translates to:
  /// **'That colour is too light for white text. Choose a darker one.'**
  String get errLowContrast;

  /// No description provided for @errInvalidValue.
  ///
  /// In en, this message translates to:
  /// **'Check the values and try again.'**
  String get errInvalidValue;

  /// No description provided for @registerAVoter.
  ///
  /// In en, this message translates to:
  /// **'Register a voter'**
  String get registerAVoter;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @photoUse.
  ///
  /// In en, this message translates to:
  /// **'Used only to confirm identity on election day. Deleted after the election.'**
  String get photoUse;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'As known in the community'**
  String get fullNameHint;

  /// No description provided for @feeLine.
  ///
  /// In en, this message translates to:
  /// **'Registration fee: {amount} {currency}'**
  String feeLine(Object amount, Object currency);

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @receiptNo.
  ///
  /// In en, this message translates to:
  /// **'Receipt no.'**
  String get receiptNo;

  /// No description provided for @possibleDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate:'**
  String get possibleDuplicate;

  /// No description provided for @duplicateNameText.
  ///
  /// In en, this message translates to:
  /// **'a voter with a similar name and the same group exists (Voter No. {number}). Check before saving.'**
  String duplicateNameText(Object number);

  /// No description provided for @duplicateIdText.
  ///
  /// In en, this message translates to:
  /// **'a voter with the same ID exists (Voter No. {number}). Check before saving.'**
  String duplicateIdText(Object number);

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @saveAndPrintCard.
  ///
  /// In en, this message translates to:
  /// **'Save and print voter card'**
  String get saveAndPrintCard;

  /// No description provided for @registeredVoters.
  ///
  /// In en, this message translates to:
  /// **'Registered voters'**
  String get registeredVoters;

  /// No description provided for @searchNameOrNumber.
  ///
  /// In en, this message translates to:
  /// **'Search name or number'**
  String get searchNameOrNumber;

  /// No description provided for @colVoterNo.
  ///
  /// In en, this message translates to:
  /// **'Voter No.'**
  String get colVoterNo;

  /// No description provided for @colGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get colGroup;

  /// No description provided for @colFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get colFee;

  /// No description provided for @colCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get colCard;

  /// No description provided for @feeNotPaid.
  ///
  /// In en, this message translates to:
  /// **'Not paid'**
  String get feeNotPaid;

  /// No description provided for @cardNotPrinted.
  ///
  /// In en, this message translates to:
  /// **'Not printed'**
  String get cardNotPrinted;

  /// No description provided for @showingVoters.
  ///
  /// In en, this message translates to:
  /// **'Showing {shown} of {total} registered voters'**
  String showingVoters(Object shown, Object total);

  /// No description provided for @feeSummary.
  ///
  /// In en, this message translates to:
  /// **'Fee summary'**
  String get feeSummary;

  /// No description provided for @importCsv.
  ///
  /// In en, this message translates to:
  /// **'Import list (CSV)'**
  String get importCsv;

  /// No description provided for @backupUsb.
  ///
  /// In en, this message translates to:
  /// **'Back up to USB'**
  String get backupUsb;

  /// No description provided for @voterSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved. Voter No. {number}.'**
  String voterSaved(Object number);

  /// No description provided for @errConsentMissing.
  ///
  /// In en, this message translates to:
  /// **'Record the school\'s consent in Setup before registering students.'**
  String get errConsentMissing;

  /// No description provided for @errNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the full name.'**
  String get errNameRequired;

  /// No description provided for @errFeeUnpaidBlocked.
  ///
  /// In en, this message translates to:
  /// **'This election only registers people who have paid the fee.'**
  String get errFeeUnpaidBlocked;

  /// No description provided for @errReceiptRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the receipt number.'**
  String get errReceiptRequired;

  /// No description provided for @errCurrencyNotAccepted.
  ///
  /// In en, this message translates to:
  /// **'Choose SSP or USD.'**
  String get errCurrencyNotAccepted;

  /// No description provided for @errRegisterLocked.
  ///
  /// In en, this message translates to:
  /// **'The register is locked. No names can be added.'**
  String get errRegisterLocked;

  /// No description provided for @errNoElection.
  ///
  /// In en, this message translates to:
  /// **'Create the election in Setup first.'**
  String get errNoElection;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Imported {imported}. Skipped {skipped}. Possible duplicates: {duplicates}.'**
  String importDone(Object duplicates, Object imported, Object skipped);

  /// No description provided for @importSkippedLine.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: {reason}'**
  String importSkippedLine(Object line, Object reason);

  /// No description provided for @backupDone.
  ///
  /// In en, this message translates to:
  /// **'Backup saved in {path}'**
  String backupDone(Object path);

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'The backup could not be saved. Check the USB drive and try again.'**
  String get backupFailed;

  /// No description provided for @totalsByCurrency.
  ///
  /// In en, this message translates to:
  /// **'Totals by currency'**
  String get totalsByCurrency;

  /// No description provided for @totalsByOfficial.
  ///
  /// In en, this message translates to:
  /// **'Totals by official'**
  String get totalsByOfficial;

  /// No description provided for @paidCount.
  ///
  /// In en, this message translates to:
  /// **'Paid: {count}'**
  String paidCount(Object count);

  /// No description provided for @unpaidCount.
  ///
  /// In en, this message translates to:
  /// **'Not paid: {count}'**
  String unpaidCount(Object count);

  /// No description provided for @flaggedCount.
  ///
  /// In en, this message translates to:
  /// **'Registered without paying: {count}'**
  String flaggedCount(Object count);

  /// No description provided for @noFee.
  ///
  /// In en, this message translates to:
  /// **'This election has no registration fee.'**
  String get noFee;

  /// No description provided for @photoFailed.
  ///
  /// In en, this message translates to:
  /// **'No photo was taken. You can try again.'**
  String get photoFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'din', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'din':
      return AppLocalizationsDin();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
