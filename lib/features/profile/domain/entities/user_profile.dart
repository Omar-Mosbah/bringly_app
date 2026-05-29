import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';

class UserProfile {
  UserProfile({
    required this.displayName,
    required this.countryCity,
    required this.preferredLanguage,
    required this.marketplaceRole,
    required this.emailConfirmationStatus,
    required this.verificationStatus,
    required this.accountRestriction,
    this.avatarReference,
    this.profileCompletenessLabel = 'incomplete',
  });

  final DisplayName displayName;
  final String? avatarReference;
  final CountryCity countryCity;
  final PreferredLanguage preferredLanguage;
  final MarketplaceRole marketplaceRole;
  final EmailConfirmationStatus emailConfirmationStatus;
  final VerificationStatus verificationStatus;
  final AccountRestriction accountRestriction;
  final String profileCompletenessLabel;

  bool get canAccessProtectedMarketplace {
    return emailConfirmationStatus.allowsProtectedAccess &&
        verificationStatus.allowsProtectedMarketplaceAccess &&
        !accountRestriction.blocksProtectedMarketplace &&
        marketplaceRole != MarketplaceRole.unavailable;
  }
}