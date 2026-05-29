import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A non-authoritative verification status banner for UI demonstration only.
///
/// Must not claim that a user, trip, item, payment, or payout is truly
/// verified or approved.
class VerificationStatusBanner extends StatelessWidget {
  const VerificationStatusBanner({
    super.key,
    required this.message,
    this.isPositive = false,
  });

  final String message;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? BringlyColors.success : BringlyColors.warning;
    final icon = isPositive
        ? CupertinoIcons.checkmark_shield
        : CupertinoIcons.exclamationmark_shield;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: BringlySpacing.md,
        vertical: BringlySpacing.sm,
      ),
      decoration: BoxDecoration(
        color: BringlyColors.card.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(BringlyRadii.sm),
        border: Border.all(color: color.withValues(alpha: 0.18), width: 0.9),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: BringlySpacing.sm),
          Expanded(
            child: Text(
              message,
              style: BringlyTheme.captionStyle(context).copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
