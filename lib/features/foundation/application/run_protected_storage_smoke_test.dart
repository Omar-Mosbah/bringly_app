import 'package:bringly_app/core/storage/protected_storage.dart';
import 'package:bringly_app/features/foundation/domain/entities/protected_storage_smoke_test_result.dart';

class RunProtectedStorageSmokeTest {
  const RunProtectedStorageSmokeTest(this._storage);

  static const String validationKey = 'phase0_validation_key';
  static const String validationValue = 'phase0-safe-check';

  final ProtectedStorage _storage;

  Future<ProtectedStorageSmokeTestResult> call({bool enabled = true}) async {
    if (!enabled) {
      return const ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.skipped,
        safeMessage: 'Protected storage check was skipped.',
      );
    }

    try {
      await _storage.write(key: validationKey, value: validationValue);
    } catch (_) {
      return ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.writeFailed,
        safeMessage: 'Protected storage could not save the validation value.',
        ranAt: DateTime.now(),
      );
    }

    try {
      final storedValue = await _storage.read(key: validationKey);
      if (storedValue != validationValue) {
        await _deleteQuietly();
        return ProtectedStorageSmokeTestResult(
          status: ProtectedStorageSmokeTestStatus.readFailed,
          safeMessage:
              'Protected storage could not read back the validation value.',
          ranAt: DateTime.now(),
        );
      }
    } catch (_) {
      await _deleteQuietly();
      return ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.readFailed,
        safeMessage:
            'Protected storage could not read back the validation value.',
        ranAt: DateTime.now(),
      );
    }

    try {
      await _storage.delete(key: validationKey);
      final deletedValue = await _storage.read(key: validationKey);
      if (deletedValue != null) {
        return ProtectedStorageSmokeTestResult(
          status: ProtectedStorageSmokeTestStatus.deleteFailed,
          safeMessage: 'Protected storage cleanup did not complete.',
          ranAt: DateTime.now(),
        );
      }
    } catch (_) {
      return ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.deleteFailed,
        safeMessage: 'Protected storage cleanup did not complete.',
        ranAt: DateTime.now(),
      );
    }

    return ProtectedStorageSmokeTestResult(
      status: ProtectedStorageSmokeTestStatus.passed,
      safeMessage: 'Protected storage is available and cleaned up safely.',
      ranAt: DateTime.now(),
    );
  }

  Future<void> _deleteQuietly() async {
    try {
      await _storage.delete(key: validationKey);
    } catch (_) {
      // Best effort cleanup keeps recoverable failures from leaving the
      // harmless validation value behind.
    }
  }
}
