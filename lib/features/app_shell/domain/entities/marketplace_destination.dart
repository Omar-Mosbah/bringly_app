import 'package:bringly_app/features/app_shell/domain/entities/placeholder_message.dart';
import 'package:flutter/cupertino.dart';

/// The four primary destinations in the marketplace shell.
/// No destination other than these four may appear as a primary tab.
enum MarketplaceDestinationId { shopper, traveler, activity, profile }

/// A primary destination in the Bringly marketplace shell.
class MarketplaceDestination {
  const MarketplaceDestination({
    required this.id,
    required this.label,
    required this.icon,
    required this.routePath,
    required this.placeholder,
  });

  final MarketplaceDestinationId id;

  /// Safe tab label — must not imply auth, verification, payment, delivery,
  /// disputes, ratings, or notifications are implemented.
  final String label;

  /// Cupertino icon used for the tab bar item.
  final IconData icon;

  /// Route path registered in [createAppRouter].
  final String routePath;

  /// Safe placeholder content shown in Phase 1.
  final PlaceholderMessage placeholder;

  /// The four and only four allowed primary destinations in Phase 1.
  static const List<MarketplaceDestination> all = <MarketplaceDestination>[
    MarketplaceDestination(
      id: MarketplaceDestinationId.shopper,
      label: 'Shop',
      icon: CupertinoIcons.bag,
      routePath: '/shopper',
      placeholder: PlaceholderMessage(
        title: 'Browse the marketplace',
        message:
            'Shopper features are coming soon. You will be able to request '
            'items from travelers here.',
      ),
    ),
    MarketplaceDestination(
      id: MarketplaceDestinationId.traveler,
      label: 'Travel',
      icon: CupertinoIcons.airplane,
      routePath: '/traveler',
      placeholder: PlaceholderMessage(
        title: 'Plan your trips',
        message:
            'Traveler features are coming soon. You will be able to share '
            'your travel plans and connect with shoppers here.',
      ),
    ),
    MarketplaceDestination(
      id: MarketplaceDestinationId.activity,
      label: 'Activity',
      icon: CupertinoIcons.list_bullet,
      routePath: '/activity',
      placeholder: PlaceholderMessage(
        title: 'Track your activity',
        message:
            'Activity tracking is coming soon. Your request and trip '
            'updates will appear here.',
      ),
    ),
    MarketplaceDestination(
      id: MarketplaceDestinationId.profile,
      label: 'Profile',
      icon: CupertinoIcons.person,
      routePath: '/profile',
      placeholder: PlaceholderMessage(
        title: 'Your profile',
        message: 'Profile and account features are coming soon.',
      ),
    ),
  ];

  /// Returns the destination matching [id] from [all].
  static MarketplaceDestination byId(MarketplaceDestinationId id) {
    return all.firstWhere((d) => d.id == id);
  }
}
