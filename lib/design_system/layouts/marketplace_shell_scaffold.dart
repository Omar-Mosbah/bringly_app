import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

/// A shared scaffold for marketplace destination placeholder screens.
///
/// Provides a [CupertinoNavigationBar]-headed page layout with a safe area
/// and stable content constraints so components render consistently across
/// compact and standard mobile viewports.
///
/// Rules:
/// - No nested-card page sections — content is wrapped in a single scrollable
///   body without stacked opaque card shells.
/// - The layout must remain usable with increased text scaling.
/// - No backend calls, storage writes, analytics events, or logging.
class MarketplaceShellScaffold extends StatelessWidget {
  const MarketplaceShellScaffold({
    required this.title,
    required this.body,
    this.trailing,
    super.key,
  });

  /// Navigation bar title.
  final String title;

  /// Main content placed inside a safe-area-constrained scrollable region.
  final Widget body;

  /// Optional trailing widget in the navigation bar (e.g. an icon button).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: BringlyColors.surface,
      navigationBar: CupertinoNavigationBar(
        key: const ValueKey<String>('marketplace_nav_bar'),
        backgroundColor: BringlyColors.frostedSurface,
        automaticBackgroundVisibility: false,
        border: Border(
          bottom: BorderSide(
            color: BringlyColors.border.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        middle: Text(title, style: BringlyTheme.compactLabelStyle(context)),
        trailing: trailing,
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: BringlySpacing.md,
                vertical: BringlySpacing.sm,
              ),
              sliver: SliverToBoxAdapter(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(BringlyRadii.lg),
                  ),
                  child: body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
