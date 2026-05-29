import 'package:bringly_app/core/security/local_app_unlock.dart';
import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/domain/entities/local_unlock_state.dart';
import 'package:flutter/cupertino.dart';

class LocalUnlockScreen extends StatelessWidget {
  const LocalUnlockScreen({
    required this.controller,
    this.onUnlocked,
    this.onSignedOut,
    super.key,
  });

  final AuthController controller;
  final VoidCallback? onUnlocked;
  final VoidCallback? onSignedOut;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final state = controller.state;

        return FoundationScaffold(
          title: 'Unlock',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                _titleFor(state),
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              const SizedBox(height: BringlySpacing.md),
              Text(
                _messageFor(state),
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.textStyle,
              ),
              const SizedBox(height: BringlySpacing.lg),
              if (state.isLoading || state.unlockState?.phase == LocalUnlockPhase.inProgress)
                const Center(child: CupertinoActivityIndicator())
              else if (state.status == AuthControllerStatus.signedOut)
                CupertinoButton(
                  onPressed: onSignedOut,
                  child: const Text('Back to sign in'),
                )
              else
                KeyedSubtree(
                  key: const ValueKey<String>('local_unlock_button'),
                  child: BringlyButton(
                    label: 'Unlock app',
                    onPressed: () async {
                      await controller.unlock();
                      if (controller.state.isSignedInUnlocked) {
                        onUnlocked?.call();
                      }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _titleFor(AuthControllerState state) {
    return switch (state.status) {
      AuthControllerStatus.signedOut => 'You have been signed out.',
      AuthControllerStatus.loading => 'Unlock in progress',
      _ => 'Unlock required',
    };
  }

  String _messageFor(AuthControllerState state) {
    if (state.failure != null) {
      return state.failure!.message;
    }

    return switch (state.unlockState?.phase) {
      LocalUnlockPhase.cancelled => 'Local unlock was cancelled.',
      LocalUnlockPhase.failed => 'Local unlock could not be completed.',
      LocalUnlockPhase.lockedOut => 'Local unlock is temporarily locked.',
      _ when state.unlockState?.availability == LocalAppUnlockAvailability.unavailable =>
        'Local unlock is not available on this device.',
      _ => 'Unlock the app to continue to protected account content.',
    };
  }
}