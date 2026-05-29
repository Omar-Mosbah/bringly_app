import 'package:bringly_app/app/theme/bringly_theme.dart';
import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/components/bringly_card.dart';
import 'package:bringly_app/design_system/components/bringly_state_view.dart';
import 'package:bringly_app/design_system/components/bringly_text_field.dart';
import 'package:bringly_app/design_system/components/component_state.dart';
import 'package:bringly_app/design_system/components/cupertino_bottom_action_sheet.dart';
import 'package:bringly_app/design_system/components/evidence_tile.dart';
import 'package:bringly_app/design_system/components/status_chip.dart';
import 'package:bringly_app/design_system/components/trust_badge.dart';
import 'package:bringly_app/design_system/components/verification_status_banner.dart';
import 'package:bringly_app/design_system/tokens/bringly_colors.dart';
import 'package:bringly_app/design_system/tokens/bringly_radii.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/app_shell/presentation/design_system_demo_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

/// The Design System Demo screen — a non-primary route reachable from Profile.
///
/// All demo actions are local only and do not call Supabase, storage,
/// analytics, or backend state-changing APIs.
class DesignSystemDemoScreen extends StatefulWidget {
  const DesignSystemDemoScreen({super.key});

  @override
  State<DesignSystemDemoScreen> createState() => _DesignSystemDemoScreenState();
}

class _DesignSystemDemoScreenState extends State<DesignSystemDemoScreen> {
  bool _buttonLoading = false;

  void _simulateLoading() {
    setState(() => _buttonLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _buttonLoading = false);
    });
  }

  void _showActionSheet() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => BringlyCupertinoActionSheet(
        title: 'Demo Action',
        message: 'Choose a local action — no marketplace state changes.',
        actions: [
          BringlyActionSheetAction(
            label: 'Primary action',
            onPressed: () => Navigator.of(context).pop(),
          ),
          BringlyActionSheetAction(
            label: 'Secondary action',
            onPressed: () => Navigator.of(context).pop(),
          ),
          BringlyActionSheetAction(
            label: 'Remove demo item',
            onPressed: () => Navigator.of(context).pop(),
            isDestructive: true,
          ),
        ],
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: BringlyColors.surface,
      navigationBar: CupertinoNavigationBar(
        key: const ValueKey<String>('design_system_nav_bar'),
        backgroundColor: BringlyColors.frostedSurface,
        automaticBackgroundVisibility: false,
        border: Border(
          bottom: BorderSide(
            color: BringlyColors.border.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        middle: Text(
          'Design System',
          style: BringlyTheme.compactLabelStyle(context),
        ),
        trailing: CupertinoButton(
          key: const ValueKey<String>('design_system_close_button'),
          padding: EdgeInsets.zero,
          onPressed: () => context.go('/profile'),
          child: Text(
            'Close',
            style: BringlyTheme.compactLabelStyle(
              context,
            ).copyWith(color: BringlyColors.accent),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: BringlySpacing.md,
            vertical: BringlySpacing.lg,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(BringlySpacing.lg),
              decoration: BoxDecoration(
                color: BringlyColors.card.withValues(alpha: 0.84),
                borderRadius: BorderRadius.circular(BringlyRadii.lg),
                border: Border.all(
                  color: BringlyColors.frostedBorder,
                  width: 0.9,
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'iOS-inspired Bringly surfaces',
                    style: BringlyTheme.headingStyle(context),
                  ),
                  const SizedBox(height: BringlySpacing.xs),
                  Text(
                    'Updated to follow the Figma community kit while keeping '
                    'Bringly-safe copy, states, and architecture.',
                    style: BringlyTheme.captionStyle(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: BringlySpacing.lg),
            _sectionHeader('Buttons'),
            BringlyButton(label: 'Normal', onPressed: () {}),
            const SizedBox(height: 8),
            BringlyButton(
              label: 'Loading',
              onPressed: _buttonLoading ? null : _simulateLoading,
              isLoading: _buttonLoading,
            ),
            const SizedBox(height: 8),
            const BringlyButton(label: 'Disabled', onPressed: null),
            const SizedBox(height: 8),
            BringlyButton(
              label: 'Error state',
              onPressed: () {},
              isError: true,
            ),
            const SizedBox(height: 24),

            _sectionHeader('Cards'),
            BringlyCard(
              onTap: () {},
              child: const Text('Tappable card — tap to interact'),
            ),
            const SizedBox(height: 8),
            const BringlyCard(
              isDisabled: true,
              child: Text('Disabled card — no tap'),
            ),
            const SizedBox(height: 8),
            BringlyCard(
              statusSlot: const StatusChip(
                status: ChipStatus.pending,
                label: 'In review',
              ),
              child: const Text('Card with status slot'),
            ),
            const SizedBox(height: 24),

            _sectionHeader('Text Fields'),
            const BringlyTextField(
              label: 'Normal field',
              placeholder: 'Enter text',
            ),
            const SizedBox(height: 8),
            const BringlyTextField(
              label: 'With helper',
              helperText: 'This is helper text',
            ),
            const SizedBox(height: 8),
            const BringlyTextField(
              label: 'Error state',
              errorText: 'This field is required',
              isError: true,
            ),
            const SizedBox(height: 8),
            const BringlyTextField(label: 'Disabled field', isDisabled: true),
            const SizedBox(height: 24),

            _sectionHeader('Status'),
            Row(
              children: const [
                TrustBadge(status: TrustBadgeStatus.reviewed),
                SizedBox(width: 8),
                TrustBadge(status: TrustBadgeStatus.pending),
                SizedBox(width: 8),
                TrustBadge(status: TrustBadgeStatus.notStarted),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                StatusChip(status: ChipStatus.success, label: 'Active'),
                StatusChip(status: ChipStatus.error, label: 'Failed'),
                StatusChip(status: ChipStatus.warning, label: 'Attention'),
                StatusChip(status: ChipStatus.blocked, label: 'Unavailable'),
                StatusChip(status: ChipStatus.pending, label: 'In review'),
              ],
            ),
            const SizedBox(height: 24),

            _sectionHeader('Banners'),
            const VerificationStatusBanner(
              message: 'Demo banner for a positive review-style status only.',
              isPositive: true,
            ),
            const SizedBox(height: 8),
            const VerificationStatusBanner(
              message: 'Some information may need review before proceeding.',
            ),
            const SizedBox(height: 24),

            _sectionHeader('Marketplace Cards'),
            ...DemoData.travelerCards,
            const SizedBox(height: 8),
            ...DemoData.requestCards,
            const SizedBox(height: 24),

            _sectionHeader('Price Breakdown'),
            DemoData.priceBreakdown,
            const SizedBox(height: 24),

            _sectionHeader('Evidence Tiles'),
            const EvidenceTile(
              label: 'Evidence placeholder A',
              subtitle: 'Demo attachment label only',
            ),
            const SizedBox(height: 8),
            const EvidenceTile(label: 'Evidence placeholder B'),
            const SizedBox(height: 24),

            _sectionHeader('State Screens'),
            BringlyStateView(
              componentState: ComponentState.loading,
              title: 'Loading',
              message: 'Fetching your items…',
            ),
            const SizedBox(height: 8),
            BringlyStateView(
              componentState: ComponentState.empty,
              title: 'Nothing here yet',
              message: 'When items appear they will show up here.',
            ),
            const SizedBox(height: 8),
            BringlyStateView(
              componentState: ComponentState.blocked,
              title: 'Not available',
              message: 'This feature is not available in your current context.',
            ),
            const SizedBox(height: 8),
            BringlyStateView(
              componentState: ComponentState.error,
              title: 'Something went wrong',
              message: 'Please try again.',
              actionLabel: 'Retry',
              onAction: () {},
            ),
            const SizedBox(height: 24),

            _sectionHeader('Action Sheet'),
            BringlyButton(
              label: 'Show action sheet',
              onPressed: _showActionSheet,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BringlySpacing.sm),
      child: Text(
        title,
        style: BringlyTheme.compactLabelStyle(
          context,
        ).copyWith(color: BringlyColors.ink),
      ),
    );
  }
}
