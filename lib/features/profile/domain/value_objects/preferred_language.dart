class PreferredLanguage {
  factory PreferredLanguage(String code) {
    final normalized = code.trim().toLowerCase();
    final isValid = _supportedCodes.contains(normalized);

    return PreferredLanguage._(
      value: normalized,
      isValid: isValid,
      validationMessage: isValid ? null : 'Select a supported language.',
    );
  }

  const PreferredLanguage._({
    required this.value,
    required this.isValid,
    required this.validationMessage,
  });

  static const Set<String> _supportedCodes = <String>{'en', 'es', 'fr'};

  final String value;
  final bool isValid;
  final String? validationMessage;
}