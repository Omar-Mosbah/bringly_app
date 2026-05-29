class CountryCity {
  factory CountryCity({required String country, required String city}) {
    final normalizedCountry = country.trim();
    final normalizedCity = city.trim();
    final isValid =
        normalizedCountry.isNotEmpty &&
        normalizedCity.isNotEmpty &&
        normalizedCountry.length <= 56 &&
        normalizedCity.length <= 56;

    return CountryCity._(
      country: normalizedCountry,
      city: normalizedCity,
      isValid: isValid,
      validationMessage: isValid
          ? null
          : 'Choose both a country and city to continue.',
    );
  }

  const CountryCity._({
    required this.country,
    required this.city,
    required this.isValid,
    required this.validationMessage,
  });

  final String country;
  final String city;
  final bool isValid;
  final String? validationMessage;

  String get displayValue => '$city, $country';
}