import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/application/load_profile_summary.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/application/update_basic_profile.dart';
import 'package:bringly_app/features/profile/application/update_marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';
import 'package:bringly_app/features/profile/presentation/profile_summary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_profile_repository.dart';

void main() {
  UserProfile buildProfile({
    VerificationStatus verificationStatus = VerificationStatus.verified,
    EmailConfirmationStatus emailStatus = EmailConfirmationStatus.confirmed,
    AccountRestriction restriction = AccountRestriction.active,
  }) {
    return UserProfile(
      displayName: DisplayName('Bringly Tester'),
      avatarReference: 'avatar://tester',
      countryCity: CountryCity(country: 'Portugal', city: 'Lisbon'),
      preferredLanguage: PreferredLanguage('en'),
      marketplaceRole: MarketplaceRole.both,
      emailConfirmationStatus: emailStatus,
      verificationStatus: verificationStatus,
      accountRestriction: restriction,
      profileCompletenessLabel: 'basic-ready',
    );
  }

  ProfileController buildController({
    UserProfile? profile,
    ProfileControllerState? initialState,
  }) {
    final repository = FakeProfileRepository(seededProfile: profile);
    return ProfileController(
      loadProfileSummary: LoadProfileSummary(repository),
      updateBasicProfile: UpdateBasicProfile(repository),
      updateMarketplaceRole: UpdateMarketplaceRole(repository),
      initialState: initialState ?? const ProfileControllerState.idle(),
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    required ProfileController controller,
  }) {
    return tester.pumpWidget(
      CupertinoApp(home: ProfileSummaryScreen(controller: controller)),
    );
  }

  testWidgets('profile summary screen shows loading and empty states', (tester) async {
    await pumpScreen(
      tester,
      controller: buildController(initialState: const ProfileControllerState.loading()),
    );
    expect(find.byType(CupertinoActivityIndicator), findsWidgets);

    await pumpScreen(
      tester,
      controller: buildController(initialState: const ProfileControllerState.empty()),
    );
    expect(find.text('Complete your basic profile to personalize Bringly.'), findsOneWidget);
  });

  testWidgets('profile summary screen renders safe profile and status details', (tester) async {
    await pumpScreen(
      tester,
      controller: buildController(
        initialState: ProfileControllerState.loaded(
          buildProfile(
            verificationStatus: VerificationStatus.underReview,
            emailStatus: EmailConfirmationStatus.pending,
          ),
        ),
      ),
    );

    expect(find.text('Bringly Tester'), findsOneWidget);
    expect(find.text('Lisbon, Portugal'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Both'), findsOneWidget);
    expect(find.text('Email confirmation: Pending'), findsOneWidget);
    expect(find.text('Verification: Under review'), findsOneWidget);
    expect(find.text('Account: Active'), findsOneWidget);
  });

  testWidgets('profile summary screen shows safe blocked guidance', (tester) async {
    await pumpScreen(
      tester,
      controller: buildController(
        initialState: ProfileControllerState.loaded(
          buildProfile(restriction: AccountRestriction.suspended),
        ),
      ),
    );

    expect(find.text('Protected marketplace actions are unavailable right now.'), findsOneWidget);
  });
}