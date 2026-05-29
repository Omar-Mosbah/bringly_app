import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A fake evidence tile for UI demonstration only.
///
/// Must not contain real document, receipt, file, travel proof, or metadata.
/// Must not upload, download, persist, or preview sensitive files.
class EvidenceTile extends StatelessWidget {
  const EvidenceTile({super.key, required this.label, this.subtitle});

  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BringlyColors.card.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(BringlyRadii.sm),
        border: Border.all(color: BringlyColors.frostedBorder, width: 0.9),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(BringlySpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: BringlyColors.tertiaryFill,
              borderRadius: BorderRadius.circular(BringlyRadii.xs),
            ),
            child: const Icon(
              CupertinoIcons.doc,
              size: 18,
              color: BringlyColors.accent,
            ),
          ),
          const SizedBox(width: BringlySpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: BringlyTheme.compactLabelStyle(
                    context,
                  ).copyWith(color: BringlyColors.ink),
                ),
                if (subtitle != null)
                  Text(subtitle!, style: BringlyTheme.captionStyle(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
