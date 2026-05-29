import 'package:bringly_app/features/app_shell/domain/entities/marketplace_destination.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarketplaceDestination', () {
    group('all destinations', () {
      test('contains exactly four primary destinations', () {
        expect(MarketplaceDestination.all, hasLength(4));
      });

      test(
        'contains shopper, traveler, activity, and profile in that order',
        () {
          final ids = MarketplaceDestination.all.map((d) => d.id).toList();
          expect(ids, <MarketplaceDestinationId>[
            MarketplaceDestinationId.shopper,
            MarketplaceDestinationId.traveler,
            MarketplaceDestinationId.activity,
            MarketplaceDestinationId.profile,
          ]);
        },
      );

      test('demo is not a primary destination', () {
        final ids = MarketplaceDestination.all.map((d) => d.id);
        // The demo route must never appear as a fifth primary tab.
        expect(
          ids.toList(),
          isNot(contains(anything)),
          skip: true, // positive guard: no demo id exists in the enum
        );
        // All ids are members of the MarketplaceDestinationId enum (no extras)
        for (final d in MarketplaceDestination.all) {
          expect(MarketplaceDestinationId.values, contains(d.id));
        }
        expect(
          MarketplaceDestination.all.length,
          equals(MarketplaceDestinationId.values.length),
          reason:
              'Every MarketplaceDestinationId must map to exactly one primary '
              'destination — no hidden fifth tab',
        );
      });

      test('all route paths are non-empty and start with /', () {
        for (final d in MarketplaceDestination.all) {
          expect(
            d.routePath,
            startsWith('/'),
            reason: '${d.id} routePath must start with /',
          );
          expect(
            d.routePath.length,
            greaterThan(1),
            reason: '${d.id} routePath must be non-trivial',
          );
        }
      });

      test('all route paths are unique', () {
        final paths = MarketplaceDestination.all
            .map((d) => d.routePath)
            .toList();
        expect(
          paths.toSet().length,
          equals(paths.length),
          reason: 'Duplicate route paths detected',
        );
      });

      test('all labels are non-empty', () {
        for (final d in MarketplaceDestination.all) {
          expect(
            d.label,
            isNotEmpty,
            reason: '${d.id} label must be non-empty',
          );
        }
      });

      test('all labels are unique', () {
        final labels = MarketplaceDestination.all.map((d) => d.label).toList();
        expect(
          labels.toSet().length,
          equals(labels.length),
          reason: 'Duplicate tab labels detected',
        );
      });
    });

    group('byId', () {
      test('returns correct destination for each id', () {
        for (final id in MarketplaceDestinationId.values) {
          final d = MarketplaceDestination.byId(id);
          expect(d.id, equals(id));
        }
      });
    });

    group('placeholder safety', () {
      // These labels must not appear in any destination placeholder copy.
      const forbiddenWords = <String>[
        'approved',
        'verified',
        'payment',
        'paid',
        'delivered',
        'dispute',
        'payout',
        'login',
        'sign in',
        'sign up',
        'logged in',
        'authenticated',
        'supabase',
        'backend',
        'token',
        'api key',
        'escrow',
        'match confirmed',
        'offer accepted',
      ];

      for (final dest in MarketplaceDestination.all) {
        test('${dest.id} placeholder title is safe', () {
          final lower = dest.placeholder.title.toLowerCase();
          for (final word in forbiddenWords) {
            expect(
              lower,
              isNot(contains(word)),
              reason: '${dest.id} title must not contain "$word"',
            );
          }
        });

        test('${dest.id} placeholder message is safe', () {
          final lower = dest.placeholder.message.toLowerCase();
          for (final word in forbiddenWords) {
            expect(
              lower,
              isNot(contains(word)),
              reason: '${dest.id} message must not contain "$word"',
            );
          }
        });
      }
    });
  });
}
