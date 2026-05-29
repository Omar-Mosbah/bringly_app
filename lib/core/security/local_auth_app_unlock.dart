import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class LocalAuthAppUnlock extends LocalAppUnlock {
  LocalAuthAppUnlock({LocalAuthentication? authentication})
    : _authentication = authentication ?? LocalAuthentication();

  final LocalAuthentication _authentication;

  @override
  Future<LocalAppUnlockStatus> checkAvailability() async {
    try {
      final isDeviceSupported = await _authentication.isDeviceSupported();
      final canCheckBiometrics = await _authentication.canCheckBiometrics;
      if (!isDeviceSupported && !canCheckBiometrics) {
        return const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.unavailable,
          method: LocalAppUnlockMethod.unavailable,
          safeReason: 'Local unlock is not available on this device.',
        );
      }

      final biometrics = await _authentication.getAvailableBiometrics();
      if (biometrics.isNotEmpty) {
        return const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.availableBiometric,
          method: LocalAppUnlockMethod.biometric,
        );
      }

      if (isDeviceSupported) {
        return const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.availableDevicePin,
          method: LocalAppUnlockMethod.devicePin,
        );
      }

      return const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.unknown,
        method: LocalAppUnlockMethod.unavailable,
      );
    } catch (error) {
      final code = _extractCode(error);
      if (code != null) {
        return _statusFromCode(code);
      }
      return const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.unknown,
        method: LocalAppUnlockMethod.unavailable,
      );
    }
  }

  @override
  Future<LocalAppUnlockResult> requestUnlock({required String reason}) async {
    try {
      final didAuthenticate = await _authentication.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: false,
        ),
      );

      return didAuthenticate
          ? LocalAppUnlockResult.unlocked
          : LocalAppUnlockResult.cancelled;
    } catch (error) {
      return switch (_extractCode(error)) {
        auth_error.notAvailable => LocalAppUnlockResult.notAvailable,
        auth_error.notEnrolled || auth_error.passcodeNotSet =>
          LocalAppUnlockResult.notAvailable,
        auth_error.lockedOut || auth_error.permanentlyLockedOut =>
          LocalAppUnlockResult.lockedOut,
        _ => LocalAppUnlockResult.error,
      };
    }
  }

  @override
  Future<void> reset() async {}

  LocalAppUnlockStatus _statusFromCode(String code) {
    return switch (code) {
      auth_error.notAvailable => const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.unavailable,
        method: LocalAppUnlockMethod.unavailable,
        safeReason: 'Local unlock is not available on this device.',
      ),
      auth_error.notEnrolled || auth_error.passcodeNotSet => const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.disabled,
        method: LocalAppUnlockMethod.unavailable,
        safeReason: 'Set up biometrics or device PIN to use local unlock.',
      ),
      auth_error.lockedOut || auth_error.permanentlyLockedOut =>
        const LocalAppUnlockStatus(
          availability: LocalAppUnlockAvailability.lockedOut,
          method: LocalAppUnlockMethod.biometric,
          safeReason: 'Local unlock is temporarily locked.',
        ),
      _ => const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.unknown,
        method: LocalAppUnlockMethod.unavailable,
      ),
    };
  }

  String? _extractCode(Object error) {
    try {
      final dynamic dynamicError = error;
      return dynamicError.code?.toString();
    } catch (_) {
      return null;
    }
  }
}