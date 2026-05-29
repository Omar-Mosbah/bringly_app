import 'package:bringly_app/core/storage/protected_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProtectedStorageLocalStorage extends LocalStorage {
  const ProtectedStorageLocalStorage({
    required this.protectedStorage,
    this.persistSessionKey = 'supabase.auth.session',
  });

  final ProtectedStorage protectedStorage;
  final String persistSessionKey;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async {
    return (await protectedStorage.read(key: persistSessionKey)) != null;
  }

  @override
  Future<String?> accessToken() {
    return protectedStorage.read(key: persistSessionKey);
  }

  @override
  Future<void> removePersistedSession() {
    return protectedStorage.delete(key: persistSessionKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) {
    return protectedStorage.write(
      key: persistSessionKey,
      value: persistSessionString,
    );
  }
}

class ProtectedStorageAsyncStorage extends GotrueAsyncStorage {
  const ProtectedStorageAsyncStorage({
    required this.protectedStorage,
    this.keyPrefix = 'supabase.auth.async.',
  });

  final ProtectedStorage protectedStorage;
  final String keyPrefix;

  @override
  Future<String?> getItem({required String key}) {
    return protectedStorage.read(key: '$keyPrefix$key');
  }

  @override
  Future<void> removeItem({required String key}) {
    return protectedStorage.delete(key: '$keyPrefix$key');
  }

  @override
  Future<void> setItem({required String key, required String value}) {
    return protectedStorage.write(key: '$keyPrefix$key', value: value);
  }
}