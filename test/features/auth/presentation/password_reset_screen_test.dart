import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/request_password_reset.dart';
import 'package:bringly_app/features/auth/application/sign_in_with_email.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/presentation/password_reset_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  AuthController buildController({
    AuthFailure? failure,
    AuthControllerState? initialState,
  }) {
    final repository = FakeAuthRepository()..nextPasswordResetFailure = failure;
    return AuthController(
      signUpWithEmail: SignUpWithEmail(repository),
      signInWithEmail: SignInWithEmail(repository),
      requestPasswordReset: RequestPasswordReset(repository),
      initialState: initialState ?? const AuthControllerState.signedOut(),
    );
  }

  Future<void> pumpScreen(
    WidgetTester tester, {
    required AuthController controller,
  }) {
    return tester.pumpWidget(
      CupertinoApp(home: PasswordResetScreen(controller: controller)),
    );
  }

  Future<void> enterEmail(WidgetTester tester, String email) {
    return tester.enterText(
      find.byKey(const ValueKey<String>('password_reset_email_field')),
      email,
    );
  }

  testWidgets('password reset screen validates input before submitting', (tester) async {
    final controller = buildController();

    await pumpScreen(tester, controller: controller);
    await enterEmail(tester, 'invalid-email');
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
  });

  testWidgets('password reset screen shows loading state', (tester) async {
    final controller = buildController(
      initialState: const AuthControllerState.loading(),
    );

    await pumpScreen(tester, controller: controller);

    expect(find.byType(CupertinoActivityIndicator), findsWidgets);
  });

  testWidgets('password reset screen shows safe success response', (tester) async {
    final controller = buildController();

    await pumpScreen(tester, controller: controller);
    await enterEmail(tester, 'known@example.com');
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();

    expect(find.text('If the email can receive reset instructions, a secure link will arrive shortly.'), findsOneWidget);
  });

  testWidgets('password reset screen shows rate limited offline and safe errors', (tester) async {
    Future<void> expectFailure(AuthFailure failure, String message) async {
      final controller = buildController(failure: failure);
      await pumpScreen(tester, controller: controller);
      await enterEmail(tester, 'known@example.com');
      await tester.tap(find.text('Send reset link'));
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
    }

    await expectFailure(
      const AuthFailure.rateLimited(),
      'Too many attempts were made. Try again shortly.',
    );
    await expectFailure(
      const AuthFailure.offline(),
      'No network connection is available right now.',
    );
    await expectFailure(
      const AuthFailure.unknownSafeFailure(),
      'Something went wrong. Please try again.',
    );
  });
}