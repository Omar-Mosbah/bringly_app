class PasswordInput {
  factory PasswordInput(String input) {
    final trimmed = input.trim();
    final hasMinimumLength = trimmed.length >= 8;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(trimmed);
    final hasDigit = RegExp(r'\d').hasMatch(trimmed);
    final isValid = trimmed.isNotEmpty && hasMinimumLength && hasLetter && hasDigit;

    return PasswordInput._(
      original: input,
      value: trimmed,
      isValid: isValid,
      validationMessage: isValid
          ? null
          : 'Use at least 8 characters with letters and numbers.',
    );
  }

  const PasswordInput._({
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