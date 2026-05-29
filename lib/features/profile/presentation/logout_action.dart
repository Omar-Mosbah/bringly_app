import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:flutter/cupertino.dart';

class LogoutAction extends StatelessWidget {
  const LogoutAction({
    required this.controller,
    this.onSignedOut,
    super.key,
  });

  final AuthController controller;
  final VoidCallback? onSignedOut;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final state = controller.state;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (state.safeMessage != null) ...<Widget>[
              Text(
                state.safeMessage!,
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
              const SizedBox(height: BringlySpacing.sm),
            ],
            BringlyButton(
              label: 'Sign out',
              isLoading: state.isLoading,
              onPressed: state.isLoading ? null : () => _confirmSignOut(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final shouldContinue = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Sign out of this device?'),
          content: const Text(
            'Protected marketplace content will require sign in again.',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (shouldContinue != true) {
      return;
    }

    await controller.signOut();
    if (controller.state.status == AuthControllerStatus.signedOut) {
      onSignedOut?.call();
    }
  }
}