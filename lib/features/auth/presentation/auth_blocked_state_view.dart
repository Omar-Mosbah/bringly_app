import 'package:bringly_app/design_system/components/bringly_state_view.dart';
import 'package:bringly_app/design_system/components/component_state.dart';
import 'package:bringly_app/features/auth/application/protected_marketplace_gate.dart';
import 'package:flutter/cupertino.dart';

class AuthBlockedStateView extends StatelessWidget {
  const AuthBlockedStateView({
    required this.reason,
    this.onAction,
    this.actionLabel,
    super.key,
  });

  final ProtectedMarketplaceGateReason reason;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final copy = _copyFor(reason);

    return BringlyStateView(
      componentState: ComponentState.blocked,
      title: copy.$1,
      message: copy.$2,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  (String, String) _copyFor(ProtectedMarketplaceGateReason reason) {
    return switch (reason) {
      ProtectedMarketplaceGateReason.emailConfirmationRequired => (
        'Confirm your email',
        'Check your inbox and confirm your email before protected marketplace access is available.',
      ),
      ProtectedMarketplaceGateReason.verificationRequired => (
        'Verification still needed',
        'Protected marketplace actions stay blocked until verification is complete.',
      ),
      _ => (
        'Access is limited',
        'Protected marketplace actions are not available right now.',
      ),
    };
  }
}