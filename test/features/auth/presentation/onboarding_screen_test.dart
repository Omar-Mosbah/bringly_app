import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/presentation/onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    required AuthController controller,
    VoidCallback? onRegister,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: OnboardingScreen(controller: controller, onRegister: onRegister),
      ),
    );
  }

  testWidgets('shows signed-out loading state', (tester) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      initialState: const AuthControllerState.loading(),
    );

    await pumpScreen(tester, controller: controller);

    expect(find.text('Checking account access'), findsOneWidget);
  });

  testWidgets('shows signed-out empty state', (tester) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      initialState: const AuthControllerState.empty(),
    );

    await pumpScreen(tester, controller: controller);

    expect(find.text('No saved session'), findsOneWidget);
  });

  testWidgets('shows normal onboarding state', (tester) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
    );

    await pumpScreen(tester, controller: controller);

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Choose how you want to use Bringly.'), findsOneWidget);
  });

  testWidgets('navigates to register through the provided callback', (
    tester,
  ) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
    );
    var tapped = 0;

    await pumpScreen(
      tester,
      controller: controller,
      onRegister: () => tapped += 1,
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('onboarding_register_button')),
        matching: find.byType(CupertinoButton),
      ),
    );
    await tester.pump();

    expect(tapped, 1);
  });
}