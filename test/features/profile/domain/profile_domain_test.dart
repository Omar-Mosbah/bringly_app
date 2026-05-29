import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisplayName', () {
    test('accepts a trimmed visible value', () {
      final value = DisplayName('  Bringly User  ');

      expect(value.isValid, isTrue);
      expect(value.value, 'Bringly User');
    });

    test('rejects blank input', () {
      final value = DisplayName(' ');

      expect(value.isValid, isFalse);
      expect(value.validationMessage, isNotNull);
    });
  });

  test('country and city require both values', () {
    expect(CountryCity(country: 'Portugal', city: 'Lisbon').isValid, isTrue);
    expect(CountryCity(country: 'Portugal', city: '').isValid, isFalse);
  });

  test('preferred language supports the current safe set', () {
    expect(PreferredLanguage('en').isValid, isTrue);
    expect(PreferredLanguage('de').isValid, isFalse);
  });

  test('marketplace role exposes shopper and traveler support flags', () {
    expect(MarketplaceRole.both.supportsShopping, isTrue);
    expect(MarketplaceRole.both.supportsTravel, isTrue);
    expect(MarketplaceRole.unavailable.supportsShopping, isFalse);
  });

  test('verification and restriction gate protected marketplace access', () {
    final profile = UserProfile(
      displayName: DisplayName('Bringly User'),
      countryCity: CountryCity(country: 'Portugal', city: 'Lisbon'),
      preferredLanguage: PreferredLanguage('en'),
      marketplaceRole: MarketplaceRole.shopper,
      emailConfirmationStatus: EmailConfirmationStatus.confirmed,
      verificationStatus: VerificationStatus.verified,
      accountRestriction: AccountRestriction.active,
    );

    expect(profile.canAccessProtectedMarketplace, isTrue);
    expect(AccountRestriction.blocked.blocksProtectedMarketplace, isTrue);
  });
}