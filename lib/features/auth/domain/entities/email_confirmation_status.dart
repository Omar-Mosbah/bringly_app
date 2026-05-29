enum EmailConfirmationStatus { pending, confirmed, expired, unavailable }

extension EmailConfirmationStatusX on EmailConfirmationStatus {
  bool get allowsProtectedAccess => this == EmailConfirmationStatus.confirmed;

  bool get needsAction => this != EmailConfirmationStatus.confirmed;
}