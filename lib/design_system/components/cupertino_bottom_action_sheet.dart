import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:flutter/cupertino.dart';

/// A data class for an action in [BringlyCupertinoActionSheet].
class BringlyActionSheetAction {
  const BringlyActionSheetAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;
}

/// Helper that presents a [CupertinoActionSheet] with typed action data.
///
/// Demo actions are local only and must not mutate marketplace state.
class BringlyCupertinoActionSheet extends StatelessWidget {
  const BringlyCupertinoActionSheet({
    super.key,
    this.title,
    this.message,
    required this.actions,
    this.onCancel,
  });

  final String? title;
  final String? message;
  final List<BringlyActionSheetAction> actions;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: title != null
          ? Text(
              title!,
              style: BringlyTheme.compactLabelStyle(
                context,
              ).copyWith(color: BringlyColors.ink),
            )
          : null,
      message: message != null
          ? Text(message!, style: BringlyTheme.captionStyle(context))
          : null,
      actions: actions
          .map(
            (a) => CupertinoActionSheetAction(
              onPressed: a.onPressed,
              isDestructiveAction: a.isDestructive,
              child: Text(
                a.label,
                style: BringlyTheme.compactLabelStyle(context).copyWith(
                  color: a.isDestructive
                      ? BringlyColors.danger
                      : BringlyColors.accent,
                ),
              ),
            ),
          )
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: onCancel ?? () {},
        child: Text(
          'Cancel',
          style: BringlyTheme.compactLabelStyle(
            context,
          ).copyWith(color: BringlyColors.ink),
        ),
      ),
    );
  }
}
