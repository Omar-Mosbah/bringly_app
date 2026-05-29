import 'package:bringly_app/app/config/app_environment.dart';

enum EnvironmentValidationIssue {
  unsupportedEnvironment,
  missingSupabaseUrl,
  invalidSupabaseUrl,
  missingSupabaseAnonKey,
}

class EnvironmentProfile {
  const EnvironmentProfile({
    required this.name,
    required this.supabaseUrl,
    required this.supabaseAnonKeyPresent,
    required this.validationIssues,
  });

  final String name;
  final String supabaseUrl;
  final bool supabaseAnonKeyPresent;
  final List<EnvironmentValidationIssue> validationIssues;

  bool get isValid => validationIssues.isEmpty;

  AppEnvironment? get environment => AppEnvironment.maybeParse(name);

  String get safeUrlHost {
    final parsed = Uri.tryParse(supabaseUrl);
    return parsed?.host ?? 'Not configured';
  }
}
