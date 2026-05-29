import 'package:bringly_app/design_system/layouts/marketplace_shell_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:flutter/cupertino.dart';

/// Phase 1 placeholder screen for the Profile primary tab.
///
/// Shows safe copy about upcoming profile and account features.
/// Provides a discoverable entry point to the Design System Demo route.
/// No backend calls, no storage writes, no analytics events, no auth actions.
class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({this.onDesignSystemDemo, super.key});

  /// Called when the user taps the Design System Demo button.
  /// The shell or router will provide this callback to navigate to `/design-system`.
  final VoidCallback? onDesignSystemDemo;

  @override
  Widget build(BuildContext context) {
    final destination = MarketplaceDestination.byId(
      MarketplaceDestinationId.profile,
    );
    return MarketplaceShellScaffold(
      title: destination.label,
      body: _ProfileBody(
        destination: destination,
        onDesignSystemDemo: onDesignSystemDemo,
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.destination,
    required this.onDesignSystemDemo,
  });

  final MarketplaceDestination destination;
  final VoidCallback? onDesignSystemDemo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BringlySpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(destination.icon, size: 56, color: BringlyColors.accent),
            const SizedBox(height: BringlySpacing.lg),
            Text(
              destination.placeholder.title,
              key: const ValueKey<String>('placeholder_title'),
              textAlign: TextAlign.center,
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle
                  .copyWith(
                    color: BringlyColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: BringlySpacing.sm),
            Text(
              destination.placeholder.message,
              key: const ValueKey<String>('placeholder_message'),
              textAlign: TextAlign.center,
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                color: BringlyColors.mutedInk,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: BringlySpacing.xl),
            // Design System Demo entry point — visible to testers and developers.
            CupertinoButton(
              key: const ValueKey<String>('design_system_demo_button'),
              onPressed: onDesignSystemDemo,
              child: const Text('View Design System'),
            ),
          ],
        ),
      ),
    );
  }
}
