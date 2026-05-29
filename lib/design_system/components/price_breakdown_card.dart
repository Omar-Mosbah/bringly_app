import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A fake price line item for display purposes only.
///
/// Must not represent real payment authorization, escrow, payout, refund,
/// card, or provider state.
class PriceLineItem {
  const PriceLineItem({required this.label, required this.amount});

  final String label;
  final String amount;
}

/// Displays a breakdown of price line items and a total.
///
/// For formatting demonstration only; no real payment data.
class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({
    super.key,
    required this.lineItems,
    required this.total,
  });

  final List<PriceLineItem> lineItems;
  final String total;

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
          Text(
            'Estimate',
            style: BringlyTheme.compactLabelStyle(
              context,
            ).copyWith(color: BringlyColors.mutedInk),
          ),
          const SizedBox(height: BringlySpacing.sm),
          for (final item in lineItems)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: BringlySpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.label, style: BringlyTheme.captionStyle(context)),
                  Text(
                    item.amount,
                    style: BringlyTheme.compactLabelStyle(
                      context,
                    ).copyWith(color: BringlyColors.ink),
                  ),
                ],
              ),
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
              Text(
                'Total',
                style: BringlyTheme.compactLabelStyle(
                  context,
                ).copyWith(color: BringlyColors.ink),
              ),
              Text(
                total,
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
