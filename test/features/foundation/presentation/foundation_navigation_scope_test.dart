import 'package:bringly_app/features/foundation/domain/entities/foundation_destination.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('marketplace destinations are absent from foundation navigation', () {
    final labels = FoundationDestination.all
        .map((item) => item.title)
        .join(' ');

    expect(labels, isNot(contains('Shopper')));
    expect(labels, isNot(contains('Traveler')));
    expect(labels, isNot(contains('Profile')));
    expect(labels, isNot(contains('Payment')));
    expect(labels, isNot(contains('Notification')));
  });
}
