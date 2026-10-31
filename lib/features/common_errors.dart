import '../l10n/app_localizations.dart';
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
