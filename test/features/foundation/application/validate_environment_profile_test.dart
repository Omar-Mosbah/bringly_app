import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/application/run_connectivity_check.dart';
import 'package:bringly_app/features/foundation/application/validate_environment_profile.dart';
import 'package:bringly_app/features/foundation/data/fake_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/connectivity_check_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validate = ValidateEnvironmentProfile();

  test('valid config stays valid', () {
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: 'anon-public-key',
    );

    expect(profile.isValid, isTrue);
  });

  test('invalid config is flagged', () {
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: '',
      supabaseAnonKey: '',
    );

    expect(profile.isValid, isFalse);
  });

  test('invalid config does not attempt connectivity', () async {
    const client = FakeConnectivityClient(
      nextStatus: BackendConnectivityStatus.success,
    );
    const runConnectivityCheck = RunConnectivityCheck(client);
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: '',
      supabaseAnonKey: '',
    );

    final result = await runConnectivityCheck(profile);
    expect(result.status, ConnectivityCheckStatus.invalidConfiguration);
  });
}
