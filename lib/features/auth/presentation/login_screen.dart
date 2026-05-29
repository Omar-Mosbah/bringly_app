import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.controller,
    this.onLoggedIn,
    this.onForgotPassword,
    super.key,
  });

  final AuthController controller;
  final VoidCallback? onLoggedIn;
  final VoidCallback? onForgotPassword;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;

        return FoundationScaffold(
          title: 'Sign in',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Welcome back',
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              const SizedBox(height: BringlySpacing.md),
              CupertinoTextField(
                key: const ValueKey<String>('login_email_field'),
                controller: _emailController,
                placeholder: 'Email address',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(14),
              ),
              const SizedBox(height: BringlySpacing.md),
              CupertinoTextField(
                key: const ValueKey<String>('login_password_field'),
                controller: _passwordController,
                placeholder: 'Password',
                obscureText: true,
                padding: const EdgeInsets.all(14),
              ),
              const SizedBox(height: BringlySpacing.md),
              if (state.failure != null) ...<Widget>[
                Text(
                  state.failure!.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
                const SizedBox(height: BringlySpacing.sm),
              ],
              KeyedSubtree(
                key: const ValueKey<String>('login_submit_button'),
                child: BringlyButton(
                  label: 'Sign in',
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : _submit,
                ),
              ),
              const SizedBox(height: BringlySpacing.sm),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: state.isLoading ? null : widget.onForgotPassword,
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    await widget.controller.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) {
      return;
    }

    if (widget.controller.state.isSignedInLocked) {
      widget.onLoggedIn?.call();
    }
  }
}