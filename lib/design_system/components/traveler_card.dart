import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A fake marketplace traveler summary card.
///
/// Uses safe placeholder content only. Must not reveal real identity, travel
/// proof, contact details, match eligibility, or offer state.
class TravelerCard extends StatelessWidget {
  const TravelerCard({
    super.key,
    required this.displayName,
    required this.route,
    required this.travelDate,
  });

  final String displayName;
  final String route;
  final String travelDate;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: BringlyColors.tertiaryFill,
              borderRadius: BorderRadius.circular(BringlyRadii.lg),
            ),
            child: const Icon(
              CupertinoIcons.airplane,
              size: 22,
              color: BringlyColors.accent,
            ),
          ),
          const SizedBox(width: BringlySpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: BringlyTheme.compactLabelStyle(
                    context,
                  ).copyWith(color: BringlyColors.ink),
                ),
                const SizedBox(height: BringlySpacing.xxs),
                Text(
                  route,
                  style: BringlyTheme.captionStyle(
                    context,
                  ).copyWith(color: BringlyColors.ink),
                ),
                const SizedBox(height: BringlySpacing.xxs),
                Text(travelDate, style: BringlyTheme.captionStyle(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
