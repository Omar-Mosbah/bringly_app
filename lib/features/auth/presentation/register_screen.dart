import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/layouts/foundation_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/domain/value_objects/email_address.dart';
import 'package:bringly_app/features/auth/domain/value_objects/password_input.dart';
import 'package:bringly_app/features/profile/domain/entities/marketplace_role.dart';
import 'package:flutter/cupertino.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    required this.controller,
    this.onRegistered,
    super.key,
  });

  final AuthController controller;
  final VoidCallback? onRegistered;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  MarketplaceRole _selectedRole = MarketplaceRole.shopper;

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
          title: 'Register',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Start safely with email',
                textAlign: TextAlign.center,
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              const SizedBox(height: BringlySpacing.md),
              CupertinoTextField(
                key: const ValueKey<String>('register_email_field'),
                controller: _emailController,
                placeholder: 'Email address',
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(14),
              ),
              if (_emailError != null) ...<Widget>[
                const SizedBox(height: BringlySpacing.xs),
                Text(_emailError!, style: const TextStyle(color: CupertinoColors.systemRed)),
              ],
              const SizedBox(height: BringlySpacing.md),
              CupertinoTextField(
                key: const ValueKey<String>('register_password_field'),
                controller: _passwordController,
                placeholder: 'Password',
                obscureText: true,
                padding: const EdgeInsets.all(14),
              ),
              if (_passwordError != null) ...<Widget>[
                const SizedBox(height: BringlySpacing.xs),
                Text(
                  _passwordError!,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ],
              const SizedBox(height: BringlySpacing.md),
              CupertinoSlidingSegmentedControl<MarketplaceRole>(
                groupValue: _selectedRole,
                children: const <MarketplaceRole, Widget>{
                  MarketplaceRole.shopper: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Shopper'),
                  ),
                  MarketplaceRole.traveler: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Traveler'),
                  ),
                  MarketplaceRole.both: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Both'),
                  ),
                },
                onValueChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedRole = value;
                  });
                },
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
                    key: const ValueKey<String>('register_submit_button'),
                    child: BringlyButton(
                      label: 'Create account',
                      isLoading: state.isLoading,
                      onPressed: state.isLoading ? null : _submit,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    final email = EmailAddress(_emailController.text);
    final password = PasswordInput(_passwordController.text);

    setState(() {
      _emailError = email.validationMessage;
      _passwordError = password.validationMessage;
    });

    if (!email.isValid || !password.isValid) {
      return;
    }

    await widget.controller.register(
      email: email.value,
      password: _passwordController.text,
      marketplaceRole: _selectedRole,
    );

    if (!mounted) {
      return;
    }

    if (widget.controller.state.status == AuthControllerStatus.registered) {
      widget.onRegistered?.call();
    }
  }
}