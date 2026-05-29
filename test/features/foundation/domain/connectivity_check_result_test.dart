import 'package:bringly_app/features/foundation/domain/entities/connectivity_check_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('connectivity result exposes allowed statuses and retry rules', () {
    const result = ConnectivityCheckResult(
      status: ConnectivityCheckStatus.timeout,
      safeMessage: 'Timed out safely.',
    );

    expect(ConnectivityCheckStatus.values, hasLength(8));
    expect(result.retryAllowed, isTrue);
    expect(result.safeMessage, 'Timed out safely.');
  });
}
