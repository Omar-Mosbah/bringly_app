import 'dart:async';
import 'dart:io';

import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/connectivity_check_result.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';

class RunConnectivityCheck {
  const RunConnectivityCheck(this._client);

  final BackendConnectivityClient _client;

  Future<ConnectivityCheckResult> call(EnvironmentProfile profile) async {
    if (!profile.isValid) {
      return ConnectivityCheckResult(
        status: ConnectivityCheckStatus.invalidConfiguration,
        safeMessage:
            'Configuration must be fixed before backend checks can run.',
        checkedAt: DateTime.now(),
      );
    }

    try {
      final status = await _client.checkConnectivity(profile);
      return _mapStatus(status);
    } on TimeoutException {
      return _safeResult(
        ConnectivityCheckStatus.timeout,
        'The backend took too long to respond.',
      );
    } on SocketException {
      return _safeResult(
        ConnectivityCheckStatus.offline,
        'This device appears to be offline.',
      );
    } catch (_) {
      return _safeResult(
        ConnectivityCheckStatus.failed,
        'The backend check failed without exposing provider details.',
      );
    }
  }

  ConnectivityCheckResult _mapStatus(BackendConnectivityStatus status) {
    return switch (status) {
      BackendConnectivityStatus.success => _safeResult(
        ConnectivityCheckStatus.success,
        'The backend is reachable with the current public configuration.',
      ),
      BackendConnectivityStatus.unavailable => _safeResult(
        ConnectivityCheckStatus.unavailable,
        'The backend is temporarily unavailable.',
      ),
      BackendConnectivityStatus.timeout => _safeResult(
        ConnectivityCheckStatus.timeout,
        'The backend took too long to respond.',
      ),
      BackendConnectivityStatus.offline => _safeResult(
        ConnectivityCheckStatus.offline,
        'This device appears to be offline.',
      ),
      BackendConnectivityStatus.failed => _safeResult(
        ConnectivityCheckStatus.failed,
        'The backend check failed without exposing provider details.',
      ),
    };
  }

  ConnectivityCheckResult _safeResult(
    ConnectivityCheckStatus status,
    String safeMessage,
  ) {
    return ConnectivityCheckResult(
      status: status,
      safeMessage: safeMessage,
      checkedAt: DateTime.now(),
    );
  }
}
