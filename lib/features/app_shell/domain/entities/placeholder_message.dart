/// A safe placeholder description shown in lieu of a not-yet-implemented
/// marketplace feature.
///
/// Copy rules:
/// - Must not imply that approval, payment, verification, delivery, dispute,
///   payout, auth, or backend success has occurred or is available.
/// - Action labels, if present, must be safe and forward-looking only.
/// - Blocked reason, if present, explains unavailability without provider
///   internals.
class PlaceholderMessage {
  const PlaceholderMessage({
    required this.title,
    required this.message,
    this.actionLabel,
    this.blockedReason,
  });

  /// Short safe title — must not imply any completed marketplace transaction.
  final String title;

  /// Longer explanatory copy — must not imply auth, payment, delivery,
  /// dispute, payout, verification, or backend success.
  final String message;

  /// Optional forward-looking call-to-action label.
  /// Must not imply a real available action in Phase 1.
  final String? actionLabel;

  /// Optional explanation of why a destination is blocked or unavailable.
  /// Must not expose provider internals, Supabase references, or risk scores.
  final String? blockedReason;
}
