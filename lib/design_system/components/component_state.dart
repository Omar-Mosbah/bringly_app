import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';

/// The visible state of a reusable design system component or state screen.
enum ComponentState {
  normal,
  loading,
  disabled,
  error,
  empty,
  blocked,
  pending,
  success,
  warning;

  /// Human-readable display label for this state.
  String get displayLabel {
    return switch (this) {
      ComponentState.normal => 'Normal',
      ComponentState.loading => 'Loading',
      ComponentState.disabled => 'Disabled',
      ComponentState.error => 'Error',
      ComponentState.empty => 'Empty',
      ComponentState.blocked => 'Unavailable',
      ComponentState.pending => 'Pending',
      ComponentState.success => 'Done',
      ComponentState.warning => 'Warning',
    };
  }

  /// Semantic color associated with this state for iconography and borders.
  Color get color {
    return switch (this) {
      ComponentState.normal => BringlyColors.ink,
      ComponentState.loading => BringlyColors.accent,
      ComponentState.disabled => BringlyColors.mutedInk,
      ComponentState.error => BringlyColors.danger,
      ComponentState.empty => BringlyColors.mutedInk,
      ComponentState.blocked => BringlyColors.blocked,
      ComponentState.pending => BringlyColors.warning,
      ComponentState.success => BringlyColors.success,
      ComponentState.warning => BringlyColors.warning,
    };
  }

  /// Whether the component or screen is interactive in this state.
  bool get isInteractive {
    return switch (this) {
      ComponentState.normal ||
      ComponentState.pending ||
      ComponentState.warning ||
      ComponentState.success => true,
      ComponentState.loading ||
      ComponentState.disabled ||
      ComponentState.error ||
      ComponentState.empty ||
      ComponentState.blocked => false,
    };
  }
}
