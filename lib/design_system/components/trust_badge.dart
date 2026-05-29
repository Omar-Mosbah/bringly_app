import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

enum TrustBadgeStatus { reviewed, pending, notStarted }

/// A trust / identity verification badge.
///
/// Labels must not imply real approval, payment, delivery, dispute, or payout.
class TrustBadge extends StatelessWidget {
  const TrustBadge({super.key, required this.status});

  final TrustBadgeStatus status;

  String get _label => switch (status) {
    TrustBadgeStatus.reviewed => 'Demo reviewed',
    TrustBadgeStatus.pending => 'Pending',
    TrustBadgeStatus.notStarted => 'Not started',
  };

  Color get _color => switch (status) {
    TrustBadgeStatus.reviewed => BringlyColors.success,
    TrustBadgeStatus.pending => BringlyColors.pending,
    TrustBadgeStatus.notStarted => BringlyColors.mutedInk,
  };

  IconData get _icon => switch (status) {
    TrustBadgeStatus.reviewed => CupertinoIcons.checkmark_seal_fill,
    TrustBadgeStatus.pending => CupertinoIcons.time_solid,
    TrustBadgeStatus.notStarted => CupertinoIcons.circle,
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
        border: Border.all(color: _color.withValues(alpha: 0.16), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _color),
          const SizedBox(width: BringlySpacing.xs),
          Text(
            _label,
            style: BringlyTheme.compactLabelStyle(
              context,
            ).copyWith(color: _color),
          ),
        ],
      ),
    );
  }
}
