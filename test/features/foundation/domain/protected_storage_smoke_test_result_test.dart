import 'package:bringly_app/features/foundation/domain/entities/protected_storage_smoke_test_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'protected storage smoke result supports pass and partial failure statuses',
    () {
      const passed = ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.passed,
        safeMessage: 'ok',
      );
      const failed = ProtectedStorageSmokeTestResult(
        status: ProtectedStorageSmokeTestStatus.deleteFailed,
        safeMessage: 'cleanup failed',
      );

      expect(passed.status, ProtectedStorageSmokeTestStatus.passed);
      expect(failed.status, ProtectedStorageSmokeTestStatus.deleteFailed);
    },
  );
}
