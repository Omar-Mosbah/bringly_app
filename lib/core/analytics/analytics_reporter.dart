import 'package:bringly_app/core/analytics/analytics_event.dart';

abstract class AnalyticsReporter {
  const AnalyticsReporter();

  void report(AnalyticsEvent event);
}
