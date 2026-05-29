import 'dart:async';
import 'dart:io';

import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/validate_environment_profile.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/connectivity_check_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validate = ValidateEnvironmentProfile();

  test('maps success outcome', () async {
    const useCase = RunConnectivityCheck(
      FakeConnectivityClient(nextStatus: BackendConnectivityStatus.success),
    );
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: 'anon-public-key',
    );

    final result = await useCase(profile);
    expect(result.status, ConnectivityCheckStatus.success);
  });

  test('blocks invalid config before client call', () async {
    const useCase = RunConnectivityCheck(
      FakeConnectivityClient(nextStatus: BackendConnectivityStatus.success),
    );
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: '',
      supabaseAnonKey: '',
    );

    final result = await useCase(profile);
    expect(result.status, ConnectivityCheckStatus.invalidConfiguration);
  });

  test('maps provider errors to safe failures', () async {
    final useCase = RunConnectivityCheck(
      FakeConnectivityClient(
        nextStatus: BackendConnectivityStatus.failed,
        throwError: Exception('postgres stack trace'),
      ),
    );
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: 'anon-public-key',
    );

    final result = await useCase(profile);
    expect(result.status, ConnectivityCheckStatus.failed);
    expect(result.safeMessage, isNot(contains('postgres')));
  });

  test('maps timeout and offline exceptions', () async {
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: 'anon-public-key',
    );

    final timeoutResult = await RunConnectivityCheck(
      FakeConnectivityClient(
        nextStatus: BackendConnectivityStatus.failed,
        throwError: TimeoutException('too slow'),
      ),
    )(profile);

    final offlineResult = await RunConnectivityCheck(
      FakeConnectivityClient(
        nextStatus: BackendConnectivityStatus.failed,
        throwError: const SocketException('offline'),
      ),
    )(profile);

    expect(timeoutResult.status, ConnectivityCheckStatus.timeout);
    expect(offlineResult.status, ConnectivityCheckStatus.offline);
  });
}
