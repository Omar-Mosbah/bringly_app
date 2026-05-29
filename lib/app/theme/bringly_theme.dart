import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';

abstract final class BringlyTheme {
  static CupertinoThemeData lightTheme() {
    return const CupertinoThemeData(
      primaryColor: BringlyColors.accent,
      scaffoldBackgroundColor: BringlyColors.surface,
      barBackgroundColor: BringlyColors.frostedSurface,
      textTheme: CupertinoTextThemeData(
        primaryColor: BringlyColors.ink,
        textStyle: TextStyle(
          color: BringlyColors.ink,
          fontSize: 17,
          height: 1.29,
          letterSpacing: -0.41,
        ),
        navTitleTextStyle: TextStyle(
          color: BringlyColors.ink,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          height: 1.29,
          letterSpacing: -0.41,
        ),
        navLargeTitleTextStyle: TextStyle(
          color: BringlyColors.ink,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          height: 1.12,
          letterSpacing: 0.37,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Typography helpers for Phase 1 components
  // ---------------------------------------------------------------------------

  /// Large title used on placeholder screens and demo section headers.
  static TextStyle largeTitleStyle(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.copyWith(
      color: BringlyColors.ink,
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.12,
      letterSpacing: 0.37,
    );
  }

  /// Heading used inside cards and section titles.
  static TextStyle headingStyle(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
      color: BringlyColors.ink,
      fontSize: 28,
      height: 1.21,
      letterSpacing: -0.4,
      fontWeight: FontWeight.w600,
    );
  }

  /// Standard body text.
  static TextStyle bodyStyle(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      color: BringlyColors.ink,
      fontSize: 17,
      height: 1.29,
      letterSpacing: -0.41,
    );
  }

  /// Muted/secondary body text used for descriptions and helper copy.
  static TextStyle captionStyle(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      color: BringlyColors.mutedInk,
      fontSize: 15,
      height: 1.33,
      letterSpacing: -0.24,
    );
  }

  /// Label style used on buttons and chips.
  static TextStyle labelStyle(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      color: BringlyColors.card,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.29,
      letterSpacing: -0.43,
    );
  }

  /// Secondary pill/button labels and compact metadata.
  static TextStyle compactLabelStyle(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      color: BringlyColors.ink,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.33,
      letterSpacing: -0.24,
    );
  }

  /// Tiny captions used in tab bars and badges.
  static TextStyle microLabelStyle(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.textStyle.copyWith(
      color: BringlyColors.mutedInk,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.1,
    );
  }
}
