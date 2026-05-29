import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_local_app_unlock.dart';

void main() {
  test('fake local unlock exposes configured availability and request result', () async {
    final unlock = FakeLocalAppUnlock(
      availability: const LocalAppUnlockStatus(
        availability: LocalAppUnlockAvailability.availableDevicePin,
        method: LocalAppUnlockMethod.devicePin,
      ),
      nextResult: LocalAppUnlockResult.cancelled,
    );

    final availability = await unlock.checkAvailability();
    final result = await unlock.requestUnlock(reason: 'Unlock Bringly');

    expect(availability.availability, LocalAppUnlockAvailability.availableDevicePin);
    expect(availability.isAvailable, isTrue);
    expect(result, LocalAppUnlockResult.cancelled);
    expect(unlock.requestCallCount, 1);
  });

  test('fake local unlock tracks reset calls', () async {
    final unlock = FakeLocalAppUnlock();

    await unlock.reset();
    await unlock.reset();

    expect(unlock.resetCallCount, 2);
  });
}