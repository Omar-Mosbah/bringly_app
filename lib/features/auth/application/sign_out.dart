import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';

enum SignOutStatus { signedOut, signedOutLocally }

class SignOutResult {
  const SignOutResult({required this.status, this.failure});

  final SignOutStatus status;
  final AuthFailure? failure;
}

class SignOut {
  const SignOut(this._authRepository);

  final AuthRepository _authRepository;

  Future<SignOutResult> call() async {
    final result = await _authRepository.signOut();

    if (result.isSuccess) {
      return const SignOutResult(status: SignOutStatus.signedOut);
    }

    return SignOutResult(
      status: SignOutStatus.signedOutLocally,
      failure: result.failure,
    );
  }
}