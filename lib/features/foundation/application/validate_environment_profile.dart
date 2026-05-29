import 'package:bringly_app/app/config/app_environment.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';

class ValidateEnvironmentProfile {
  const ValidateEnvironmentProfile();

  EnvironmentProfile call({
    required String environmentName,
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) {
    final issues = <EnvironmentValidationIssue>[];
    if (AppEnvironment.maybeParse(environmentName) == null) {
      issues.add(EnvironmentValidationIssue.unsupportedEnvironment);
    }
    if (supabaseUrl.trim().isEmpty) {
      issues.add(EnvironmentValidationIssue.missingSupabaseUrl);
    } else {
      final parsed = Uri.tryParse(supabaseUrl);
      if (parsed == null || !parsed.hasScheme || parsed.scheme != 'https') {
        issues.add(EnvironmentValidationIssue.invalidSupabaseUrl);
      }
    }
    if (supabaseAnonKey.trim().isEmpty) {
      issues.add(EnvironmentValidationIssue.missingSupabaseAnonKey);
    }

    return EnvironmentProfile(
      name: environmentName.trim(),
      supabaseUrl: supabaseUrl.trim(),
      supabaseAnonKeyPresent: supabaseAnonKey.trim().isNotEmpty,
      validationIssues: List<EnvironmentValidationIssue>.unmodifiable(issues),
    );
  }
}
