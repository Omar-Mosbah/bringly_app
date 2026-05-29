import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';

abstract final class BringlyTheme {
  static CupertinoThemeData lightTheme() {
    return const CupertinoThemeData(
      primaryColor: BringlyColors.accent,
      scaffoldBackgroundColor: BringlyColors.surface,
      barBackgroundColor: BringlyColors.surface,
      textTheme: CupertinoTextThemeData(primaryColor: BringlyColors.ink),
    );
  }
}
