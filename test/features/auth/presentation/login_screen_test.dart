import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/presentation/login_screen.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  Future<AuthController> buildController({AuthFailure? failure, AuthControllerState? initialState}) async {
    final repository = FakeAuthRepository();
    await repository.registerWithEmail(
      email: EmailAddress('returning@example.com'),
      password: PasswordInput('Bringly123'),
      initialMarketplaceRole: MarketplaceRole.shopper,
    );
    repository.nextSignInFailure = failure;

    return AuthController(
      signUpWithEmail: SignUpWithEmail(repository),
      signInWithEmail: SignInWithEmail(repository),
      initialState: initialState ?? const AuthControllerState.signedOut(),
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AuthController controller,
    VoidCallback? onLoggedIn,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: LoginScreen(controller: controller, onLoggedIn: onLoggedIn),
      ),
    );
  }

  Finder submitButton() => find.descendant(
        of: find.byKey(const ValueKey<String>('login_submit_button')),
        matching: find.byType(CupertinoButton),
      );

  Future<void> enterCredentials(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    await tester.enterText(
      find.byKey(const ValueKey<String>('login_email_field')),
      email,
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('login_password_field')),
      password,
    );
  }

  testWidgets('login screen submits valid credentials successfully', (tester) async {
    final controller = await buildController();
    var loggedIn = 0;

    await pumpScreen(tester, controller: controller, onLoggedIn: () => loggedIn += 1);
    await enterCredentials(
      tester,
      email: 'returning@example.com',
      password: 'Bringly123',
    );
    await tester.tap(submitButton());
    await tester.pumpAndSettle();

    expect(loggedIn, 1);
  });

  testWidgets('login screen shows loading state', (tester) async {
    final controller = await buildController(
      initialState: const AuthControllerState.loading(),
    );

    await pumpScreen(tester, controller: controller);

    expect(find.byType(CupertinoActivityIndicator), findsWidgets);
  });

  testWidgets('login screen shows invalid credentials error', (tester) async {
    final controller = await buildController();

    await pumpScreen(tester, controller: controller);
    await enterCredentials(
      tester,
      email: 'returning@example.com',
      password: 'wrong-password',
    );
    await tester.tap(submitButton());
    await tester.pumpAndSettle();

    expect(find.text('The email or password is not correct.'), findsOneWidget);
  });

  testWidgets('login screen shows offline rate-limited blocked and safe errors', (tester) async {
    Future<void> expectFailure(AuthFailure failure, String message) async {
      final controller = await buildController(failure: failure);
      await pumpScreen(tester, controller: controller);
      await enterCredentials(
        tester,
        email: 'returning@example.com',
        password: 'Bringly123',
      );
      await tester.tap(submitButton());
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
    }

    await expectFailure(const AuthFailure.offline(), 'No network connection is available right now.');
    await expectFailure(const AuthFailure.rateLimited(), 'Too many attempts were made. Try again shortly.');
    await expectFailure(const AuthFailure.blocked(), 'This account cannot use protected actions right now.');
    await expectFailure(const AuthFailure.unknownSafeFailure(), 'Something went wrong. Please try again.');
  });
}