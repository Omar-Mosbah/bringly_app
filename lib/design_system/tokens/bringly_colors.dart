import 'package:flutter/cupertino.dart';

abstract final class BringlyColors {
  // --- Core surface & ink ---
  static const Color surface = Color(0xFFF4F0FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF17151B);
  static const Color mutedInk = Color(0xFF6E6877);

  // --- Brand accent ---
  static const Color accent = Color(0xFF0A84FF);
  static const Color accentSecondary = Color(0xFF0F766E);
  static const Color accentMuted = Color(0x1F0A84FF);

  // --- Status palette ---
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color danger = Color(0xFFFF3B30);
  static const Color blocked = Color(0xFF8E3B46);
  static const Color offline = Color(0xFF2B6CB0);
  static const Color pending = Color(0xFFFF9F0A);

  // --- Component tokens (Phase 1) ---
  /// Background for disabled controls and tiles.
  static const Color disabled = Color(0xFFE8E2EF);

  /// Subtle border used on cards and input fields.
  static const Color border = Color(0xFFD9D2E3);

  /// Secondary fill used for inactive pills and tabs.
  static const Color tertiaryFill = Color(0x1F767680);

  /// Frosted and elevated surface colors inspired by the Figma iOS kit.
  static const Color frostedSurface = Color(0xEFFFFFFF);
  static const Color frostedBorder = Color(0xB8FFFFFF);
  static const Color overlay = Color(0x29000000);

  /// Selected/active tab bar tint.
  static const Color tabBarActive = accent;

  /// Unselected tab bar icon colour.
  static const Color tabBarInactive = Color(0xFF3F3A47);

  /// Background overlay for loading shimmer.
  static const Color shimmerBase = Color(0xFFEAE3F4);
  static const Color shimmerHighlight = Color(0xFFF7F4FB);
}
