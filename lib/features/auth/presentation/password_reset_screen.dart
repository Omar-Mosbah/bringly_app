import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:flutter/cupertino.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({required this.controller, super.key});

  final AuthController controller;

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  late final TextEditingController _emailController = TextEditingController();

  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;

        return FoundationScaffold(
          title: 'Reset password',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Recover account access',
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              const SizedBox(height: BringlySpacing.md),
              CupertinoTextField(
                key: const ValueKey<String>('password_reset_email_field'),
                controller: _emailController,
                placeholder: 'Email address',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(14),
              ),
              if (_emailError != null) ...<Widget>[
                const SizedBox(height: BringlySpacing.xs),
                Text(
                  _emailError!,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ],
              const SizedBox(height: BringlySpacing.md),
              if (state.failure != null) ...<Widget>[
                Text(
                  state.failure!.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
                const SizedBox(height: BringlySpacing.sm),
              ],
              if (state.safeMessage != null) ...<Widget>[
                Text(
                  state.safeMessage!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BringlySpacing.sm),
              ],
              BringlyButton(
                label: 'Send reset link',
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : _submit,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    final email = EmailAddress(_emailController.text);
    setState(() {
      _emailError = email.validationMessage;
    });

    if (!email.isValid) {
      return;
    }

    await widget.controller.requestPasswordReset(email: email.value);
  }
}