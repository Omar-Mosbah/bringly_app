import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/components/bringly_state_view.dart';
import 'package:bringly_app/design_system/components/component_state.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:flutter/cupertino.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    required this.controller,
    this.onRegister,
    super.key,
  });

  final AuthController controller;
  final VoidCallback? onRegister;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final state = controller.state;

        return FoundationScaffold(
          title: 'Welcome',
          child: switch (state.status) {
            AuthControllerStatus.loading => const Center(
              child: BringlyStateView(
                componentState: ComponentState.loading,
                title: 'Checking account access',
                message: 'Preparing the safest sign-in path for this device.',
              ),
            ),
            AuthControllerStatus.empty => const Center(
              child: BringlyStateView(
                componentState: ComponentState.empty,
                title: 'No saved session',
                message: 'Create an account to start with a protected setup.',
              ),
            ),
            _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: BringlySpacing.xl),
                Text(
                  'Create your account',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                ),
                const SizedBox(height: BringlySpacing.sm),
                Text(
                  'Choose how you want to use Bringly.',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                const SizedBox(height: BringlySpacing.xl),
                    KeyedSubtree(
                      key: const ValueKey<String>('onboarding_register_button'),
                      child: BringlyButton(
                        label: 'Create account',
                        onPressed: onRegister,
                      ),
                ),
              ],
            ),
          },
        );
      },
    );
  }
}