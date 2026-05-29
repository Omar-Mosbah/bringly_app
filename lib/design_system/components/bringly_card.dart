import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';

/// A Cupertino-styled card container with optional tap affordance and status slot.
class BringlyCard extends StatelessWidget {
  const BringlyCard({
    super.key,
    required this.child,
    this.onTap,
    this.isDisabled = false,
    this.statusSlot,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool isDisabled;
  final Widget? statusSlot;

  @override
  Widget build(BuildContext context) {
    final canTap = onTap != null && !isDisabled;
    return Opacity(
      opacity: isDisabled ? 0.78 : 1,
      child: GestureDetector(
        onTap: canTap ? onTap : null,
        child: Container(
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
              BoxShadow(
                color: Color(0x10FFFFFF),
                blurRadius: 0,
                offset: Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(BringlySpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (statusSlot != null) ...[
                statusSlot!,
                const SizedBox(height: BringlySpacing.sm),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
