import 'package:bringly_app/core/errors/app_failure.dart';
import 'package:bringly_app/features/foundation/application/marketplace_scope_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phase 0 marketplace actions remain unavailable', () {
    const guard = MarketplaceScopeGuard();

    const expectedBlockedActions = <String>{
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

    expect(
      MarketplaceScopeGuard.unavailableActions,
      containsAll(expectedBlockedActions),
    );

    for (final action in expectedBlockedActions) {
      expect(guard.isAvailable(action), isFalse);
      expect(guard.reject(action).code, AppFailureCode.blockedScope);
    }

    expect(guard.isAvailable('shopper'), isTrue);
    expect(guard.isAvailable('traveler'), isTrue);
    expect(guard.isAvailable('activity'), isTrue);
    expect(guard.isAvailable('profile'), isTrue);
  });
}
