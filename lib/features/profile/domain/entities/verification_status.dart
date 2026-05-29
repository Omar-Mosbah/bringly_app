enum VerificationStatus {
  incomplete,
  underReview,
  verified,
  rejected,
  blocked,
  unavailable,
}

extension VerificationStatusX on VerificationStatus {
  bool get allowsProtectedMarketplaceAccess {
    return this == VerificationStatus.verified;
  }
}