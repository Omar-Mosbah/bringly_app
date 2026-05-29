import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A labelled Cupertino text field with helper, error, and disabled states.
///
/// Does not log or store entered values.
class BringlyTextField extends StatelessWidget {
  const BringlyTextField({
    super.key,
    required this.label,
    this.controller,
    this.helperText,
    this.errorText,
    this.isError = false,
    this.isDisabled = false,
    this.placeholder,
  });

  final String label;
  final TextEditingController? controller;
  final String? helperText;
  final String? errorText;
  final bool isError;
  final bool isDisabled;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final borderColor = isError ? BringlyColors.danger : BringlyColors.border;
    final fillColor = isDisabled
        ? BringlyColors.disabled.withValues(alpha: 0.65)
        : BringlyColors.card.withValues(alpha: 0.88);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: BringlyTheme.compactLabelStyle(context).copyWith(
            color: isDisabled ? BringlyColors.mutedInk : BringlyColors.ink,
          ),
        ),
        const SizedBox(height: BringlySpacing.xs),
        DecoratedBox(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(BringlyRadii.sm),
            border: Border.all(color: borderColor, width: isError ? 1.5 : 0.8),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: BringlyColors.overlay.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: CupertinoTextField(
            controller: controller,
            enabled: !isDisabled,
            placeholder: placeholder,
            placeholderStyle: BringlyTheme.captionStyle(
              context,
            ).copyWith(color: BringlyColors.mutedInk.withValues(alpha: 0.75)),
            style: BringlyTheme.bodyStyle(context),
            decoration: const BoxDecoration(color: CupertinoColors.transparent),
            padding: const EdgeInsets.symmetric(
              horizontal: BringlySpacing.md,
              vertical: BringlySpacing.sm,
            ),
          ),
        ),
        if (isError && errorText != null) ...[
          const SizedBox(height: BringlySpacing.xs),
          Text(
            errorText!,
            style: BringlyTheme.captionStyle(
              context,
            ).copyWith(color: BringlyColors.danger),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: BringlySpacing.xs),
          Text(helperText!, style: BringlyTheme.captionStyle(context)),
        ],
      ],
    );
  }
}
