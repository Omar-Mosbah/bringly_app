import 'package:bringly_app/design_system/layouts/marketplace_shell_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:flutter/cupertino.dart';

/// Phase 1 placeholder screen for the Traveler primary tab.
///
/// Shows safe copy about upcoming traveler features.
/// No backend calls, no storage writes, no analytics events.
class TravelerPlaceholderScreen extends StatelessWidget {
  const TravelerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destination = MarketplaceDestination.byId(
      MarketplaceDestinationId.traveler,
    );
    return MarketplaceShellScaffold(
      title: destination.label,
      body: _PlaceholderBody(destination: destination),
    );
  }
}

class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody({required this.destination});

  final MarketplaceDestination destination;

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
          ],
        ),
      ),
    );
  }
}
