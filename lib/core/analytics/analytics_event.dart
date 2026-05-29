enum AnalyticsEventName {
  appLaunched,
  configurationViewed,
  connectivityChecked,
  storageSmokeTested,
  uiStateViewed,
}

class AnalyticsEvent {
  const AnalyticsEvent({
    required this.name,
    this.metadata = const <String, Object?>{},
  });

  final AnalyticsEventName name;
  final Map<String, Object?> metadata;
}
