import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/application/load_profile_summary.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/application/update_basic_profile.dart';
import 'package:bringly_app/features/profile/application/update_marketplace_role.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/domain/value_objects/country_city.dart';
import 'package:bringly_app/features/profile/domain/value_objects/display_name.dart';
import 'package:bringly_app/features/profile/domain/value_objects/preferred_language.dart';
import 'package:bringly_app/features/profile/presentation/profile_edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_profile_repository.dart';

void main() {
  UserProfile buildProfile() {
    return UserProfile(
      displayName: DisplayName('Bringly Tester'),
      avatarReference: 'avatar://tester',
      countryCity: CountryCity(country: 'Portugal', city: 'Lisbon'),
      preferredLanguage: PreferredLanguage('en'),
      marketplaceRole: MarketplaceRole.both,
      emailConfirmationStatus: EmailConfirmationStatus.confirmed,
      verificationStatus: VerificationStatus.verified,
      accountRestriction: AccountRestriction.active,
      profileCompletenessLabel: 'basic-ready',
    );
  }

  ProfileController buildController({
    ProfileRepositoryFailure? failure,
    ProfileControllerState? initialState,
  }) {
    final repository = FakeProfileRepository(seededProfile: buildProfile())
      ..nextUpdateFailure = failure;
    return ProfileController(
      loadProfileSummary: LoadProfileSummary(repository),
      updateBasicProfile: UpdateBasicProfile(repository),
      updateMarketplaceRole: UpdateMarketplaceRole(repository),
      initialState: initialState ?? ProfileControllerState.loaded(buildProfile()),
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    required ProfileController controller,
    VoidCallback? onSaved,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: ProfileEditScreen(controller: controller, onSaved: onSaved),
      ),
    );
  }

  Future<void> enterValues(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(const ValueKey<String>('profile_display_name_field')),
      'Updated Tester',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('profile_avatar_reference_field')),
      'avatar://updated',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('profile_country_field')),
      'Spain',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('profile_city_field')),
      'Madrid',
    );
    await tester.tap(find.text('Spanish'));
    await tester.pumpAndSettle();
  }

  testWidgets('profile edit screen updates valid values successfully', (tester) async {
    final controller = buildController();
    var saved = 0;

    await pumpScreen(tester, controller: controller, onSaved: () => saved += 1);
    await enterValues(tester);
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();

    expect(saved, 1);
    expect(controller.state.profile?.displayName.value, 'Updated Tester');
    expect(controller.state.profile?.preferredLanguage.value, 'es');
  });

  testWidgets('profile edit screen validates visible fields before submit', (tester) async {
    final controller = buildController();

    await pumpScreen(tester, controller: controller);
    await tester.enterText(
      find.byKey(const ValueKey<String>('profile_display_name_field')),
      'A',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('profile_country_field')),
      '',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('profile_city_field')),
      '',
    );
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();

    expect(find.text('Use 2 to 40 visible characters for your display name.'), findsOneWidget);
    expect(find.text('Choose both a country and city to continue.'), findsOneWidget);
  });

  testWidgets('profile edit screen shows loading and safe failures', (tester) async {
    await pumpScreen(
      tester,
      controller: buildController(
        initialState: const ProfileControllerState.loading(),
      ),
    );
    expect(find.byType(CupertinoActivityIndicator), findsWidgets);

    Future<void> expectFailure(ProfileRepositoryFailure failure, String message) async {
      final controller = buildController(failure: failure);
      await pumpScreen(tester, controller: controller);
      await enterValues(tester);
      await tester.tap(find.text('Save profile'));
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
    }

    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.unauthorized,
        message: 'Unauthorized.',
      ),
      'Unauthorized.',
    );
    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.blocked,
        message: 'Blocked.',
      ),
      'Blocked.',
    );
  });
}