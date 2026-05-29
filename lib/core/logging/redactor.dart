class Redactor {
  const Redactor();

  static const String redactedToken = '[redacted-token]';
  static const String redactedEmail = '[redacted-email]';
  static const String redactedPhone = '[redacted-phone]';
  static const String redactedPayment = '[redacted-payment]';
  static const String redactedDocument = '[redacted-document]';
  static const String redactedReceipt = '[redacted-receipt]';
  static const String redactedTravelProof = '[redacted-travel-proof]';
  static const String redactedRisk = '[redacted-risk-data]';
  static const String redactedBackendSecret = '[redacted-backend-secret]';
  static const String redactedProviderError = '[redacted-provider-error]';

  static final RegExp _emailRegExp = RegExp(
    r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b',
    caseSensitive: false,
  );
  static final RegExp _phoneRegExp = RegExp(r'(\+?\d[\d\s\-\(\)]{7,}\d)');
  static final RegExp _tokenRegExp = RegExp(
    r'\b(?:eyJ|sbp_|sk_|pk_|token_|anon_)[A-Za-z0-9\-\._=]{6,}\b',
  );
  static final RegExp _paymentRegExp = RegExp(
    r'\b(?:4242[\s-]?4242[\s-]?4242[\s-]?4242|card|cvv|iban|payment)\b',
    caseSensitive: false,
  );
  static final RegExp _documentRegExp = RegExp(
    r'\b(?:passport|identity document|driver license|national id)\b',
    caseSensitive: false,
  );
  static final RegExp _receiptRegExp = RegExp(
    r'\b(?:receipt|invoice|proof of purchase)\b',
    caseSensitive: false,
  );
  static final RegExp _travelProofRegExp = RegExp(
    r'\b(?:boarding pass|itinerary|travel proof|flight)\b',
    caseSensitive: false,
  );
  static final RegExp _riskRegExp = RegExp(
    r'\b(?:risk score|fraud score|internal risk)\b',
    caseSensitive: false,
  );
  static final RegExp _backendSecretRegExp = RegExp(
    r'\b(?:service_role|service-role|secret|private key|backend key)\b',
    caseSensitive: false,
  );
  static final RegExp _providerErrorRegExp = RegExp(
    r'\b(?:postgres|stack trace|provider error|sqlstate)\b',
    caseSensitive: false,
  );

  String redactText(String input) {
    var output = input;
    output = output.replaceAll(_emailRegExp, redactedEmail);
    output = output.replaceAll(_phoneRegExp, redactedPhone);
    output = output.replaceAll(_tokenRegExp, redactedToken);
    output = output.replaceAll(_paymentRegExp, redactedPayment);
    output = output.replaceAll(_documentRegExp, redactedDocument);
    output = output.replaceAll(_receiptRegExp, redactedReceipt);
    output = output.replaceAll(_travelProofRegExp, redactedTravelProof);
    output = output.replaceAll(_riskRegExp, redactedRisk);
    output = output.replaceAll(_backendSecretRegExp, redactedBackendSecret);
    output = output.replaceAll(_providerErrorRegExp, redactedProviderError);
    return output;
  }

  Map<String, Object?> redactMetadata(Map<String, Object?> metadata) {
    return metadata.map(
      (key, value) => MapEntry(key, _redactValue(key, value)),
    );
  }

  Object? _redactValue(String key, Object? value) {
    final lowerKey = key.toLowerCase();
    if (value is String) {
      if (lowerKey.contains('token')) return redactedToken;
      if (lowerKey.contains('email')) return redactedEmail;
      if (lowerKey.contains('phone')) return redactedPhone;
      if (lowerKey.contains('payment') || lowerKey.contains('card')) {
        return redactedPayment;
      }
      if (lowerKey.contains('document')) return redactedDocument;
      if (lowerKey.contains('receipt')) return redactedReceipt;
      if (lowerKey.contains('travel')) return redactedTravelProof;
      if (lowerKey.contains('risk')) return redactedRisk;
      if (lowerKey.contains('secret') || lowerKey.contains('key')) {
        return redactedBackendSecret;
      }
      if (lowerKey.contains('error')) return redactedProviderError;
      return redactText(value);
    }

    if (value is Map<String, Object?>) {
      return redactMetadata(value);
    }

    if (value is Iterable) {
      return value
          .map((item) => _redactValue(key, item))
          .toList(growable: false);
    }

    return value;
  }
}
