import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';

/// A Cupertino-styled button with normal, loading, disabled, and error states.
class BringlyButton extends StatelessWidget {
  const BringlyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isError = false,
    this.onPressedFallback,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isError;

  /// Called when the button is tapped while [onPressed] is null but not in
  /// loading state — used only to verify disabled behavior in tests.
  final VoidCallback? onPressedFallback;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null && !isLoading;
    final backgroundColor = isError
        ? BringlyColors.danger
        : isDisabled
        ? BringlyColors.disabled
        : BringlyColors.accent;

    return CupertinoButton(
      key: key,
      onPressed: isDisabled ? null : (isLoading ? null : onPressed),
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 50),
      pressedOpacity: 0.88,
      borderRadius: BorderRadius.circular(BringlyRadii.pill),
      color: backgroundColor,
      disabledColor: BringlyColors.disabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BringlyRadii.pill),
          boxShadow: isDisabled
              ? const <BoxShadow>[]
              : <BoxShadow>[
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: 0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BringlySpacing.ml,
            vertical: 14,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CupertinoActivityIndicator(color: CupertinoColors.white)
              else
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: BringlyTheme.labelStyle(context).copyWith(
                      color: isDisabled
                          ? BringlyColors.mutedInk
                          : BringlyColors.card,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
