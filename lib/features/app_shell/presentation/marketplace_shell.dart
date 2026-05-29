import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:bringly_app/features/app_shell/presentation/activity_placeholder_screen.dart';
import 'package:bringly_app/features/app_shell/presentation/shopper_placeholder_screen.dart';
import 'package:bringly_app/features/app_shell/presentation/traveler_placeholder_screen.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/presentation/profile_summary_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// The Phase 1 four-tab Cupertino marketplace shell.
///
/// Renders [MarketplaceDestination.all] as primary tabs. Each tab shows a safe
/// placeholder screen with no marketplace business logic.
///
/// Navigation rules:
/// - Tapping a tab navigates to that destination's [routePath] via go_router.
/// - The Design System Demo is reachable from the Profile tab via a callback.
/// - Rapid tab switching must preserve the shell without layout overlap.
class MarketplaceShell extends StatelessWidget {
  const MarketplaceShell({
    required this.activeDestinationId,
    this.profileController,
    this.authController,
    this.onEditProfile,
    this.onChangeRole,
    this.onSignOut,
    this.onDesignSystemDemo,
    super.key,
  });

  /// The currently active primary tab.
  final MarketplaceDestinationId activeDestinationId;
  final ProfileController? profileController;
  final AuthController? authController;
  final VoidCallback? onEditProfile;
  final VoidCallback? onChangeRole;
  final VoidCallback? onSignOut;
  final VoidCallback? onDesignSystemDemo;

  @override
  Widget build(BuildContext context) {
    final destinations = MarketplaceDestination.all;
    final activeIndex = destinations.indexWhere(
      (d) => d.id == activeDestinationId,
    );

    return CupertinoTabScaffold(
      key: const ValueKey<String>('marketplace_tab_scaffold'),
      tabBar: CupertinoTabBar(
        key: const ValueKey<String>('marketplace_tab_bar'),
        backgroundColor: BringlyColors.frostedSurface,
        activeColor: BringlyColors.tabBarActive,
        inactiveColor: BringlyColors.tabBarInactive,
        border: Border(
          top: BorderSide(
            color: BringlyColors.border.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        currentIndex: activeIndex < 0 ? 0 : activeIndex,
        onTap: (index) => context.go(destinations[index].routePath),
        items: destinations
            .map(
              (d) => BottomNavigationBarItem(
                icon: Icon(d.icon, size: 22),
                activeIcon: DecoratedBox(
                  decoration: BoxDecoration(
                    color: BringlyColors.accentMuted,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Icon(d.icon, size: 22),
                  ),
                ),
                label: d.label,
              ),
            )
            .toList(growable: false),
      ),
      tabBuilder: (context, index) =>
          _buildScreen(context, destinations[index]),
    );
  }

  Widget _buildScreen(
    BuildContext context,
    MarketplaceDestination destination,
  ) {
    return switch (destination.id) {
      MarketplaceDestinationId.shopper => const ShopperPlaceholderScreen(),
      MarketplaceDestinationId.traveler => const TravelerPlaceholderScreen(),
      MarketplaceDestinationId.activity => const ActivityPlaceholderScreen(),
      MarketplaceDestinationId.profile => ProfileSummaryScreen(
        controller: profileController!,
        authController: authController,
        onEditProfile: onEditProfile,
        onChangeRole: onChangeRole,
        onDesignSystemDemo: onDesignSystemDemo,
        onSignedOut: onSignOut,
      ),
    };
  }
}
