import 'package:bringly_app/design_system/components/status_chip.dart';
import 'package:bringly_app/design_system/components/trust_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_bringly_widget.dart';

void main() {
  group('TrustBadge', () {
    testWidgets('renders reviewed demo label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const TrustBadge(status: TrustBadgeStatus.reviewed),
      );
      expect(find.text('Demo reviewed'), findsOneWidget);
    });

    testWidgets('renders pending label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const TrustBadge(status: TrustBadgeStatus.pending),
      );
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('renders not-started label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const TrustBadge(status: TrustBadgeStatus.notStarted),
      );
      expect(find.text('Not started'), findsOneWidget);
    });

    testWidgets('does not claim approval or payment completion', (
      tester,
    ) async {
      for (final status in TrustBadgeStatus.values) {
        await pumpBringlyWidget(tester, TrustBadge(status: status));
      }
      const forbidden = [
        'approved',
        'paid',
        'delivered',
        'dispute',
        'payout',
        'verified',
      ];
      for (final word in forbidden) {
        expect(
          find.textContaining(word, findRichText: true),
          findsNothing,
          reason: 'TrustBadge must not use "$word"',
        );
      }
    });
  });

  group('StatusChip', () {
    testWidgets('renders success label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const StatusChip(status: ChipStatus.success, label: 'Active'),
      );
      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('renders error label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const StatusChip(status: ChipStatus.error, label: 'Failed'),
      );
      expect(find.text('Failed'), findsOneWidget);
    });

    testWidgets('renders warning label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const StatusChip(status: ChipStatus.warning, label: 'Attention'),
      );
      expect(find.text('Attention'), findsOneWidget);
    });

    testWidgets('renders blocked label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const StatusChip(status: ChipStatus.blocked, label: 'Unavailable'),
      );
      expect(find.text('Unavailable'), findsOneWidget);
    });

    testWidgets('renders pending label', (tester) async {
      await pumpBringlyWidget(
        tester,
        const StatusChip(status: ChipStatus.pending, label: 'In review'),
      );
      expect(find.text('In review'), findsOneWidget);
    });

    testWidgets('has stable test key', (tester) async {
      await pumpBringlyWidget(
        tester,
        const StatusChip(
          key: Key('chip_status'),
          status: ChipStatus.success,
          label: 'OK',
        ),
      );
      expect(find.byKey(const Key('chip_status')), findsOneWidget);
    });
  });
}
