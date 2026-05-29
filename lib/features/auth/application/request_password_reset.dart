import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';

class RequestPasswordResetResult {
  const RequestPasswordResetResult._({
    required this.isSuccess,
    this.failure,
    this.safeMessage,
  });

  const RequestPasswordResetResult.success(String safeMessage)
    : this._(isSuccess: true, safeMessage: safeMessage);

  const RequestPasswordResetResult.failure(AuthFailure failure)
    : this._(isSuccess: false, failure: failure);

  final bool isSuccess;
  final AuthFailure? failure;
  final String? safeMessage;
}

class RequestPasswordReset {
  const RequestPasswordReset(this._authRepository);

  static const String safeSuccessMessage =
      'If the email can receive reset instructions, a secure link will arrive shortly.';

  final AuthRepository _authRepository;

  Future<RequestPasswordResetResult> call({required String email}) async {
    final emailAddress = EmailAddress(email);
    if (!emailAddress.isValid) {
      return const RequestPasswordResetResult.failure(AuthFailure.invalidInput());
    }

    final result = await _authRepository.requestPasswordReset(email: emailAddress);
    if (result.isSuccess) {
      return const RequestPasswordResetResult.success(safeSuccessMessage);
    }

    return RequestPasswordResetResult.failure(
      result.failure ?? const AuthFailure.unknownSafeFailure(),
    );
  }
}