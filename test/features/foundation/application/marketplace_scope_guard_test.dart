import 'package:bringly_app/core/errors/app_failure.dart';
import 'package:bringly_app/features/foundation/application/marketplace_scope_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phase 0 marketplace actions remain unavailable', () {
    const guard = MarketplaceScopeGuard();

    for (final action in MarketplaceScopeGuard.unavailableActions) {
      expect(guard.isAvailable(action), isFalse);
      expect(guard.reject(action).code, AppFailureCode.blockedScope);
    }
  });
}
