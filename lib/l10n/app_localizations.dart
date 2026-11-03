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
  /// **'Laptop. Set up the election, register voters, close the polls and show the results.'**
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
  String importDone(Object imported, Object skipped, Object duplicates);

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

  /// No description provided for @registeredVotersStat.
  ///
  /// In en, this message translates to:
  /// **'Registered voters'**
  String get registeredVotersStat;

  /// No description provided for @displayPeriod.
  ///
  /// In en, this message translates to:
  /// **'Public display period'**
  String get displayPeriod;

  /// No description provided for @displayPeriodRange.
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String displayPeriodRange(Object start, Object end);

  /// No description provided for @displayPeriodNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet'**
  String get displayPeriodNotSet;

  /// No description provided for @setDates.
  ///
  /// In en, this message translates to:
  /// **'Set dates'**
  String get setDates;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'First day'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'Last day'**
  String get endDate;

  /// No description provided for @openObjections.
  ///
  /// In en, this message translates to:
  /// **'Open objections'**
  String get openObjections;

  /// No description provided for @objectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Objections and corrections'**
  String get objectionsTitle;

  /// No description provided for @objectionsNote.
  ///
  /// In en, this message translates to:
  /// **'Every decision is saved in the audit log with the official\'s name and time.'**
  String get objectionsNote;

  /// No description provided for @noObjections.
  ///
  /// In en, this message translates to:
  /// **'No objections recorded. Objections raised during the public display appear here.'**
  String get noObjections;

  /// No description provided for @raiseObjection.
  ///
  /// In en, this message translates to:
  /// **'Record an objection'**
  String get raiseObjection;

  /// No description provided for @checkDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Check for duplicates'**
  String get checkDuplicates;

  /// No description provided for @objectionKind.
  ///
  /// In en, this message translates to:
  /// **'What is the objection?'**
  String get objectionKind;

  /// No description provided for @kindDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate'**
  String get kindDuplicate;

  /// No description provided for @kindMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing name'**
  String get kindMissing;

  /// No description provided for @kindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get kindOther;

  /// No description provided for @voterNumberField.
  ///
  /// In en, this message translates to:
  /// **'Voter No.'**
  String get voterNumberField;

  /// No description provided for @otherVoterNumberField.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicate of Voter No.'**
  String get otherVoterNumberField;

  /// No description provided for @claimantNameField.
  ///
  /// In en, this message translates to:
  /// **'Name of the person who is missing'**
  String get claimantNameField;

  /// No description provided for @raisedByField.
  ///
  /// In en, this message translates to:
  /// **'Name of the person objecting'**
  String get raisedByField;

  /// No description provided for @detailField.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailField;

  /// No description provided for @duplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'Voter No. {subject} · possible duplicate of {other}'**
  String duplicateTitle(Object subject, Object other);

  /// No description provided for @missingTitle.
  ///
  /// In en, this message translates to:
  /// **'Missing name: {name}'**
  String missingTitle(Object name);

  /// No description provided for @otherTitle.
  ///
  /// In en, this message translates to:
  /// **'Voter No. {subject}: {detail}'**
  String otherTitle(Object subject, Object detail);

  /// No description provided for @raisedByLine.
  ///
  /// In en, this message translates to:
  /// **'Raised by {name} on {date}'**
  String raisedByLine(Object name, Object date);

  /// No description provided for @decidedLine.
  ///
  /// In en, this message translates to:
  /// **'Decided by {name} on {date}: {decision}'**
  String decidedLine(Object name, Object date, Object decision);

  /// No description provided for @keepBoth.
  ///
  /// In en, this message translates to:
  /// **'Keep both'**
  String get keepBoth;

  /// No description provided for @removeVoter.
  ///
  /// In en, this message translates to:
  /// **'Remove {number}'**
  String removeVoter(Object number);

  /// No description provided for @addVoter.
  ///
  /// In en, this message translates to:
  /// **'Add voter'**
  String get addVoter;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @upheld.
  ///
  /// In en, this message translates to:
  /// **'Upheld'**
  String get upheld;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @decisionKeepBoth.
  ///
  /// In en, this message translates to:
  /// **'kept both'**
  String get decisionKeepBoth;

  /// No description provided for @decisionRemove.
  ///
  /// In en, this message translates to:
  /// **'removed'**
  String get decisionRemove;

  /// No description provided for @decisionAdd.
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get decisionAdd;

  /// No description provided for @decisionReject.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get decisionReject;

  /// No description provided for @decisionUpheld.
  ///
  /// In en, this message translates to:
  /// **'upheld'**
  String get decisionUpheld;

  /// No description provided for @decisionRejected.
  ///
  /// In en, this message translates to:
  /// **'rejected'**
  String get decisionRejected;

  /// No description provided for @noDuplicatesFound.
  ///
  /// In en, this message translates to:
  /// **'No possible duplicates found.'**
  String get noDuplicatesFound;

  /// No description provided for @duplicatePairsTitle.
  ///
  /// In en, this message translates to:
  /// **'Possible duplicates'**
  String get duplicatePairsTitle;

  /// No description provided for @duplicatePairLine.
  ///
  /// In en, this message translates to:
  /// **'{a} and {b}'**
  String duplicatePairLine(Object a, Object b);

  /// No description provided for @raiseThis.
  ///
  /// In en, this message translates to:
  /// **'Record as objection'**
  String get raiseThis;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock the register'**
  String get lockTitle;

  /// No description provided for @lockText.
  ///
  /// In en, this message translates to:
  /// **'After locking, no names can be added or removed. The laptop creates a signed copy and a fingerprint code that anyone can check.'**
  String get lockText;

  /// No description provided for @printRegister.
  ///
  /// In en, this message translates to:
  /// **'Print register for notice board'**
  String get printRegister;

  /// No description provided for @lockButton.
  ///
  /// In en, this message translates to:
  /// **'Lock register'**
  String get lockButton;

  /// No description provided for @lockButtonBlocked.
  ///
  /// In en, this message translates to:
  /// **'Lock register (resolve {count} objections first)'**
  String lockButtonBlocked(Object count);

  /// No description provided for @lockConfirm.
  ///
  /// In en, this message translates to:
  /// **'Lock the register now? This cannot be undone.'**
  String get lockConfirm;

  /// No description provided for @afterLockingTitle.
  ///
  /// In en, this message translates to:
  /// **'After locking:'**
  String get afterLockingTitle;

  /// No description provided for @afterLockingText.
  ///
  /// In en, this message translates to:
  /// **'open the polls when the day comes; the check-in desk and tablets use the locked register over the station Wi-Fi. Give the fingerprint code to party agents and observers.'**
  String get afterLockingText;

  /// No description provided for @registerLocked.
  ///
  /// In en, this message translates to:
  /// **'The register is locked'**
  String get registerLocked;

  /// No description provided for @registerFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint code'**
  String get registerFingerprint;

  /// No description provided for @lockedByLine.
  ///
  /// In en, this message translates to:
  /// **'Locked by {name} on {date}'**
  String lockedByLine(Object name, Object date);

  /// No description provided for @registerCheckValid.
  ///
  /// In en, this message translates to:
  /// **'Checked: the signed register matches the data on this laptop.'**
  String get registerCheckValid;

  /// No description provided for @registerCheckBad.
  ///
  /// In en, this message translates to:
  /// **'Warning: the signed register does not match its signature. Do not use this laptop\'s register; call the presiding officer.'**
  String get registerCheckBad;

  /// No description provided for @registerCheckChanged.
  ///
  /// In en, this message translates to:
  /// **'Warning: the data on this laptop has changed since the register was locked. Call the presiding officer.'**
  String get registerCheckChanged;

  /// No description provided for @errOpenObjections.
  ///
  /// In en, this message translates to:
  /// **'Resolve all objections before locking.'**
  String get errOpenObjections;

  /// No description provided for @errBallotNotSigned.
  ///
  /// In en, this message translates to:
  /// **'Sign the ballot in Setup before locking the register.'**
  String get errBallotNotSigned;

  /// No description provided for @errEmptyRegister.
  ///
  /// In en, this message translates to:
  /// **'There are no voters on the register.'**
  String get errEmptyRegister;

  /// No description provided for @errVoterNotFound.
  ///
  /// In en, this message translates to:
  /// **'That voter number was not found on the register.'**
  String get errVoterNotFound;

  /// No description provided for @errDecisionNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'That decision does not fit this objection.'**
  String get errDecisionNotAllowed;

  /// No description provided for @errAlreadyDecided.
  ///
  /// In en, this message translates to:
  /// **'This objection has already been decided.'**
  String get errAlreadyDecided;

  /// No description provided for @errInvalidDates.
  ///
  /// In en, this message translates to:
  /// **'The last day must be on or after the first day.'**
  String get errInvalidDates;

  /// No description provided for @checkinDeskTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in desk · {station}'**
  String checkinDeskTitle(Object station);

  /// No description provided for @findVoter.
  ///
  /// In en, this message translates to:
  /// **'Find voter'**
  String get findVoter;

  /// No description provided for @nameOrVoterNumber.
  ///
  /// In en, this message translates to:
  /// **'Name or voter number'**
  String get nameOrVoterNumber;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'To scan a card, point the USB scanner at the QR code. It types into this box.'**
  String get scanHint;

  /// No description provided for @photoFromRegistration.
  ///
  /// In en, this message translates to:
  /// **'Photo from registration'**
  String get photoFromRegistration;

  /// No description provided for @voterNoLine.
  ///
  /// In en, this message translates to:
  /// **'Voter No. {number}'**
  String voterNoLine(Object number);

  /// No description provided for @statusNotVoted.
  ///
  /// In en, this message translates to:
  /// **'Registered · Has not voted'**
  String get statusNotVoted;

  /// No description provided for @statusCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Already checked in'**
  String get statusCheckedIn;

  /// No description provided for @comparePhoto.
  ///
  /// In en, this message translates to:
  /// **'Compare the photo with the person in front of you before confirming.'**
  String get comparePhoto;

  /// No description provided for @confirmIssueToken.
  ///
  /// In en, this message translates to:
  /// **'Confirm and give a voting code'**
  String get confirmIssueToken;

  /// No description provided for @tokenTitle.
  ///
  /// In en, this message translates to:
  /// **'One-time voting code'**
  String get tokenTitle;

  /// No description provided for @tokenNote.
  ///
  /// In en, this message translates to:
  /// **'Give this code to the voter, for example written on a slip. It is not linked to the vote, so the ballot stays secret.'**
  String get tokenNote;

  /// No description provided for @nextVoter.
  ///
  /// In en, this message translates to:
  /// **'Next voter'**
  String get nextVoter;

  /// No description provided for @manualTitle.
  ///
  /// In en, this message translates to:
  /// **'Voter not found or device problem?'**
  String get manualTitle;

  /// No description provided for @manualText.
  ///
  /// In en, this message translates to:
  /// **'Check the printed register, record the reason, then give a voting code manually.'**
  String get manualText;

  /// No description provided for @manualCheckin.
  ///
  /// In en, this message translates to:
  /// **'Manual check-in'**
  String get manualCheckin;

  /// No description provided for @manualVoterNo.
  ///
  /// In en, this message translates to:
  /// **'Voter No. on the printed register'**
  String get manualVoterNo;

  /// No description provided for @manualReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get manualReason;

  /// No description provided for @reasonCardLost.
  ///
  /// In en, this message translates to:
  /// **'Card lost'**
  String get reasonCardLost;

  /// No description provided for @reasonCardUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Card cannot be read'**
  String get reasonCardUnreadable;

  /// No description provided for @reasonPhotoMissing.
  ///
  /// In en, this message translates to:
  /// **'No photo or photo unclear'**
  String get reasonPhotoMissing;

  /// No description provided for @reasonDeviceProblem.
  ///
  /// In en, this message translates to:
  /// **'Device problem'**
  String get reasonDeviceProblem;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other (explain)'**
  String get reasonOther;

  /// No description provided for @manualDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get manualDetails;

  /// No description provided for @cardReplaced.
  ///
  /// In en, this message translates to:
  /// **'This card was replaced. Ask for the new card, or use manual check-in.'**
  String get cardReplaced;

  /// No description provided for @cardInvalid.
  ///
  /// In en, this message translates to:
  /// **'This card could not be checked. Use the printed register and manual check-in.'**
  String get cardInvalid;

  /// No description provided for @cardNotOnRegister.
  ///
  /// In en, this message translates to:
  /// **'This voter number is not on the register. Check the printed register.'**
  String get cardNotOnRegister;

  /// No description provided for @noVotersFound.
  ///
  /// In en, this message translates to:
  /// **'No voter found. Check the spelling or the number.'**
  String get noVotersFound;

  /// No description provided for @checkedInCount.
  ///
  /// In en, this message translates to:
  /// **'Checked in: {count} of {total}'**
  String checkedInCount(Object count, Object total);

  /// No description provided for @alreadyHasToken.
  ///
  /// In en, this message translates to:
  /// **'This voter has already received a voting code.'**
  String get alreadyHasToken;

  /// No description provided for @errPollsNotOpen.
  ///
  /// In en, this message translates to:
  /// **'The polls are not open yet. The presiding officer opens them in Review and lock.'**
  String get errPollsNotOpen;

  /// No description provided for @errVoterRemoved.
  ///
  /// In en, this message translates to:
  /// **'This voter was removed from the register.'**
  String get errVoterRemoved;

  /// No description provided for @errReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a reason and add details.'**
  String get errReasonRequired;

  /// No description provided for @errRegisterNotLocked.
  ///
  /// In en, this message translates to:
  /// **'Lock the register before opening the polls.'**
  String get errRegisterNotLocked;

  /// No description provided for @openPolls.
  ///
  /// In en, this message translates to:
  /// **'Open the polls'**
  String get openPolls;

  /// No description provided for @openPollsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Open the polls now? Check-in can start after this.'**
  String get openPollsConfirm;

  /// No description provided for @pollsOpen.
  ///
  /// In en, this message translates to:
  /// **'The polls are open.'**
  String get pollsOpen;

  /// No description provided for @openCheckinDesk.
  ///
  /// In en, this message translates to:
  /// **'Check-in desk'**
  String get openCheckinDesk;

  /// No description provided for @backToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Back to admin'**
  String get backToAdmin;

  /// No description provided for @statusJustCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in now. Give the code to the voter.'**
  String get statusJustCheckedIn;

  /// No description provided for @officialBallot.
  ///
  /// In en, this message translates to:
  /// **'Official ballot'**
  String get officialBallot;

  /// No description provided for @typeCode.
  ///
  /// In en, this message translates to:
  /// **'Type the code the official gave you'**
  String get typeCode;

  /// No description provided for @startVoting.
  ///
  /// In en, this message translates to:
  /// **'Start voting'**
  String get startVoting;

  /// No description provided for @secrecyFooter.
  ///
  /// In en, this message translates to:
  /// **'Your vote is secret. Nobody can see who you vote for.'**
  String get secrecyFooter;

  /// No description provided for @numbersHelp.
  ///
  /// In en, this message translates to:
  /// **'Each candidate has a number and a symbol to help you find them.'**
  String get numbersHelp;

  /// No description provided for @poweredBy.
  ///
  /// In en, this message translates to:
  /// **'Powered by Rakubavote'**
  String get poweredBy;

  /// No description provided for @codeNotFound.
  ///
  /// In en, this message translates to:
  /// **'That code was not found. Check your slip or ask an official.'**
  String get codeNotFound;

  /// No description provided for @codeUsed.
  ///
  /// In en, this message translates to:
  /// **'This code has already been used. Ask an official.'**
  String get codeUsed;

  /// No description provided for @tooManyTries.
  ///
  /// In en, this message translates to:
  /// **'Please ask an official for help. You can try again in one minute.'**
  String get tooManyTries;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'How to vote'**
  String get helpTitle;

  /// No description provided for @helpText.
  ///
  /// In en, this message translates to:
  /// **'1. Type your code and press Start voting.\n2. For each position, tap the candidate you choose, or tap No choice.\n3. Check your choices, then press Confirm my vote.\n\nYour vote is secret. Ask an official if you need help.'**
  String get helpText;

  /// No description provided for @positionOf.
  ///
  /// In en, this message translates to:
  /// **'Position {current} of {total}'**
  String positionOf(Object current, Object total);

  /// No description provided for @tapOneOrNoChoice.
  ///
  /// In en, this message translates to:
  /// **'Tap one candidate, or choose No choice'**
  String get tapOneOrNoChoice;

  /// No description provided for @tapOne.
  ///
  /// In en, this message translates to:
  /// **'Tap one candidate'**
  String get tapOne;

  /// No description provided for @tapUpToOrNoChoice.
  ///
  /// In en, this message translates to:
  /// **'Tap up to {count} candidates, or choose No choice'**
  String tapUpToOrNoChoice(Object count);

  /// No description provided for @tapUpTo.
  ///
  /// In en, this message translates to:
  /// **'Tap up to {count} candidates'**
  String tapUpTo(Object count);

  /// No description provided for @noChoiceForPosition.
  ///
  /// In en, this message translates to:
  /// **'No choice for this position'**
  String get noChoiceForPosition;

  /// No description provided for @changeNote.
  ///
  /// In en, this message translates to:
  /// **'Tapping another option changes your choice. You can check everything before confirming.'**
  String get changeNote;

  /// No description provided for @nextPosition.
  ///
  /// In en, this message translates to:
  /// **'Next: {title}'**
  String nextPosition(Object title);

  /// No description provided for @reviewButton.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewButton;

  /// No description provided for @bigListHeader.
  ///
  /// In en, this message translates to:
  /// **'{count} candidates. Tap one, or type their number below.'**
  String bigListHeader(Object count);

  /// No description provided for @candidateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Candidate number'**
  String get candidateNumberLabel;

  /// No description provided for @showsMatching.
  ///
  /// In en, this message translates to:
  /// **'Shows the matching candidate'**
  String get showsMatching;

  /// No description provided for @yourChoice.
  ///
  /// In en, this message translates to:
  /// **'Your choice'**
  String get yourChoice;

  /// No description provided for @noCandidateWithNumber.
  ///
  /// In en, this message translates to:
  /// **'There is no candidate with that number.'**
  String get noCandidateWithNumber;

  /// No description provided for @chosenCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} chosen'**
  String chosenCount(Object count, Object max);

  /// No description provided for @checkChoices.
  ///
  /// In en, this message translates to:
  /// **'Check your choices'**
  String get checkChoices;

  /// No description provided for @notSavedUntil.
  ///
  /// In en, this message translates to:
  /// **'Your vote is not saved until you press Confirm.'**
  String get notSavedUntil;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @confirmMyVote.
  ///
  /// In en, this message translates to:
  /// **'Confirm my vote'**
  String get confirmMyVote;

  /// No description provided for @cannotChangeAfter.
  ///
  /// In en, this message translates to:
  /// **'After confirming, your choices cannot be changed.'**
  String get cannotChangeAfter;

  /// No description provided for @codeUsedElsewhere.
  ///
  /// In en, this message translates to:
  /// **'This code was already used at another booth. Ask an official.'**
  String get codeUsedElsewhere;

  /// No description provided for @endTitle.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endTitle;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you. Your vote has been recorded.'**
  String get thankYou;

  /// No description provided for @beepNote.
  ///
  /// In en, this message translates to:
  /// **'A long beep sounds to confirm your vote is saved.'**
  String get beepNote;

  /// No description provided for @clearsIn.
  ///
  /// In en, this message translates to:
  /// **'This screen will clear in {seconds} seconds for the next voter.'**
  String clearsIn(Object seconds);

  /// No description provided for @boothSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Voting booth'**
  String get boothSetupTitle;

  /// No description provided for @noBallotYet.
  ///
  /// In en, this message translates to:
  /// **'No ballot loaded yet.'**
  String get noBallotYet;

  /// No description provided for @ballotLoadedTitle.
  ///
  /// In en, this message translates to:
  /// **'Ballot loaded'**
  String get ballotLoadedTitle;

  /// No description provided for @ballotFingerprintCheck.
  ///
  /// In en, this message translates to:
  /// **'Check that this fingerprint matches the one on the laptop:'**
  String get ballotFingerprintCheck;

  /// No description provided for @stationIdLine.
  ///
  /// In en, this message translates to:
  /// **'Laptop: {id}'**
  String stationIdLine(Object id);

  /// No description provided for @startBooth.
  ///
  /// In en, this message translates to:
  /// **'Start voting booth'**
  String get startBooth;

  /// No description provided for @votesOnBooth.
  ///
  /// In en, this message translates to:
  /// **'Votes on this booth: {count}'**
  String votesOnBooth(Object count);

  /// No description provided for @leaveBoothTitle.
  ///
  /// In en, this message translates to:
  /// **'Officer PIN to leave the booth screen'**
  String get leaveBoothTitle;

  /// No description provided for @leaveBooth.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leaveBooth;

  /// No description provided for @codesNote.
  ///
  /// In en, this message translates to:
  /// **'Codes reach this booth from the laptop over the station Wi-Fi.'**
  String get codesNote;

  /// No description provided for @errPackageMalformed.
  ///
  /// In en, this message translates to:
  /// **'This file is not a Rakubavote ballot.'**
  String get errPackageMalformed;

  /// No description provided for @errPackageSignature.
  ///
  /// In en, this message translates to:
  /// **'The ballot\'s signature does not check. Do not use this file.'**
  String get errPackageSignature;

  /// No description provided for @errPackageWrongStation.
  ///
  /// In en, this message translates to:
  /// **'This ballot comes from a different laptop than the one this booth trusts.'**
  String get errPackageWrongStation;

  /// No description provided for @errPackageImage.
  ///
  /// In en, this message translates to:
  /// **'An image in this ballot is missing or was changed. Do not use this file.'**
  String get errPackageImage;

  /// No description provided for @errVotesExist.
  ///
  /// In en, this message translates to:
  /// **'This booth already has votes for another ballot.'**
  String get errVotesExist;

  /// No description provided for @addDevice.
  ///
  /// In en, this message translates to:
  /// **'Add a tablet'**
  String get addDevice;

  /// No description provided for @addDeviceNote.
  ///
  /// In en, this message translates to:
  /// **'On the tablet, choose Connect to the laptop, then scan this QR code or type the address and code. Compare the device id before approving.'**
  String get addDeviceNote;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @boothVotesReceived.
  ///
  /// In en, this message translates to:
  /// **'Votes received: {count}'**
  String boothVotesReceived(Object count);

  /// No description provided for @boothVotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Votes from the booths'**
  String get boothVotesTitle;

  /// No description provided for @boothVotesWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for votes'**
  String get boothVotesWaiting;

  /// No description provided for @boothsMissingConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count} booth(s) have not sent their votes yet. Show results anyway? You can count again when they arrive.'**
  String boothsMissingConfirm(Object count);

  /// No description provided for @checkDiffer.
  ///
  /// In en, this message translates to:
  /// **'Check-ins and votes differ'**
  String get checkDiffer;

  /// No description provided for @checkMatch.
  ///
  /// In en, this message translates to:
  /// **'Check-ins match votes'**
  String get checkMatch;

  /// No description provided for @closePolls.
  ///
  /// In en, this message translates to:
  /// **'Close the polls'**
  String get closePolls;

  /// No description provided for @closePollsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Close the polls now? No more voters can be checked in.'**
  String get closePollsConfirm;

  /// No description provided for @closePollsNote.
  ///
  /// In en, this message translates to:
  /// **'Check-in stops. The booths finish and send their votes to this laptop.'**
  String get closePollsNote;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connectToLaptop.
  ///
  /// In en, this message translates to:
  /// **'Connect to the laptop'**
  String get connectToLaptop;

  /// No description provided for @connectToLaptopNote.
  ///
  /// In en, this message translates to:
  /// **'Ask the presiding officer to open Devices on the laptop and show the pairing code.'**
  String get connectToLaptopNote;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @connectedToLaptop.
  ///
  /// In en, this message translates to:
  /// **'Connected to the laptop'**
  String get connectedToLaptop;

  /// No description provided for @countAgain.
  ///
  /// In en, this message translates to:
  /// **'Count again'**
  String get countAgain;

  /// No description provided for @deviceIdLine.
  ///
  /// In en, this message translates to:
  /// **'Device id: {id}'**
  String deviceIdLine(Object id);

  /// No description provided for @devicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTitle;

  /// No description provided for @errBadBatch.
  ///
  /// In en, this message translates to:
  /// **'These votes could not be checked. Do not use this file.'**
  String get errBadBatch;

  /// No description provided for @errCannotReachLaptop.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the laptop. Check that this device is on the station Wi-Fi.'**
  String get errCannotReachLaptop;

  /// No description provided for @errNotPaired.
  ///
  /// In en, this message translates to:
  /// **'This device is not paired with the laptop any more. Pair it again.'**
  String get errNotPaired;

  /// No description provided for @errOlderBatch.
  ///
  /// In en, this message translates to:
  /// **'The laptop already has newer votes from this booth.'**
  String get errOlderBatch;

  /// No description provided for @errOtherElectionBatch.
  ///
  /// In en, this message translates to:
  /// **'These votes are for a different election.'**
  String get errOtherElectionBatch;

  /// No description provided for @errPairingCode.
  ///
  /// In en, this message translates to:
  /// **'That pairing code was not accepted. Check the code on the laptop.'**
  String get errPairingCode;

  /// No description provided for @errPairingRejected.
  ///
  /// In en, this message translates to:
  /// **'The laptop did not approve this device.'**
  String get errPairingRejected;

  /// No description provided for @errPairingTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The laptop did not answer in time. Try again.'**
  String get errPairingTimedOut;

  /// No description provided for @errPollsNotClosed.
  ///
  /// In en, this message translates to:
  /// **'Close the polls first.'**
  String get errPollsNotClosed;

  /// No description provided for @errStartNetwork.
  ///
  /// In en, this message translates to:
  /// **'The station network could not start. Check the laptop\'s Wi-Fi.'**
  String get errStartNetwork;

  /// No description provided for @errUnknownBooth.
  ///
  /// In en, this message translates to:
  /// **'These votes come from a booth this laptop does not know.'**
  String get errUnknownBooth;

  /// No description provided for @errWrongLaptop.
  ///
  /// In en, this message translates to:
  /// **'This is not the laptop shown in the QR code.'**
  String get errWrongLaptop;

  /// No description provided for @invalidVotes.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalidVotes;

  /// No description provided for @issueBallotsVsCodes.
  ///
  /// In en, this message translates to:
  /// **'Votes ({ballots}) differ from codes used ({codes}).'**
  String issueBallotsVsCodes(Object ballots, Object codes);

  /// No description provided for @issueDamagedBallots.
  ///
  /// In en, this message translates to:
  /// **'Some ballots were incomplete or damaged and were not counted. Check the audit log.'**
  String get issueDamagedBallots;

  /// No description provided for @issueManual.
  ///
  /// In en, this message translates to:
  /// **'{count} manual check-in(s): see the audit log for reasons.'**
  String issueManual(Object count);

  /// No description provided for @issueNeverIssued.
  ///
  /// In en, this message translates to:
  /// **'{count} code(s) used at a booth were never issued by the laptop.'**
  String issueNeverIssued(Object count);

  /// No description provided for @issueTwoBooths.
  ///
  /// In en, this message translates to:
  /// **'{count} code(s) were used at two booths while the Wi-Fi was down.'**
  String issueTwoBooths(Object count);

  /// No description provided for @issueUnusedCodes.
  ///
  /// In en, this message translates to:
  /// **'{count} checked-in voter(s) did not vote.'**
  String issueUnusedCodes(Object count);

  /// No description provided for @laptopAddress.
  ///
  /// In en, this message translates to:
  /// **'Laptop address: {address}'**
  String laptopAddress(Object address);

  /// No description provided for @laptopAddressField.
  ///
  /// In en, this message translates to:
  /// **'Laptop address'**
  String get laptopAddressField;

  /// No description provided for @laptopIdLine.
  ///
  /// In en, this message translates to:
  /// **'Laptop id: {id}'**
  String laptopIdLine(Object id);

  /// No description provided for @networkRunning.
  ///
  /// In en, this message translates to:
  /// **'The station network is on.'**
  String get networkRunning;

  /// No description provided for @noPairedBooths.
  ///
  /// In en, this message translates to:
  /// **'No booths are paired yet.'**
  String get noPairedBooths;

  /// No description provided for @noPairedDevices.
  ///
  /// In en, this message translates to:
  /// **'No tablets are paired yet. Show a pairing code above to add one.'**
  String get noPairedDevices;

  /// No description provided for @noWifiAddress.
  ///
  /// In en, this message translates to:
  /// **'This laptop has no Wi-Fi address. Connect it to the station router or turn on its hotspot.'**
  String get noWifiAddress;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @pairRequestLine.
  ///
  /// In en, this message translates to:
  /// **'{label} ({role}) wants to connect. Device id: {id}'**
  String pairRequestLine(Object label, Object role, Object id);

  /// No description provided for @pairedDevices.
  ///
  /// In en, this message translates to:
  /// **'Paired tablets'**
  String get pairedDevices;

  /// No description provided for @pairingCode.
  ///
  /// In en, this message translates to:
  /// **'Pairing code'**
  String get pairingCode;

  /// No description provided for @pairingCodeValid.
  ///
  /// In en, this message translates to:
  /// **'The code works for 10 minutes.'**
  String get pairingCodeValid;

  /// No description provided for @pollsClosedNote.
  ///
  /// In en, this message translates to:
  /// **'Thank you. Please ask an official if you need help.'**
  String get pollsClosedNote;

  /// No description provided for @pollsClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'The polls are closed'**
  String get pollsClosedTitle;

  /// No description provided for @reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Not connected. Trying again…'**
  String get reconnecting;

  /// No description provided for @removeDevice.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeDevice;

  /// No description provided for @removeDeviceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {label}? Its votes will no longer be counted.'**
  String removeDeviceConfirm(Object label);

  /// No description provided for @resultsAfterClosing.
  ///
  /// In en, this message translates to:
  /// **'Results are shown after the polls close.'**
  String get resultsAfterClosing;

  /// No description provided for @resultsFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Results fingerprint: {code}'**
  String resultsFingerprint(Object code);

  /// No description provided for @resultsSavedIn.
  ///
  /// In en, this message translates to:
  /// **'Results saved in {path}'**
  String resultsSavedIn(Object path);

  /// No description provided for @saveSignedFile.
  ///
  /// In en, this message translates to:
  /// **'Save signed file to USB'**
  String get saveSignedFile;

  /// No description provided for @scanLaptopQr.
  ///
  /// In en, this message translates to:
  /// **'Scan the laptop\'s QR code'**
  String get scanLaptopQr;

  /// No description provided for @scanQrCard.
  ///
  /// In en, this message translates to:
  /// **'Scan QR card'**
  String get scanQrCard;

  /// No description provided for @sendOnline.
  ///
  /// In en, this message translates to:
  /// **'Send online (when internet is available)'**
  String get sendOnline;

  /// No description provided for @sendOnlineOff.
  ///
  /// In en, this message translates to:
  /// **'Online sending is switched off for this election.'**
  String get sendOnlineOff;

  /// No description provided for @shareResults.
  ///
  /// In en, this message translates to:
  /// **'Share results'**
  String get shareResults;

  /// No description provided for @shareResultsNote.
  ///
  /// In en, this message translates to:
  /// **'Party agents and observers copy the fingerprint code or scan the signed QR code.'**
  String get shareResultsNote;

  /// No description provided for @showPairingCode.
  ///
  /// In en, this message translates to:
  /// **'Show pairing code'**
  String get showPairingCode;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get showResults;

  /// No description provided for @showSignedQr.
  ///
  /// In en, this message translates to:
  /// **'Show signed QR code'**
  String get showSignedQr;

  /// No description provided for @startNetwork.
  ///
  /// In en, this message translates to:
  /// **'Start the station network'**
  String get startNetwork;

  /// No description provided for @statCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get statCheck;

  /// No description provided for @statCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get statCheckedIn;

  /// No description provided for @statRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get statRegistered;

  /// No description provided for @statVotes.
  ///
  /// In en, this message translates to:
  /// **'Votes on tablets'**
  String get statVotes;

  /// No description provided for @stationLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Laptop: {name}'**
  String stationLinkTitle(Object name);

  /// No description provided for @stationNetwork.
  ///
  /// In en, this message translates to:
  /// **'Station network'**
  String get stationNetwork;

  /// No description provided for @stationNetworkNote.
  ///
  /// In en, this message translates to:
  /// **'Tablets connect to this laptop over the station Wi-Fi. No internet is used.'**
  String get stationNetworkNote;

  /// No description provided for @tieNotice.
  ///
  /// In en, this message translates to:
  /// **'Tie: {count} candidates have {votes} votes. The committee decides, as the election rules say.'**
  String tieNotice(Object count, Object votes);

  /// No description provided for @votesSentToLaptop.
  ///
  /// In en, this message translates to:
  /// **'Votes sent to the laptop: {count}'**
  String votesSentToLaptop(Object count);

  /// No description provided for @waitingApproval.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the laptop to approve. On the laptop, check that the device id is {id}.'**
  String waitingApproval(Object id);

  /// No description provided for @cardTitle.
  ///
  /// In en, this message translates to:
  /// **'Voter registration card'**
  String get cardTitle;

  /// No description provided for @cardFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get cardFullName;

  /// No description provided for @cardVoterNo.
  ///
  /// In en, this message translates to:
  /// **'Voter No.'**
  String get cardVoterNo;

  /// No description provided for @cardFee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get cardFee;

  /// No description provided for @cardRegisteredLine.
  ///
  /// In en, this message translates to:
  /// **'Registered {date} at {station}. Not transferable.'**
  String cardRegisteredLine(Object date, Object station);

  /// No description provided for @cardQrNote.
  ///
  /// In en, this message translates to:
  /// **'Voter No. + signature only. No personal data.'**
  String get cardQrNote;

  /// No description provided for @cardOfficialSignature.
  ///
  /// In en, this message translates to:
  /// **'Registration official: name and signature'**
  String get cardOfficialSignature;

  /// No description provided for @cardOfficialSeal.
  ///
  /// In en, this message translates to:
  /// **'Official seal'**
  String get cardOfficialSeal;

  /// No description provided for @feePaidReceipt.
  ///
  /// In en, this message translates to:
  /// **'Paid · {receipt}'**
  String feePaidReceipt(Object receipt);

  /// No description provided for @printCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Print voter cards'**
  String get printCardsTitle;

  /// No description provided for @cardLayout.
  ///
  /// In en, this message translates to:
  /// **'Card size'**
  String get cardLayout;

  /// No description provided for @cardLayoutIdA4.
  ///
  /// In en, this message translates to:
  /// **'ID cards on A4 paper (10 per page, cut out)'**
  String get cardLayoutIdA4;

  /// No description provided for @cardLayoutIdSingle.
  ///
  /// In en, this message translates to:
  /// **'One ID card per page (card printer)'**
  String get cardLayoutIdSingle;

  /// No description provided for @cardLayoutA6.
  ///
  /// In en, this message translates to:
  /// **'A6 card (larger)'**
  String get cardLayoutA6;

  /// No description provided for @printButton.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printButton;

  /// No description provided for @savePdf.
  ///
  /// In en, this message translates to:
  /// **'Save PDF'**
  String get savePdf;

  /// No description provided for @pdfSavedIn.
  ///
  /// In en, this message translates to:
  /// **'PDF saved in {path}'**
  String pdfSavedIn(Object path);

  /// No description provided for @cardPrinted.
  ///
  /// In en, this message translates to:
  /// **'Printed'**
  String get cardPrinted;

  /// No description provided for @cardNeedsReprint.
  ///
  /// In en, this message translates to:
  /// **'New card to print'**
  String get cardNeedsReprint;

  /// No description provided for @printUnprinted.
  ///
  /// In en, this message translates to:
  /// **'Print cards not yet printed ({count})'**
  String printUnprinted(Object count);

  /// No description provided for @noCardsToPrint.
  ///
  /// In en, this message translates to:
  /// **'All cards are printed.'**
  String get noCardsToPrint;

  /// No description provided for @printCard.
  ///
  /// In en, this message translates to:
  /// **'Print card'**
  String get printCard;

  /// No description provided for @replaceCard.
  ///
  /// In en, this message translates to:
  /// **'Replace lost card'**
  String get replaceCard;

  /// No description provided for @replaceReason.
  ///
  /// In en, this message translates to:
  /// **'Why is a new card needed?'**
  String get replaceReason;

  /// No description provided for @replaceReasonLost.
  ///
  /// In en, this message translates to:
  /// **'Card lost'**
  String get replaceReasonLost;

  /// No description provided for @replaceReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Card damaged'**
  String get replaceReasonDamaged;

  /// No description provided for @replaceCardDone.
  ///
  /// In en, this message translates to:
  /// **'New card issued. The old card no longer works.'**
  String get replaceCardDone;

  /// No description provided for @cardIssueLine.
  ///
  /// In en, this message translates to:
  /// **'Card issue: {issue}'**
  String cardIssueLine(Object issue);

  /// No description provided for @voterDetails.
  ///
  /// In en, this message translates to:
  /// **'Voter {number}'**
  String voterDetails(Object number);

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Voter register'**
  String get registerTitle;

  /// No description provided for @registerDraftNote.
  ///
  /// In en, this message translates to:
  /// **'Draft: the register is not locked yet.'**
  String get registerDraftNote;

  /// No description provided for @registerLockedNote.
  ///
  /// In en, this message translates to:
  /// **'Locked register. Fingerprint: {code}'**
  String registerLockedNote(Object code);

  /// No description provided for @printedOn.
  ///
  /// In en, this message translates to:
  /// **'Printed {date}'**
  String printedOn(Object date);

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String pageOf(Object page, Object pages);

  /// No description provided for @registerTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} voters'**
  String registerTotal(Object count);

  /// No description provided for @printRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Print the register'**
  String get printRegisterTitle;

  /// No description provided for @printRegisterNote.
  ///
  /// In en, this message translates to:
  /// **'For the notice board and as a backup for manual check-in. Names, numbers, IDs and groups only: no photos and no fee details.'**
  String get printRegisterNote;

  /// No description provided for @ballotComesFromLaptop.
  ///
  /// In en, this message translates to:
  /// **'Connect to the laptop. The ballot arrives from the laptop by itself.'**
  String get ballotComesFromLaptop;

  /// No description provided for @poolTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-loaded codes (if the Wi-Fi fails)'**
  String get poolTitle;

  /// No description provided for @poolLaptopNote.
  ///
  /// In en, this message translates to:
  /// **'Prepare the code pool before opening the polls, while all booths are connected. Every code the check-in desk gives out then also works at a booth that has lost the Wi-Fi.'**
  String get poolLaptopNote;

  /// No description provided for @poolLaptopStatus.
  ///
  /// In en, this message translates to:
  /// **'{remaining} codes ready, {issued} given out'**
  String poolLaptopStatus(Object remaining, Object issued);

  /// No description provided for @poolPrepare.
  ///
  /// In en, this message translates to:
  /// **'Prepare code pool'**
  String get poolPrepare;

  /// No description provided for @poolBoothReady.
  ///
  /// In en, this message translates to:
  /// **'This booth holds {count} pre-loaded codes.'**
  String poolBoothReady(Object count);

  /// No description provided for @poolBoothNote.
  ///
  /// In en, this message translates to:
  /// **'Use only if this booth cannot reach the laptop. The officer PIN is needed, and the switch is recorded.'**
  String get poolBoothNote;

  /// No description provided for @poolStart.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi is down: use pre-loaded codes'**
  String get poolStart;

  /// No description provided for @poolStop.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi is back: stop using pre-loaded codes'**
  String get poolStop;

  /// No description provided for @poolModeOn.
  ///
  /// In en, this message translates to:
  /// **'Pre-loaded codes are in use on this booth.'**
  String get poolModeOn;

  /// No description provided for @kioskFull.
  ///
  /// In en, this message translates to:
  /// **'Booth lock: full. Voters cannot leave the voting screen.'**
  String get kioskFull;

  /// No description provided for @kioskPinningOnly.
  ///
  /// In en, this message translates to:
  /// **'Booth lock: screen pinning only. Ask the technician to set this tablet up as a locked booth (see the guide).'**
  String get kioskPinningOnly;

  /// No description provided for @loadingDevice.
  ///
  /// In en, this message translates to:
  /// **'Opening this device…'**
  String get loadingDevice;

  /// No description provided for @loadingElection.
  ///
  /// In en, this message translates to:
  /// **'Opening the election…'**
  String get loadingElection;

  /// No description provided for @loadingDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Looking for similar names in the register…'**
  String get loadingDuplicates;

  /// No description provided for @deviceOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'The saved data on this device could not be opened. Close Rakubavote and open it again. If this happens again, ask the person who set up this device.'**
  String get deviceOpenFailed;

  /// No description provided for @noVotersYet.
  ///
  /// In en, this message translates to:
  /// **'No voters yet. Register the first voter on the left, or import a list.'**
  String get noVotersYet;

  /// No description provided for @noVotersMatch.
  ///
  /// In en, this message translates to:
  /// **'No voter matches this search. Check the spelling or the number.'**
  String get noVotersMatch;
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
