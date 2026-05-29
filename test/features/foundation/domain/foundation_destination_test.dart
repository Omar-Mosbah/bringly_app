import 'package:bringly_app/features/foundation/domain/entities/foundation_destination.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only Phase 0 destinations are available', () {
    final routes = FoundationDestination.all
        .map((item) => item.routePath)
        .toList();

    expect(
      routes,
      equals(const <String>['/', '/config', '/connectivity', '/ui-states']),
    );
    expect(routes, isNot(contains('/shopper')));
    expect(routes, isNot(contains('/payments')));
  });
}
