import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';

enum RestoreSessionStatus {
  restored,
  missingSession,
  expired,
  unauthorized,
  forcedLogout,
  unavailable,
}

class RestoreSessionResult {
  const RestoreSessionResult({
    required this.status,
    this.snapshot,
    this.failure,
  });

  final RestoreSessionStatus status;
  final AuthAccountSnapshot? snapshot;
  final AuthFailure? failure;
}

class RestoreSession {
  const RestoreSession(this._authRepository);

  final AuthRepository _authRepository;

  Future<RestoreSessionResult> call() async {
    final result = await _authRepository.restoreSession();

    if (result.isSuccess) {
      final snapshot = result.value;
      if (snapshot == null) {
        return const RestoreSessionResult(
          status: RestoreSessionStatus.missingSession,
        );
      }

      if (snapshot.session.state == AuthSessionState.expired) {
        return RestoreSessionResult(
          status: RestoreSessionStatus.expired,
          snapshot: snapshot,
        );
      }

      if (snapshot.session.state == AuthSessionState.unauthorized) {
        return RestoreSessionResult(
          status: RestoreSessionStatus.unauthorized,
          snapshot: snapshot,
        );
      }

      return RestoreSessionResult(
        status: RestoreSessionStatus.restored,
        snapshot: snapshot,
      );
    }

    return switch (result.failure?.code) {
      AuthFailureCode.forcedLogout => RestoreSessionResult(
        status: RestoreSessionStatus.forcedLogout,
        failure: result.failure,
      ),
      AuthFailureCode.unauthorized => RestoreSessionResult(
        status: RestoreSessionStatus.unauthorized,
        failure: result.failure,
      ),
      AuthFailureCode.offline || AuthFailureCode.serviceUnavailable =>
        RestoreSessionResult(
          status: RestoreSessionStatus.unavailable,
          failure: result.failure,
        ),
      _ => RestoreSessionResult(
        status: RestoreSessionStatus.unavailable,
        failure: result.failure,
      ),
    };
  }
}