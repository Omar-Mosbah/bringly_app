import 'package:bringly_app/core/storage/memory_protected_storage.dart';
import 'package:bringly_app/features/auth/data/protected_auth_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('persisted secure session is removed on sign out', () async {
    final storage = MemoryProtectedStorage();
    final authStorage = ProtectedAuthStorage(storage);

    await authStorage.writeSession(
      const ProtectedAuthSession(
        accessToken: 'access-token',
        refreshToken: 'refresh-token',
        serializedSession:
            '{"access_token":"access-token","refresh_token":"refresh-token"}',
      ),
    );

    expect(await authStorage.readSession(), isNotNull);

    await authStorage.clearSession();

    expect(await authStorage.readSession(), isNull);
  });
}