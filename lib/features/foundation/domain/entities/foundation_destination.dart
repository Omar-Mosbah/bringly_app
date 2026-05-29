enum FoundationDestinationId {
  startup,
  configurationStatus,
  connectivity,
  uiStateDemo,
}

class FoundationDestination {
  const FoundationDestination({
    required this.id,
    required this.title,
    required this.routePath,
    this.isAccessible = true,
    this.blockedReason,
  });

  final FoundationDestinationId id;
  final String title;
  final String routePath;
  final bool isAccessible;
  final String? blockedReason;

  static const List<FoundationDestination> all = <FoundationDestination>[
    FoundationDestination(
      id: FoundationDestinationId.startup,
      title: 'Startup',
      routePath: '/',
    ),
    FoundationDestination(
      id: FoundationDestinationId.configurationStatus,
      title: 'Configuration',
      routePath: '/config',
    ),
    FoundationDestination(
      id: FoundationDestinationId.connectivity,
      title: 'Connectivity',
      routePath: '/connectivity',
    ),
    FoundationDestination(
      id: FoundationDestinationId.uiStateDemo,
      title: 'UI States',
      routePath: '/ui-states',
    ),
  ];

  static FoundationDestination byId(FoundationDestinationId id) {
    return all.firstWhere((destination) => destination.id == id);
  }
}
