import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/application/sign_up_with_email.dart';
import 'package:bringly_app/features/auth/domain/entities/auth_failure.dart';
import 'package:bringly_app/features/auth/presentation/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/fake_auth_repository.dart';

void main() {
  Future<void> pumpScreen(
    WidgetTester tester, {
    required AuthController controller,
    VoidCallback? onRegistered,
  }) {
    return tester.pumpWidget(
      CupertinoApp(
        home: RegisterScreen(
          controller: controller,
          onRegistered: onRegistered,
        ),
      ),
    );
  }

  Future<void> enterCredentials(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    await tester.enterText(
      find.byKey(const ValueKey<String>('register_email_field')),
      email,
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('register_password_field')),
      password,
    );
  }

  testWidgets('submits valid registration input', (tester) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
    );
    var registered = 0;

    await pumpScreen(
      tester,
      controller: controller,
      onRegistered: () => registered += 1,
    );

    await enterCredentials(
      tester,
      email: 'new-user@example.com',
      password: 'Bringly123',
    );
    await tester.tap(find.byKey(const ValueKey<String>('register_submit_button')));
    await tester.pumpAndSettle();

    expect(registered, 1);
  });

  testWidgets('shows invalid input feedback', (tester) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
    );

    await pumpScreen(tester, controller: controller);

    await enterCredentials(tester, email: 'bad-email', password: 'short');
    await tester.tap(find.byKey(const ValueKey<String>('register_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Use at least 8 characters with letters and numbers.'), findsOneWidget);
  });

  testWidgets('shows loading state while registration is in progress', (tester) async {
    final controller = AuthController(
      signUpWithEmail: SignUpWithEmail(FakeAuthRepository()),
      initialState: const AuthControllerState.loading(),
    );

    await pumpScreen(tester, controller: controller);

    expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
  });

  testWidgets('shows duplicate email error state', (tester) async {
    final repository = FakeAuthRepository()..unavailableEmails.add('taken@example.com');
    final controller = AuthController(signUpWithEmail: SignUpWithEmail(repository));

    await pumpScreen(tester, controller: controller);

    await enterCredentials(
      tester,
      email: 'taken@example.com',
      password: 'Bringly123',
    );
    await tester.tap(find.byKey(const ValueKey<String>('register_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('That email cannot be used for registration right now.'), findsOneWidget);
  });

  testWidgets('shows rate-limited offline and safe error states', (tester) async {
    final rateLimitedController = AuthController(
      signUpWithEmail: SignUpWithEmail(
        FakeAuthRepository()..nextRegisterFailure = const AuthFailure.rateLimited(),
      ),
    );
    final offlineController = AuthController(
      signUpWithEmail: SignUpWithEmail(
        FakeAuthRepository()..nextRegisterFailure = const AuthFailure.offline(),
      ),
    );
    final safeErrorController = AuthController(
      signUpWithEmail: SignUpWithEmail(
        FakeAuthRepository()..nextRegisterFailure = const AuthFailure.unknownSafeFailure(),
      ),
    );

    await pumpScreen(tester, controller: rateLimitedController);
    await enterCredentials(
      tester,
      email: 'new-user@example.com',
      password: 'Bringly123',
    );
    await tester.tap(find.byKey(const ValueKey<String>('register_submit_button')));
    await tester.pumpAndSettle();
    expect(find.text('Too many attempts were made. Try again shortly.'), findsOneWidget);

    await pumpScreen(tester, controller: offlineController);
    await enterCredentials(
      tester,
      email: 'new-user@example.com',
      password: 'Bringly123',
    );
    await tester.tap(find.byKey(const ValueKey<String>('register_submit_button')));
    await tester.pumpAndSettle();
    expect(find.text('No network connection is available right now.'), findsOneWidget);

    await pumpScreen(tester, controller: safeErrorController);
    await enterCredentials(
      tester,
      email: 'new-user@example.com',
      password: 'Bringly123',
    );
    await tester.tap(find.byKey(const ValueKey<String>('register_submit_button')));
    await tester.pumpAndSettle();
    expect(find.text('Something went wrong. Please try again.'), findsOneWidget);
  });
}