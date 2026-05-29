class DisplayName {
  factory DisplayName(String input) {
    final normalized = input.trim();
    final hasNoControlChars = !RegExp(r'[\r\n\t]').hasMatch(normalized);
    final isValid =
        normalized.length >= 2 && normalized.length <= 40 && hasNoControlChars;

    return DisplayName._(
      original: input,
      value: normalized,
      isValid: isValid,
      validationMessage: isValid
          ? null
          : 'Use 2 to 40 visible characters for your display name.',
    );
  }

  const DisplayName._({
    required this.original,
    required this.value,
    required this.isValid,
    required this.validationMessage,
  });

  final String original;
  final String value;
  final bool isValid;
  final String? validationMessage;
}