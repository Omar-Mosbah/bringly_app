import 'package:bringly_app/core/errors/app_failure.dart';

class MarketplaceScopeGuard {
  const MarketplaceScopeGuard();

  static const Set<String> unavailableActions = <String>{
    'approval',
    'verification',
    'matching',
    'offers',
    'payment',
    'payments',
    'evidence',
    'delivery',
    'dispute',
    'rating',
    'ratings',
    'notification',
    'notifications',
    'support',
    'payout',
    'auth',
    'session',
    'profile_editing',
  };

  bool isAvailable(String action) => !unavailableActions.contains(action);

  AppFailure reject(String action) {
    return AppFailure(
      code: AppFailureCode.blockedScope,
      message: 'Phase 0 does not expose $action actions.',
    );
  }
}
