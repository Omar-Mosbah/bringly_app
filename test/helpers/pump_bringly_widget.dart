import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [widget] inside a minimal [CupertinoApp] configured with the
/// Bringly theme so widget tests can exercise Cupertino components without
/// requiring the full [BringlyApp] / router setup.
Future<void> pumpBringlyWidget(
  WidgetTester tester,
  Widget widget, {
  Size surfaceSize = const Size(390, 844),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  await tester.pumpWidget(
    CupertinoApp(theme: BringlyTheme.lightTheme(), home: widget),
  );
}
