import 'package:bringly_app/features/auth/data/auth_repository.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';

class SignUpWithEmail {
  const SignUpWithEmail(this._authRepository);

  final AuthRepository _authRepository;

  Future<AuthRepositoryResult<AuthAccountSnapshot>> call({
    required String email,
    required String password,
    required MarketplaceRole initialMarketplaceRole,
  }) async {
    final emailAddress = EmailAddress(email);
    if (!emailAddress.isValid) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.invalidInput(),
      );
    }

    final passwordInput = PasswordInput(password);
    if (!passwordInput.isValid) {
      return const AuthRepositoryResult<AuthAccountSnapshot>.failure(
        AuthFailure.weakPassword(),
      );
    }

    return _authRepository.registerWithEmail(
      email: emailAddress,
      password: passwordInput,
      initialMarketplaceRole: initialMarketplaceRole,
    );
  }
}