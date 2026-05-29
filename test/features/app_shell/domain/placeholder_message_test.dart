import 'package:bringly_app/features/app_shell/domain/entities/placeholder_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlaceholderMessage', () {
    const safeMessage = PlaceholderMessage(
      title: 'Coming soon',
      message: 'This feature will be available in a future update.',
    );

    test('stores title and message', () {
      expect(safeMessage.title, equals('Coming soon'));
      expect(
        safeMessage.message,
        equals('This feature will be available in a future update.'),
      );
    });

    test('actionLabel defaults to null', () {
      expect(safeMessage.actionLabel, isNull);
    });

    test('blockedReason defaults to null', () {
      expect(safeMessage.blockedReason, isNull);
    });

    test('optional fields are stored when provided', () {
      const withExtras = PlaceholderMessage(
        title: 'Unavailable',
        message: 'Check back later.',
        actionLabel: 'Learn more',
        blockedReason: 'Not yet available in your region.',
      );
      expect(withExtras.actionLabel, equals('Learn more'));
      expect(
        withExtras.blockedReason,
        equals('Not yet available in your region.'),
      );
    });

    group('copy safety — must not imply completed marketplace events', () {
      const forbiddenInCopy = <String>[
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
        'authenticated',
        'supabase',
        'backend',
        'token',
        'api key',
        'escrow',
        'match confirmed',
        'offer accepted',
      ];

      void assertSafe(String label, String text) {
        final lower = text.toLowerCase();
        for (final word in forbiddenInCopy) {
          expect(
            lower,
            isNot(contains(word)),
            reason: '$label must not contain "$word"',
          );
        }
      }

      test('sample safe title passes', () {
        assertSafe('title', safeMessage.title);
      });

      test('sample safe message passes', () {
        assertSafe('message', safeMessage.message);
      });

      test('blocked reason must not expose provider internals', () {
        const blocked = PlaceholderMessage(
          title: 'Unavailable',
          message: 'This area is not yet open.',
          blockedReason: 'Coming in a future release.',
        );
        assertSafe('blockedReason', blocked.blockedReason!);
      });
    });
  });
}
