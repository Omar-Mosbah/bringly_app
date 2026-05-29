enum AuthSessionState {
  signedOut,
  restoring,
  signedInRequiresUnlock,
  signedInUnlocked,
  expired,
  unauthorized,
  blocked,
}

class AuthSession {
  const AuthSession({
    required this.state,
    this.expiresAt,
    this.requiresLocalUnlock = false,
    this.forcedLogoutRequired = false,
  });

  final AuthSessionState state;
  final DateTime? expiresAt;
  final bool requiresLocalUnlock;
  final bool forcedLogoutRequired;

  AuthSession copyWith({
    AuthSessionState? state,
    DateTime? expiresAt,
    bool? requiresLocalUnlock,
    bool? forcedLogoutRequired,
  }) {
    return AuthSession(
      state: state ?? this.state,
      expiresAt: expiresAt ?? this.expiresAt,
      requiresLocalUnlock: requiresLocalUnlock ?? this.requiresLocalUnlock,
      forcedLogoutRequired: forcedLogoutRequired ?? this.forcedLogoutRequired,
    );
  }

  bool get isSignedIn {
    return state == AuthSessionState.signedInRequiresUnlock ||
        state == AuthSessionState.signedInUnlocked;
  }

  bool get isUnlocked => state == AuthSessionState.signedInUnlocked;

  bool get blocksProtectedContent => isSignedIn && requiresLocalUnlock && !isUnlocked;
}