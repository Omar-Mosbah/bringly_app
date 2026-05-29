import 'package:bringly_app/features/profile/application/load_profile_summary.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/application/update_basic_profile.dart';
import 'package:bringly_app/features/profile/application/update_marketplace_role.dart';
import 'package:bringly_app/features/profile/data/profile_repository.dart';
import 'package:bringly_app/features/profile/presentation/role_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_profile_repository.dart';

void main() {
  ProfileController buildController({
    ProfileRepositoryFailure? failure,
    ProfileControllerState? initialState,
  }) {
    final repository = FakeProfileRepository()..nextRoleFailure = failure;
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
    VoidCallback? onSaved,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: RoleSelectionScreen(controller: controller, onSaved: onSaved),
      ),
    );
  }

  testWidgets('role selection screen saves shopper traveler and both', (tester) async {
    Future<void> expectRoleSave(String label) async {
      final controller = buildController();
      var saved = 0;

      await pumpScreen(tester, controller: controller, onSaved: () => saved += 1);
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save role'));
      await tester.pumpAndSettle();

      expect(saved, 1);
    }

    await expectRoleSave('Shopper');
    await expectRoleSave('Traveler');
    await expectRoleSave('Both');
  });

  testWidgets('role selection screen shows unavailable backend rejected unauthorized and loading states', (tester) async {
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
      await tester.tap(find.text('Save role'));
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
    }

    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.roleUnavailable,
        message: 'This role is not available right now.',
      ),
      'This role is not available right now.',
    );
    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.backendRejectedEligibility,
        message: 'The backend rejected this role selection.',
      ),
      'The backend rejected this role selection.',
    );
    await expectFailure(
      const ProfileRepositoryFailure(
        code: ProfileRepositoryFailureCode.unauthorized,
        message: 'Unauthorized.',
      ),
      'Unauthorized.',
    );
  });
}