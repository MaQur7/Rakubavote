import '../l10n/app_localizations.dart';
import '../station/station_client.dart';
import 'checkin/checkin_service.dart';
import 'results/results_service.dart';
import 'register_lock/review_service.dart';
import 'registration/registration_service.dart';
import 'setup/election_service.dart';

/// Turns service errors into plain, non-blaming words (brand voice).
String describeError(AppLocalizations t, Object e) {
  if (e is SetupException) {
    return switch (e.failure) {
      SetupFailure.feeLocked => t.errFeeLocked,
      SetupFailure.ballotFrozen => t.errBallotFrozen,
      SetupFailure.ballotInvalid => t.errBallotInvalid(e.detail),
      SetupFailure.duplicateCandidateNumber => t.errDuplicateNumber,
      SetupFailure.lowContrastColour => t.errLowContrast,
      SetupFailure.invalidValue => t.errInvalidValue,
    };
  }
  if (e is LinkException) {
    return switch (e.failure) {
      LinkFailure.cannotReach => t.errCannotReachLaptop,
      LinkFailure.wrongLaptop => t.errWrongLaptop,
      LinkFailure.codeRefused => t.errPairingCode,
      LinkFailure.rejected => t.errPairingRejected,
      LinkFailure.timedOut => t.errPairingTimedOut,
      LinkFailure.notPaired => t.errNotPaired,
      LinkFailure.refused => t.errInvalidValue,
    };
  }
  if (e is ResultsException) {
    return switch (e.failure) {
      ResultsFailure.noElection => t.errNoElection,
      ResultsFailure.pollsNotOpen => t.errPollsNotOpen,
      ResultsFailure.pollsNotClosed => t.errPollsNotClosed,
      ResultsFailure.unknownBooth => t.errUnknownBooth,
      ResultsFailure.badBatch => t.errBadBatch,
      ResultsFailure.otherElection => t.errOtherElectionBatch,
      ResultsFailure.olderBatch => t.errOlderBatch,
    };
  }
  if (e is CheckInException) {
    return switch (e.failure) {
      CheckInFailure.noElection => t.errNoElection,
      CheckInFailure.pollsNotOpen => t.errPollsNotOpen,
      CheckInFailure.voterNotFound => t.cardNotOnRegister,
      CheckInFailure.voterRemoved => t.errVoterRemoved,
      CheckInFailure.alreadyCheckedIn => t.alreadyHasToken,
      CheckInFailure.reasonRequired => t.errReasonRequired,
      CheckInFailure.ballotNotSigned => t.errBallotNotSigned,
      CheckInFailure.registerNotLocked => t.errRegisterNotLocked,
    };
  }
  if (e is ReviewException) {
    return switch (e.failure) {
      ReviewFailure.noElection => t.errNoElection,
      ReviewFailure.registerLocked => t.errRegisterLocked,
      ReviewFailure.openObjections => t.errOpenObjections,
      ReviewFailure.ballotNotSigned => t.errBallotNotSigned,
      ReviewFailure.emptyRegister => t.errEmptyRegister,
      ReviewFailure.voterNotFound => t.errVoterNotFound,
      ReviewFailure.decisionNotAllowed => t.errDecisionNotAllowed,
      ReviewFailure.alreadyDecided => t.errAlreadyDecided,
      ReviewFailure.invalidDates => t.errInvalidDates,
    };
  }
  if (e is RegistrationException) {
    return registrationFailureText(t, e.failure);
  }
  return t.errInvalidValue;
}

String registrationFailureText(AppLocalizations t, RegistrationFailure f) => switch (f) {
      RegistrationFailure.noElection => t.errNoElection,
      RegistrationFailure.registerLocked => t.errRegisterLocked,
      RegistrationFailure.consentMissing => t.errConsentMissing,
      RegistrationFailure.nameRequired => t.errNameRequired,
      RegistrationFailure.feeUnpaidBlocked => t.errFeeUnpaidBlocked,
      RegistrationFailure.receiptRequired => t.errReceiptRequired,
      RegistrationFailure.currencyNotAccepted => t.errCurrencyNotAccepted,
    };
