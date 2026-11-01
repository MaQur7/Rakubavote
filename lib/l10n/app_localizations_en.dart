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

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get ok => 'OK';

  @override
  String get offlineSavedLaptop => 'Offline · saved on this laptop';

  @override
  String get officialUseOnly => 'Rakubavote · Official use only';

  @override
  String get comingLater => 'This part of the app comes in a later update.';

  @override
  String get setupDeviceTitle => 'Set up this device';

  @override
  String get yourName => 'Your name';

  @override
  String get yourNameHint => 'As it should appear in the audit log';

  @override
  String get choosePin => 'Choose an officer PIN (6 to 12 digits)';

  @override
  String get confirmPin => 'Type the PIN again';

  @override
  String get pinsDoNotMatch => 'The two PINs are not the same.';

  @override
  String get pinRule => 'The PIN must be 6 to 12 digits.';

  @override
  String get nameRequired => 'Enter your name.';

  @override
  String get setUpButton => 'Set up this device';

  @override
  String get pinWarning =>
      'Keep the PIN secret. Without it nobody can open the data on this device, and it cannot be recovered.';

  @override
  String unlockTitle(Object mode) {
    return 'Unlock: $mode';
  }

  @override
  String get officerPin => 'Officer PIN';

  @override
  String get unlockButton => 'Unlock';

  @override
  String get wrongPin => 'That PIN is not correct. Try again.';

  @override
  String get lockDevice => 'Lock';

  @override
  String get adminSuffix => 'Admin';

  @override
  String get tabSetup => '1 Setup';

  @override
  String get tabRegistration => '2 Registration';

  @override
  String get tabReview => '3 Review and lock';

  @override
  String get tabResults => '4 Results';

  @override
  String get newElection => 'New election';

  @override
  String get template => 'Template';

  @override
  String get templateSchool => 'School';

  @override
  String get templateAssociation => 'Community association';

  @override
  String get templatePartyPrimary => 'Party primary';

  @override
  String get templateBlank => 'Blank';

  @override
  String get orgName => 'Organization name';

  @override
  String get electionName => 'Election name';

  @override
  String get year => 'Year';

  @override
  String get stationName => 'Station name';

  @override
  String get ballotLanguages => 'Ballot languages';

  @override
  String get createElection => 'Create election';

  @override
  String get fieldRequired => 'This is needed.';

  @override
  String get electionDetails => 'Election details';

  @override
  String get idLabelField => 'Name of the ID field';

  @override
  String get groupLabelField => 'Name of the group field';

  @override
  String get organizationLogo => 'Organization logo';

  @override
  String get chooseLogo => 'Choose logo';

  @override
  String get registrationFee => 'Registration fee';

  @override
  String get chargeFee => 'Charge a fee';

  @override
  String get amount => 'Amount';

  @override
  String get currency => 'Currency';

  @override
  String get currencyEither => 'SSP or USD';

  @override
  String get unpaidPolicy => 'If someone has not paid';

  @override
  String get unpaidBlock => 'Do not register them';

  @override
  String get unpaidAllow => 'Register them and mark as not paid';

  @override
  String get feeNote =>
      'Set before registration starts. Locked once the first voter is registered.';

  @override
  String get feeLockedNote => 'Locked: voters are already registered.';

  @override
  String get saveFee => 'Save fee';

  @override
  String get feeSaved => 'Fee saved.';

  @override
  String get schoolConsent => 'School consent';

  @override
  String get schoolConsentText =>
      'The school has given consent to register students under 18.';

  @override
  String schoolConsentRecordedBy(Object name) {
    return 'Recorded by $name';
  }

  @override
  String get positions => 'Positions';

  @override
  String get addPosition => 'Add position';

  @override
  String get newPositionTitle => 'New position';

  @override
  String candidatesCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count candidates',
      one: '1 candidate',
      zero: 'No candidates',
    );
    return '$_temp0';
  }

  @override
  String get allowNoChoice => 'Allow “No choice”';

  @override
  String get chooseLabel => 'Choose';

  @override
  String get candidatesSuffix => 'candidate(s)';

  @override
  String positionTitleIn(Object language) {
    return 'Title in $language';
  }

  @override
  String get colour => 'Colour';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get deletePosition => 'Delete position';

  @override
  String deletePositionConfirm(Object title) {
    return 'Delete $title and its candidates?';
  }

  @override
  String get colNo => 'No.';

  @override
  String get colPhoto => 'Photo';

  @override
  String get colName => 'Name';

  @override
  String get colSymbol => 'Symbol';

  @override
  String get addCandidate => 'Add candidate (take photo)';

  @override
  String get editCandidate => 'Edit candidate';

  @override
  String get candidateNumber => 'Candidate number';

  @override
  String get candidateName => 'Candidate name';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseSymbol => 'Choose symbol';

  @override
  String get removeImage => 'Remove';

  @override
  String get deleteCandidate => 'Delete candidate';

  @override
  String get printSampleBallot => 'Print sample ballot';

  @override
  String get saveAndSignBallot => 'Save and sign ballot';

  @override
  String get ballotSigned => 'Ballot signed';

  @override
  String ballotFingerprint(Object code) {
    return 'Fingerprint: $code';
  }

  @override
  String get ballotNotSigned => 'The ballot is not signed yet.';

  @override
  String get ballotSignedNote => 'Signed. Any change will need signing again.';

  @override
  String get noPositionSelected => 'Add a position on the left to start.';

  @override
  String get errFeeLocked =>
      'The fee cannot change: voters are already registered.';

  @override
  String get errBallotFrozen =>
      'The ballot cannot change after the register is locked.';

  @override
  String errBallotInvalid(Object details) {
    return 'The ballot is not complete. $details';
  }

  @override
  String get errDuplicateNumber => 'Another candidate already has that number.';

  @override
  String get errLowContrast =>
      'That colour is too light for white text. Choose a darker one.';

  @override
  String get errInvalidValue => 'Check the values and try again.';

  @override
  String get registerAVoter => 'Register a voter';

  @override
  String get photo => 'Photo';

  @override
  String get photoUse =>
      'Used only to confirm identity on election day. Deleted after the election.';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHint => 'As known in the community';

  @override
  String feeLine(Object amount, Object currency) {
    return 'Registration fee: $amount $currency';
  }

  @override
  String get paid => 'Paid';

  @override
  String get receiptNo => 'Receipt no.';

  @override
  String get possibleDuplicate => 'Possible duplicate:';

  @override
  String duplicateNameText(Object number) {
    return 'a voter with a similar name and the same group exists (Voter No. $number). Check before saving.';
  }

  @override
  String duplicateIdText(Object number) {
    return 'a voter with the same ID exists (Voter No. $number). Check before saving.';
  }

  @override
  String get clear => 'Clear';

  @override
  String get saveAndPrintCard => 'Save and print voter card';

  @override
  String get registeredVoters => 'Registered voters';

  @override
  String get searchNameOrNumber => 'Search name or number';

  @override
  String get colVoterNo => 'Voter No.';

  @override
  String get colGroup => 'Group';

  @override
  String get colFee => 'Fee';

  @override
  String get colCard => 'Card';

  @override
  String get feeNotPaid => 'Not paid';

  @override
  String get cardNotPrinted => 'Not printed';

  @override
  String showingVoters(Object shown, Object total) {
    return 'Showing $shown of $total registered voters';
  }

  @override
  String get feeSummary => 'Fee summary';

  @override
  String get importCsv => 'Import list (CSV)';

  @override
  String get backupUsb => 'Back up to USB';

  @override
  String voterSaved(Object number) {
    return 'Saved. Voter No. $number.';
  }

  @override
  String get errConsentMissing =>
      'Record the school\'s consent in Setup before registering students.';

  @override
  String get errNameRequired => 'Enter the full name.';

  @override
  String get errFeeUnpaidBlocked =>
      'This election only registers people who have paid the fee.';

  @override
  String get errReceiptRequired => 'Enter the receipt number.';

  @override
  String get errCurrencyNotAccepted => 'Choose SSP or USD.';

  @override
  String get errRegisterLocked =>
      'The register is locked. No names can be added.';

  @override
  String get errNoElection => 'Create the election in Setup first.';

  @override
  String importDone(Object imported, Object skipped, Object duplicates) {
    return 'Imported $imported. Skipped $skipped. Possible duplicates: $duplicates.';
  }

  @override
  String importSkippedLine(Object line, Object reason) {
    return 'Line $line: $reason';
  }

  @override
  String backupDone(Object path) {
    return 'Backup saved in $path';
  }

  @override
  String get backupFailed =>
      'The backup could not be saved. Check the USB drive and try again.';

  @override
  String get totalsByCurrency => 'Totals by currency';

  @override
  String get totalsByOfficial => 'Totals by official';

  @override
  String paidCount(Object count) {
    return 'Paid: $count';
  }

  @override
  String unpaidCount(Object count) {
    return 'Not paid: $count';
  }

  @override
  String flaggedCount(Object count) {
    return 'Registered without paying: $count';
  }

  @override
  String get noFee => 'This election has no registration fee.';

  @override
  String get photoFailed => 'No photo was taken. You can try again.';

  @override
  String get registeredVotersStat => 'Registered voters';

  @override
  String get displayPeriod => 'Public display period';

  @override
  String displayPeriodRange(Object start, Object end) {
    return '$start to $end';
  }

  @override
  String get displayPeriodNotSet => 'Not set yet';

  @override
  String get setDates => 'Set dates';

  @override
  String get startDate => 'First day';

  @override
  String get endDate => 'Last day';

  @override
  String get openObjections => 'Open objections';

  @override
  String get objectionsTitle => 'Objections and corrections';

  @override
  String get objectionsNote =>
      'Every decision is saved in the audit log with the official\'s name and time.';

  @override
  String get noObjections => 'No objections recorded.';

  @override
  String get raiseObjection => 'Record an objection';

  @override
  String get checkDuplicates => 'Check for duplicates';

  @override
  String get objectionKind => 'What is the objection?';

  @override
  String get kindDuplicate => 'Possible duplicate';

  @override
  String get kindMissing => 'Missing name';

  @override
  String get kindOther => 'Other';

  @override
  String get voterNumberField => 'Voter No.';

  @override
  String get otherVoterNumberField => 'Possible duplicate of Voter No.';

  @override
  String get claimantNameField => 'Name of the person who is missing';

  @override
  String get raisedByField => 'Name of the person objecting';

  @override
  String get detailField => 'Details';

  @override
  String duplicateTitle(Object subject, Object other) {
    return 'Voter No. $subject · possible duplicate of $other';
  }

  @override
  String missingTitle(Object name) {
    return 'Missing name: $name';
  }

  @override
  String otherTitle(Object subject, Object detail) {
    return 'Voter No. $subject: $detail';
  }

  @override
  String raisedByLine(Object name, Object date) {
    return 'Raised by $name on $date';
  }

  @override
  String decidedLine(Object name, Object date, Object decision) {
    return 'Decided by $name on $date: $decision';
  }

  @override
  String get keepBoth => 'Keep both';

  @override
  String removeVoter(Object number) {
    return 'Remove $number';
  }

  @override
  String get addVoter => 'Add voter';

  @override
  String get reject => 'Reject';

  @override
  String get upheld => 'Upheld';

  @override
  String get rejected => 'Rejected';

  @override
  String get decisionKeepBoth => 'kept both';

  @override
  String get decisionRemove => 'removed';

  @override
  String get decisionAdd => 'added';

  @override
  String get decisionReject => 'rejected';

  @override
  String get decisionUpheld => 'upheld';

  @override
  String get decisionRejected => 'rejected';

  @override
  String get noDuplicatesFound => 'No possible duplicates found.';

  @override
  String get duplicatePairsTitle => 'Possible duplicates';

  @override
  String duplicatePairLine(Object a, Object b) {
    return '$a and $b';
  }

  @override
  String get raiseThis => 'Record as objection';

  @override
  String get lockTitle => 'Lock the register';

  @override
  String get lockText =>
      'After locking, no names can be added or removed. The laptop creates a signed copy and a fingerprint code that anyone can check.';

  @override
  String get printRegister => 'Print register for notice board';

  @override
  String get lockButton => 'Lock register';

  @override
  String lockButtonBlocked(Object count) {
    return 'Lock register (resolve $count objections first)';
  }

  @override
  String get lockConfirm => 'Lock the register now? This cannot be undone.';

  @override
  String get afterLockingTitle => 'After locking:';

  @override
  String get afterLockingText =>
      'copy to the check-in device by USB or local Wi-Fi, and print the fingerprint code for party agents and observers.';

  @override
  String get registerLocked => 'The register is locked';

  @override
  String get registerFingerprint => 'Fingerprint code';

  @override
  String lockedByLine(Object name, Object date) {
    return 'Locked by $name on $date';
  }

  @override
  String get registerCheckValid =>
      'Checked: the signed register matches the data on this laptop.';

  @override
  String get registerCheckBad =>
      'Warning: the signed register does not match its signature. Do not use this laptop\'s register; call the presiding officer.';

  @override
  String get registerCheckChanged =>
      'Warning: the data on this laptop has changed since the register was locked. Call the presiding officer.';

  @override
  String get errOpenObjections => 'Resolve all objections before locking.';

  @override
  String get errBallotNotSigned =>
      'Sign the ballot in Setup before locking the register.';

  @override
  String get errEmptyRegister => 'There are no voters on the register.';

  @override
  String get errVoterNotFound =>
      'That voter number was not found on the register.';

  @override
  String get errDecisionNotAllowed =>
      'That decision does not fit this objection.';

  @override
  String get errAlreadyDecided => 'This objection has already been decided.';

  @override
  String get errInvalidDates =>
      'The last day must be on or after the first day.';

  @override
  String checkinDeskTitle(Object station) {
    return 'Check-in desk · $station';
  }

  @override
  String get findVoter => 'Find voter';

  @override
  String get nameOrVoterNumber => 'Name or voter number';

  @override
  String get scanHint =>
      'To scan a card, point the USB scanner at the QR code. It types into this box.';

  @override
  String get photoFromRegistration => 'Photo from registration';

  @override
  String voterNoLine(Object number) {
    return 'Voter No. $number';
  }

  @override
  String get statusNotVoted => 'Registered · Has not voted';

  @override
  String get statusCheckedIn => 'Already checked in';

  @override
  String get comparePhoto =>
      'Compare the photo with the person in front of you before confirming.';

  @override
  String get confirmIssueToken => 'Confirm and issue voting token';

  @override
  String get tokenTitle => 'One-time voting token';

  @override
  String get tokenNote =>
      'Give this code to the voter, for example written on a slip. It is not linked to the vote, so the ballot stays secret.';

  @override
  String get nextVoter => 'Next voter';

  @override
  String get manualTitle => 'Voter not found or device problem?';

  @override
  String get manualText =>
      'Check the printed register, record the reason, then issue a token manually.';

  @override
  String get manualCheckin => 'Manual check-in';

  @override
  String get manualVoterNo => 'Voter No. on the printed register';

  @override
  String get manualReason => 'Reason';

  @override
  String get reasonCardLost => 'Card lost';

  @override
  String get reasonCardUnreadable => 'Card cannot be read';

  @override
  String get reasonPhotoMissing => 'No photo or photo unclear';

  @override
  String get reasonDeviceProblem => 'Device problem';

  @override
  String get reasonOther => 'Other (explain)';

  @override
  String get manualDetails => 'Details';

  @override
  String get cardReplaced =>
      'This card was replaced. Ask for the new card, or use manual check-in.';

  @override
  String get cardInvalid =>
      'This card could not be checked. Use the printed register and manual check-in.';

  @override
  String get cardNotOnRegister =>
      'This voter number is not on the register. Check the printed register.';

  @override
  String get noVotersFound =>
      'No voter found. Check the spelling or the number.';

  @override
  String checkedInCount(Object count, Object total) {
    return 'Checked in: $count of $total';
  }

  @override
  String get alreadyHasToken => 'This voter has already received a token.';

  @override
  String get errPollsNotOpen =>
      'The polls are not open yet. The presiding officer opens them in Review and lock.';

  @override
  String get errVoterRemoved => 'This voter was removed from the register.';

  @override
  String get errReasonRequired => 'Choose a reason and add details.';

  @override
  String get errRegisterNotLocked =>
      'Lock the register before opening the polls.';

  @override
  String get openPolls => 'Open the polls';

  @override
  String get openPollsConfirm =>
      'Open the polls now? Check-in can start after this.';

  @override
  String get pollsOpen => 'The polls are open.';

  @override
  String get openCheckinDesk => 'Check-in desk';

  @override
  String get backToAdmin => 'Back to admin';

  @override
  String get statusJustCheckedIn =>
      'Checked in now. Give the code to the voter.';

  @override
  String get officialBallot => 'Official ballot';

  @override
  String get typeCode => 'Type the code the official gave you';

  @override
  String get startVoting => 'Start voting';

  @override
  String get secrecyFooter =>
      'Your vote is secret. Nobody can see who you vote for.';

  @override
  String get numbersHelp =>
      'Each candidate has a number and a symbol to help you find them.';

  @override
  String get poweredBy => 'Powered by Rakubavote';

  @override
  String get codeNotFound =>
      'That code was not found. Check your slip or ask an official.';

  @override
  String get codeUsed => 'This code has already been used. Ask an official.';

  @override
  String get tooManyTries =>
      'Please ask an official for help. You can try again in one minute.';

  @override
  String get helpTitle => 'How to vote';

  @override
  String get helpText =>
      '1. Type your code and press Start voting.\n2. For each position, tap the candidate you choose, or tap No choice.\n3. Check your choices, then press Confirm my vote.\n\nYour vote is secret. Ask an official if you need help.';

  @override
  String positionOf(Object current, Object total) {
    return 'Position $current of $total';
  }

  @override
  String get tapOneOrNoChoice => 'Tap one candidate, or choose No choice';

  @override
  String get tapOne => 'Tap one candidate';

  @override
  String tapUpToOrNoChoice(Object count) {
    return 'Tap up to $count candidates, or choose No choice';
  }

  @override
  String tapUpTo(Object count) {
    return 'Tap up to $count candidates';
  }

  @override
  String get noChoiceForPosition => 'No choice for this position';

  @override
  String get changeNote =>
      'Tapping another option changes your choice. You can check everything before confirming.';

  @override
  String nextPosition(Object title) {
    return 'Next: $title';
  }

  @override
  String get reviewButton => 'Review';

  @override
  String bigListHeader(Object count) {
    return '$count candidates. Tap one, or type their number below.';
  }

  @override
  String get candidateNumberLabel => 'Candidate number';

  @override
  String get showsMatching => 'Shows the matching candidate';

  @override
  String get yourChoice => 'Your choice';

  @override
  String get noCandidateWithNumber => 'There is no candidate with that number.';

  @override
  String chosenCount(Object count, Object max) {
    return '$count of $max chosen';
  }

  @override
  String get checkChoices => 'Check your choices';

  @override
  String get notSavedUntil => 'Your vote is not saved until you press Confirm.';

  @override
  String get change => 'Change';

  @override
  String get confirmMyVote => 'Confirm my vote';

  @override
  String get cannotChangeAfter =>
      'After confirming, your choices cannot be changed.';

  @override
  String get codeUsedElsewhere =>
      'This code was already used at another booth. Ask an official.';

  @override
  String get endTitle => 'End';

  @override
  String get thankYou => 'Thank you. Your vote has been recorded.';

  @override
  String get beepNote => 'A long beep sounds to confirm your vote is saved.';

  @override
  String clearsIn(Object seconds) {
    return 'This screen will clear in $seconds seconds for the next voter.';
  }

  @override
  String get boothSetupTitle => 'Voting booth';

  @override
  String get loadBallot => 'Load ballot from USB';

  @override
  String get noBallotYet => 'No ballot loaded yet.';

  @override
  String get ballotLoadedTitle => 'Ballot loaded';

  @override
  String get ballotFingerprintCheck =>
      'Check that this fingerprint matches the one on the laptop:';

  @override
  String stationIdLine(Object id) {
    return 'Laptop: $id';
  }

  @override
  String get startBooth => 'Start voting booth';

  @override
  String votesOnBooth(Object count) {
    return 'Votes on this booth: $count';
  }

  @override
  String get leaveBoothTitle => 'Officer PIN to leave the booth screen';

  @override
  String get leaveBooth => 'Leave';

  @override
  String get codesNote =>
      'Codes reach this booth from the laptop over the station Wi-Fi.';

  @override
  String get errPackageMalformed => 'This file is not a Rakubavote ballot.';

  @override
  String get errPackageSignature =>
      'The ballot\'s signature does not check. Do not use this file.';

  @override
  String get errPackageWrongStation =>
      'This ballot comes from a different laptop than the one this booth trusts.';

  @override
  String get errPackageImage =>
      'An image in this ballot is missing or was changed. Do not use this file.';

  @override
  String get errVotesExist =>
      'This booth already has votes for another ballot.';

  @override
  String get saveBallotForBooths => 'Save ballot for booths (USB)';

  @override
  String ballotSavedIn(Object path) {
    return 'Ballot saved in $path';
  }
}
