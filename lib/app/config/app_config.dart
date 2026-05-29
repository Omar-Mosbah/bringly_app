import 'package:bringly_app/features/foundation/application/validate_environment_profile.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';

class AppConfig {
  const AppConfig({
    required this.environmentName,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.environmentProfile,
  });

  final String environmentName;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final EnvironmentProfile environmentProfile;

  bool get isValid => environmentProfile.isValid;

  String get safeAnonKeyStatus =>
      supabaseAnonKey.isEmpty ? 'Missing' : 'Configured';

  factory AppConfig.fromEnvironment({
    ValidateEnvironmentProfile validator = const ValidateEnvironmentProfile(),
  }) {
    const environmentName = String.fromEnvironment(
      'BRINGLY_ENV',
      defaultValue: 'development',
    );
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    final environmentProfile = validator(
      environmentName: environmentName,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
    );

    return AppConfig(
      environmentName: environmentName,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      environmentProfile: environmentProfile,
    );
  }
}
