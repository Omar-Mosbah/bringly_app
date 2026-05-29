enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment? maybeParse(String rawValue) {
    final normalized = rawValue.toLowerCase().trim();
    for (final environment in values) {
      if (environment.name == normalized) {
        return environment;
      }
    }
    return null;
  }
}
