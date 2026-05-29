import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';

enum ChipStatus { success, error, warning, blocked, pending }

/// A compact status chip with a label and color-coded status.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, required this.label});

  final ChipStatus status;
  final String label;

  Color get _color => switch (status) {
    ChipStatus.success => BringlyColors.success,
    ChipStatus.error => BringlyColors.danger,
    ChipStatus.warning => BringlyColors.warning,
    ChipStatus.blocked => BringlyColors.blocked,
    ChipStatus.pending => BringlyColors.pending,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BringlySpacing.sm,
        vertical: BringlySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(BringlyRadii.pill),
        border: Border.all(color: _color.withValues(alpha: 0.18), width: 0.8),
      ),
      child: Text(
        label,
        style: BringlyTheme.compactLabelStyle(context).copyWith(color: _color),
      ),
    );
  }
}
