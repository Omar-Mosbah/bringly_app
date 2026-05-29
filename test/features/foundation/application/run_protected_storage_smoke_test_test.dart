import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:bringly_app/core/storage/protected_storage.dart';
import 'package:bringly_app/features/foundation/application/run_protected_storage_smoke_test.dart';
import 'package:bringly_app/features/foundation/domain/entities/protected_storage_smoke_test_result.dart';
import 'package:flutter_test/flutter_test.dart';

class _WriteFailingStorage extends ProtectedStorage {
  @override
  Future<void> delete({required String key}) async {}

  @override
  Future<String?> read({required String key}) async => null;

  @override
  Future<void> write({required String key, required String value}) async {
    throw Exception('write failed');
  }
}

class _ReadFailingStorage extends MemoryProtectedStorage {
  @override
  Future<String?> read({required String key}) async => 'unexpected';
}

class _DeleteFailingStorage extends MemoryProtectedStorage {
  @override
  Future<void> delete({required String key}) async {
    throw Exception('delete failed');
  }
}

void main() {
  test('storage smoke test passes and cleans up after success', () async {
    final storage = MemoryProtectedStorage();
    final useCase = RunProtectedStorageSmokeTest(storage);

    final result = await useCase();

    expect(result.status, ProtectedStorageSmokeTestStatus.passed);
    expect(
      await storage.read(key: RunProtectedStorageSmokeTest.validationKey),
      isNull,
    );
  });

  test('storage smoke test maps write failure', () async {
    final useCase = RunProtectedStorageSmokeTest(_WriteFailingStorage());
    final result = await useCase();
    expect(result.status, ProtectedStorageSmokeTestStatus.writeFailed);
  });

  test('storage smoke test maps read failure', () async {
    final useCase = RunProtectedStorageSmokeTest(_ReadFailingStorage());
    final result = await useCase();
    expect(result.status, ProtectedStorageSmokeTestStatus.readFailed);
  });

  test('storage smoke test maps delete failure', () async {
    final useCase = RunProtectedStorageSmokeTest(_DeleteFailingStorage());
    final result = await useCase();
    expect(result.status, ProtectedStorageSmokeTestStatus.deleteFailed);
  });

  test('storage smoke test can be skipped', () async {
    final useCase = RunProtectedStorageSmokeTest(MemoryProtectedStorage());
    final result = await useCase(enabled: false);
    expect(result.status, ProtectedStorageSmokeTestStatus.skipped);
  });
}
