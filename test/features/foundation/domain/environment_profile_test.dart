import 'package:bringly_app/features/foundation/application/validate_environment_profile.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validate = ValidateEnvironmentProfile();

  test('creates a valid environment profile', () {
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: 'anon-public-key',
    );

    expect(profile.isValid, isTrue);
    expect(profile.validationIssues, isEmpty);
  });

  test('flags missing URL', () {
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: '',
      supabaseAnonKey: 'anon-public-key',
    );

    expect(
      profile.validationIssues,
      contains(EnvironmentValidationIssue.missingSupabaseUrl),
    );
  });

  test('flags missing key', () {
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: '',
    );

    expect(
      profile.validationIssues,
      contains(EnvironmentValidationIssue.missingSupabaseAnonKey),
    );
  });

  test('flags invalid URL', () {
    final profile = validate(
      environmentName: 'development',
      supabaseUrl: 'http://example.supabase.co',
      supabaseAnonKey: 'anon-public-key',
    );

    expect(
      profile.validationIssues,
      contains(EnvironmentValidationIssue.invalidSupabaseUrl),
    );
  });

  test('flags unsupported environment names', () {
    final profile = validate(
      environmentName: 'qa',
      supabaseUrl: 'https://example.supabase.co',
      supabaseAnonKey: 'anon-public-key',
    );

    expect(
      profile.validationIssues,
      contains(EnvironmentValidationIssue.unsupportedEnvironment),
    );
  });
}
