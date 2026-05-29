import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/validate_environment_profile.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/connectivity_check_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validate = ValidateEnvironmentProfile();
  final profile = validate(
    environmentName: 'development',
    supabaseUrl: 'https://example.supabase.co',
    supabaseAnonKey: 'anon-public-key',
  );

  Future<ConnectivityCheckStatus> statusFor(
    BackendConnectivityStatus status,
  ) async {
    final result = await RunConnectivityCheck(
      FakeConnectivityClient(nextStatus: status),
    )(profile);
    return result.status;
  }

  test(
    'covers success unavailable timeout offline and failed outcomes',
    () async {
      expect(
        await statusFor(BackendConnectivityStatus.success),
        ConnectivityCheckStatus.success,
      );
      expect(
        await statusFor(BackendConnectivityStatus.unavailable),
        ConnectivityCheckStatus.unavailable,
      );
      expect(
        await statusFor(BackendConnectivityStatus.timeout),
        ConnectivityCheckStatus.timeout,
      );
      expect(
        await statusFor(BackendConnectivityStatus.offline),
        ConnectivityCheckStatus.offline,
      );
      expect(
        await statusFor(BackendConnectivityStatus.failed),
        ConnectivityCheckStatus.failed,
      );
    },
  );

  test('invalid configuration maps to invalidConfiguration', () async {
    final invalidProfile = validate(
      environmentName: 'development',
      supabaseUrl: '',
      supabaseAnonKey: '',
    );
    final result = await RunConnectivityCheck(
      const FakeConnectivityClient(
        nextStatus: BackendConnectivityStatus.success,
      ),
    )(invalidProfile);

    expect(result.status, ConnectivityCheckStatus.invalidConfiguration);
  });
}
