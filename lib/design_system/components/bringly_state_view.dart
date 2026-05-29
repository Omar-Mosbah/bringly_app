import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/components/component_state.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A reusable state screen for loading, empty, blocked, and error states.
///
/// Wording must be actionable and safe without exposing backend internals.
class BringlyStateView extends StatelessWidget {
  const BringlyStateView({
    super.key,
    required this.componentState,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final ComponentState componentState;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BringlySpacing.lg),
      decoration: BoxDecoration(
        color: BringlyColors.card.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(BringlyRadii.md),
        border: Border.all(color: BringlyColors.frostedBorder, width: 0.9),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (componentState == ComponentState.loading)
            const CupertinoActivityIndicator()
          else
            Icon(_icon, color: componentState.color, size: 32),
          const SizedBox(height: BringlySpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: BringlyTheme.compactLabelStyle(
              context,
            ).copyWith(fontSize: 20, color: BringlyColors.ink),
          ),
          const SizedBox(height: BringlySpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: BringlyTheme.captionStyle(context),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: BringlySpacing.md),
            CupertinoButton.filled(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }

  IconData get _icon => switch (componentState) {
    ComponentState.loading => CupertinoIcons.circle,
    ComponentState.empty => CupertinoIcons.tray,
    ComponentState.blocked => CupertinoIcons.lock,
    ComponentState.error => CupertinoIcons.exclamationmark_circle,
    ComponentState.success => CupertinoIcons.checkmark_circle,
    ComponentState.warning => CupertinoIcons.exclamationmark_triangle,
    _ => CupertinoIcons.info_circle,
  };
}
