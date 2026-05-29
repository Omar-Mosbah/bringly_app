import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A fake marketplace request card.
///
/// Uses safe placeholder content only. Must not imply request approval,
/// match eligibility, or offer state.
class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.itemDescription,
    required this.destination,
    required this.reward,
  });

  final String itemDescription;
  final String destination;
  final String reward;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(BringlySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: BringlySpacing.sm,
              vertical: BringlySpacing.xs,
            ),
            decoration: BoxDecoration(
              color: BringlyColors.tertiaryFill,
              borderRadius: BorderRadius.circular(BringlyRadii.pill),
            ),
            child: Text(
              'Request',
              style: BringlyTheme.compactLabelStyle(
                context,
              ).copyWith(color: BringlyColors.accent),
            ),
          ),
          const SizedBox(height: BringlySpacing.sm),
          Text(
            itemDescription,
            style: BringlyTheme.compactLabelStyle(
              context,
            ).copyWith(fontSize: 20, color: BringlyColors.ink),
          ),
          const SizedBox(height: BringlySpacing.xs),
          Row(
            children: [
              const Icon(
                CupertinoIcons.location,
                size: 14,
                color: BringlyColors.mutedInk,
              ),
              const SizedBox(width: BringlySpacing.xs),
              Text(destination, style: BringlyTheme.captionStyle(context)),
            ],
          ),
          const SizedBox(height: BringlySpacing.sm),
          Container(
            height: 0.8,
            color: BringlyColors.border.withValues(alpha: 0.7),
          ),
          const SizedBox(height: BringlySpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reward', style: BringlyTheme.captionStyle(context)),
              Text(
                reward,
                style: BringlyTheme.compactLabelStyle(
                  context,
                ).copyWith(color: BringlyColors.accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
