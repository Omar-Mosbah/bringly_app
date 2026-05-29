import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/features/auth/application/request_password_reset.dart';
import 'package:bringly_app/features/auth/application/require_local_unlock.dart';
import 'package:bringly_app/features/auth/application/restore_session.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_out.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/local_unlock_state.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter/foundation.dart';

enum AuthControllerStatus {
  signedOut,
  loading,
  empty,
  registered,
  signedInLocked,
  signedInUnlocked,
  expired,
  unauthorized,
  blocked,
  error,
  passwordResetSubmitted,
}

class AuthControllerState {
  const AuthControllerState._({
    required this.status,
    this.snapshot,
    this.failure,
    this.unlockState,
    this.safeMessage,
  });

  const AuthControllerState.signedOut({String? safeMessage})
    : this._(status: AuthControllerStatus.signedOut, safeMessage: safeMessage);

  const AuthControllerState.loading()
    : this._(status: AuthControllerStatus.loading);

  const AuthControllerState.empty() : this._(status: AuthControllerStatus.empty);

  const AuthControllerState.registered(AuthAccountSnapshot snapshot)
    : this._(status: AuthControllerStatus.registered, snapshot: snapshot);

  const AuthControllerState.signedInLocked(
    AuthAccountSnapshot snapshot, {
    LocalUnlockState? unlockState,
    AuthFailure? failure,
  }) : this._(
         status: AuthControllerStatus.signedInLocked,
         snapshot: snapshot,
         unlockState: unlockState,
         failure: failure,
       );

  const AuthControllerState.signedInUnlocked(AuthAccountSnapshot snapshot)
    : this._(status: AuthControllerStatus.signedInUnlocked, snapshot: snapshot);

  const AuthControllerState.expired({AuthFailure? failure})
    : this._(status: AuthControllerStatus.expired, failure: failure);

  const AuthControllerState.unauthorized({AuthFailure? failure})
    : this._(status: AuthControllerStatus.unauthorized, failure: failure);

  const AuthControllerState.blocked({
    AuthAccountSnapshot? snapshot,
    AuthFailure? failure,
  }) : this._(
         status: AuthControllerStatus.blocked,
         snapshot: snapshot,
         failure: failure,
       );

  const AuthControllerState.error(AuthFailure failure)
    : this._(status: AuthControllerStatus.error, failure: failure);

  const AuthControllerState.passwordResetSubmitted(String safeMessage)
    : this._(
         status: AuthControllerStatus.passwordResetSubmitted,
         safeMessage: safeMessage,
       );

  final AuthControllerStatus status;
  final AuthAccountSnapshot? snapshot;
  final AuthFailure? failure;
  final LocalUnlockState? unlockState;
  final String? safeMessage;

  bool get isLoading => status == AuthControllerStatus.loading;

  bool get isSignedInLocked => status == AuthControllerStatus.signedInLocked;

  bool get isSignedInUnlocked => status == AuthControllerStatus.signedInUnlocked;
}

class AuthController extends ChangeNotifier {
  AuthController({
    required SignUpWithEmail signUpWithEmail,
    SignInWithEmail? signInWithEmail,
    RestoreSession? restoreSession,
    RequireLocalUnlock? requireLocalUnlock,
    SignOut? signOut,
    RequestPasswordReset? requestPasswordReset,
    AuthControllerState initialState = const AuthControllerState.signedOut(),
  }) : _signUpWithEmail = signUpWithEmail,
       _signInWithEmail = signInWithEmail,
       _restoreSession = restoreSession,
       _requireLocalUnlock = requireLocalUnlock,
       _signOut = signOut,
       _requestPasswordReset = requestPasswordReset,
       _state = initialState;

  final SignUpWithEmail _signUpWithEmail;
  final SignInWithEmail? _signInWithEmail;
  final RestoreSession? _restoreSession;
  final RequireLocalUnlock? _requireLocalUnlock;
  final SignOut? _signOut;
  final RequestPasswordReset? _requestPasswordReset;

  AuthControllerState _state;

  AuthControllerState get state => _state;

  Future<void> register({
    required String email,
    required String password,
    required MarketplaceRole marketplaceRole,
  }) async {
    _state = const AuthControllerState.loading();
    notifyListeners();

    final result = await _signUpWithEmail(
      email: email,
      password: password,
      initialMarketplaceRole: marketplaceRole,
    );

    if (result.isSuccess && result.value != null) {
      _state = AuthControllerState.registered(result.value!);
    } else {
      _state = AuthControllerState.error(
        result.failure ?? const AuthFailure.unknownSafeFailure(),
      );
    }

    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    _state = const AuthControllerState.loading();
    notifyListeners();

    final useCase = _signInWithEmail;
    if (useCase == null) {
      _state = const AuthControllerState.error(AuthFailure.unknownSafeFailure());
      notifyListeners();
      return;
    }

    final result = await useCase(email: email, password: password);
    if (result.isSuccess && result.value != null) {
      _state = AuthControllerState.signedInLocked(
        result.value!,
        unlockState: const LocalUnlockState(
          availability: LocalAppUnlockAvailability.unknown,
          method: LocalAppUnlockMethod.unavailable,
          phase: LocalUnlockPhase.required,
        ),
      );
    } else {
      final failure = result.failure ?? const AuthFailure.unknownSafeFailure();
      _state = switch (failure.code) {
        AuthFailureCode.blocked || AuthFailureCode.suspended =>
          AuthControllerState.blocked(failure: failure),
        _ => AuthControllerState.error(failure),
      };
    }

    notifyListeners();
  }

  Future<void> restore() async {
    final useCase = _restoreSession;
    if (useCase == null) {
      return;
    }

    _state = const AuthControllerState.loading();
    notifyListeners();

    final result = await useCase();
    _state = switch (result.status) {
      RestoreSessionStatus.restored => result.snapshot?.session.isUnlocked == true
          ? AuthControllerState.signedInUnlocked(result.snapshot!)
          : AuthControllerState.signedInLocked(
              result.snapshot!,
              unlockState: const LocalUnlockState(
                availability: LocalAppUnlockAvailability.unknown,
                method: LocalAppUnlockMethod.unavailable,
                phase: LocalUnlockPhase.required,
              ),
            ),
      RestoreSessionStatus.missingSession => const AuthControllerState.empty(),
      RestoreSessionStatus.expired => AuthControllerState.expired(
          failure: result.failure ?? const AuthFailure.unauthorized(),
        ),
      RestoreSessionStatus.unauthorized => AuthControllerState.unauthorized(
          failure: result.failure ?? const AuthFailure.unauthorized(),
        ),
      RestoreSessionStatus.forcedLogout => AuthControllerState.blocked(
          failure: result.failure ?? const AuthFailure.forcedLogout(),
        ),
      RestoreSessionStatus.unavailable => AuthControllerState.error(
          result.failure ?? const AuthFailure.serviceUnavailable(),
        ),
    };

    notifyListeners();
  }

  Future<void> unlock({String reason = 'Unlock Bringly'}) async {
    final snapshot = _state.snapshot;
    final useCase = _requireLocalUnlock;
    if (snapshot == null || useCase == null) {
      return;
    }

    _state = AuthControllerState.signedInLocked(
      snapshot,
      unlockState: LocalUnlockState(
        availability: _state.unlockState?.availability ?? LocalAppUnlockAvailability.unknown,
        method: _state.unlockState?.method ?? LocalAppUnlockMethod.unavailable,
        phase: LocalUnlockPhase.inProgress,
      ),
    );
    notifyListeners();

    final result = await useCase(reason: reason);
    if (result.status == RequireLocalUnlockStatus.unlocked && result.state != null) {
      _state = AuthControllerState.signedInUnlocked(
        snapshot.copyWith(
          session: snapshot.session.copyWith(
            state: AuthSessionState.signedInUnlocked,
            requiresLocalUnlock: false,
          ),
        ),
      );
      notifyListeners();
      return;
    }

    _state = AuthControllerState.signedInLocked(
      snapshot,
      unlockState:
          result.state ??
          const LocalUnlockState(
            availability: LocalAppUnlockAvailability.unavailable,
            method: LocalAppUnlockMethod.unavailable,
            phase: LocalUnlockPhase.failed,
          ),
      failure: result.failure,
    );
    notifyListeners();
  }

  Future<void> requestPasswordReset({required String email}) async {
    final useCase = _requestPasswordReset;
    if (useCase == null) {
      _state = const AuthControllerState.error(AuthFailure.unknownSafeFailure());
      notifyListeners();
      return;
    }

    _state = const AuthControllerState.loading();
    notifyListeners();

    final result = await useCase(email: email);
    if (result.isSuccess && result.safeMessage != null) {
      _state = AuthControllerState.passwordResetSubmitted(result.safeMessage!);
    } else {
      _state = AuthControllerState.error(
        result.failure ?? const AuthFailure.unknownSafeFailure(),
      );
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    _state = const AuthControllerState.loading();
    notifyListeners();

    final result = await _signOut?.call() ??
        const SignOutResult(status: SignOutStatus.signedOut);
    try {
      await _requireLocalUnlock?.reset();
    } catch (_) {}

    _state = AuthControllerState.signedOut(
      safeMessage: switch (result.status) {
        SignOutStatus.signedOut => 'You have been signed out securely.',
        SignOutStatus.signedOutLocally =>
          'You have been signed out on this device. Server confirmation will retry later.',
      },
    );
    notifyListeners();
  }

  void setSignedOut({String? safeMessage}) {
    _state = AuthControllerState.signedOut(safeMessage: safeMessage);
    notifyListeners();
  }
}