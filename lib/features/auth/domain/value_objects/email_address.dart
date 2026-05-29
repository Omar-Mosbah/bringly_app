class EmailAddress {
  factory EmailAddress(String input) {
    final normalized = input.trim().toLowerCase();
    final isValid = _emailPattern.hasMatch(normalized);

    return EmailAddress._(
      original: input,
      value: normalized,
      isValid: isValid,
      validationMessage: isValid ? null : 'Enter a valid email address.',
    );
  }

  const EmailAddress._({
    required this.original,
    required this.value,
    required this.isValid,
    required this.validationMessage,
  });

  static final RegExp _emailPattern = RegExp(
    r'^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$',
    caseSensitive: false,
  );

  final String original;
  final String value;
  final bool isValid;
  final String? validationMessage;
}