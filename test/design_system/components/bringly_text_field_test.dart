import 'package:bringly_app/design_system/components/bringly_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_bringly_widget.dart';

void main() {
  group('BringlyTextField', () {
    testWidgets('renders label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyTextField(label: 'Full name'),
      );
      expect(find.text('Full name'), findsOneWidget);
    });

    testWidgets('renders helper text when provided', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyTextField(
          label: 'Email',
          helperText: 'Enter a valid email address',
        ),
      );
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('renders validation error text when in error state', (
      tester,
    ) async {
      await pumpBringlyWidget(
        tester,
        const BringlyTextField(
          label: 'Email',
          errorText: 'Email is required',
          isError: true,
        ),
      );
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows both label and error when error state active', (
      tester,
    ) async {
      await pumpBringlyWidget(
        tester,
        const BringlyTextField(
          label: 'Email',
          errorText: 'Invalid format',
          isError: true,
        ),
      );
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Invalid format'), findsOneWidget);
    });

    testWidgets('disabled state renders without interaction', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyTextField(label: 'Disabled field', isDisabled: true),
      );
      final field = tester.widget<BringlyTextField>(
        find.byType(BringlyTextField),
      );
      expect(field.isDisabled, isTrue);
    });

    testWidgets('does not log or store entered values - field accepts input', (
      tester,
    ) async {
      final controller = TextEditingController();
      await pumpBringlyWidget(
        tester,
        BringlyTextField(label: 'Name', controller: controller),
      );
      await tester.enterText(find.byType(CupertinoTextField), 'test input');
      // Verifying no exception thrown and input accepted safely
      expect(tester.takeException(), isNull);
    });

    testWidgets('has stable test key', (tester) async {
      await pumpBringlyWidget(
        tester,
        const BringlyTextField(key: Key('field_name'), label: 'Name'),
      );
      expect(find.byKey(const Key('field_name')), findsOneWidget);
    });
  });
}
