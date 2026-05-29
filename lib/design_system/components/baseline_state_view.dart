import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/foundation/domain/entities/baseline_ui_state.dart';
import 'package:flutter/cupertino.dart';

class BaselineStateView extends StatelessWidget {
  const BaselineStateView({
    required this.state,
    this.onPrimaryAction,
    super.key,
  });

  final BaselineUiState state;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BringlySpacing.lg),
      decoration: BoxDecoration(
        color: BringlyColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            _iconForState(state.kind),
            color: _colorForState(state.kind),
            size: 32,
          ),
          const SizedBox(height: BringlySpacing.md),
          Text(
            state.title,
            textAlign: TextAlign.center,
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
          const SizedBox(height: BringlySpacing.xs),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: CupertinoTheme.of(
              context,
            ).textTheme.textStyle.copyWith(color: BringlyColors.mutedInk),
          ),
          if (state.primaryAction != null &&
              onPrimaryAction != null) ...<Widget>[
            const SizedBox(height: BringlySpacing.md),
            CupertinoButton.filled(
              onPressed: onPrimaryAction,
              child: Text(state.primaryAction!),
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconForState(BaselineUiStateKind kind) {
    return switch (kind) {
      BaselineUiStateKind.loading => CupertinoIcons.time,
      BaselineUiStateKind.empty => CupertinoIcons.tray,
      BaselineUiStateKind.error => CupertinoIcons.exclamationmark_triangle,
      BaselineUiStateKind.blocked => CupertinoIcons.lock_shield,
      BaselineUiStateKind.offline => CupertinoIcons.wifi_slash,
      BaselineUiStateKind.success => CupertinoIcons.check_mark_circled_solid,
    };
  }

  Color _colorForState(BaselineUiStateKind kind) {
    return switch (kind) {
      BaselineUiStateKind.loading => BringlyColors.accent,
      BaselineUiStateKind.empty => BringlyColors.mutedInk,
      BaselineUiStateKind.error => BringlyColors.danger,
      BaselineUiStateKind.blocked => BringlyColors.blocked,
      BaselineUiStateKind.offline => BringlyColors.offline,
      BaselineUiStateKind.success => BringlyColors.success,
    };
  }
}
