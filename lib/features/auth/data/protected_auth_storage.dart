import 'dart:convert';

import 'package:bringly_app/core/storage/protected_storage.dart';

class ProtectedAuthSession {
  const ProtectedAuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.serializedSession,
  });

  final String accessToken;
  final String refreshToken;
  final String serializedSession;
}

class ProtectedAuthStorage {
  const ProtectedAuthStorage(this._protectedStorage);

  static const String sessionKey = 'auth.session';

  final ProtectedStorage _protectedStorage;

  Future<void> writeSession(ProtectedAuthSession session) {
    return _protectedStorage.write(
      key: sessionKey,
      value: session.serializedSession,
    );
  }

  Future<ProtectedAuthSession?> readSession() async {
    final serializedSession = await _protectedStorage.read(key: sessionKey);
    if (serializedSession == null || serializedSession.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(serializedSession);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final accessToken = decoded['access_token']?.toString();
      final refreshToken = decoded['refresh_token']?.toString();
      if (accessToken == null || refreshToken == null) {
        return null;
      }

      return ProtectedAuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        serializedSession: serializedSession,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() {
    return _protectedStorage.delete(key: sessionKey);
  }
}