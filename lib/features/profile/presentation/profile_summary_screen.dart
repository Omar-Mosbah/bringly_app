import 'package:bringly_app/design_system/components/bringly_button.dart';
import 'package:bringly_app/design_system/layouts/marketplace_shell_scaffold.dart';
import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:bringly_app/features/auth/application/auth_controller.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/application/profile_controller.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/user_profile.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';
import 'package:bringly_app/features/profile/presentation/logout_action.dart';
import 'package:flutter/cupertino.dart';

class ProfileSummaryScreen extends StatefulWidget {
  const ProfileSummaryScreen({
    required this.controller,
    this.authController,
    this.onEditProfile,
    this.onChangeRole,
    this.onDesignSystemDemo,
    this.onSignedOut,
    super.key,
  });

  final ProfileController controller;
  final AuthController? authController;
  final VoidCallback? onEditProfile;
  final VoidCallback? onChangeRole;
  final VoidCallback? onDesignSystemDemo;
  final VoidCallback? onSignedOut;

  @override
  State<ProfileSummaryScreen> createState() => _ProfileSummaryScreenState();
}

class _ProfileSummaryScreenState extends State<ProfileSummaryScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.controller.state.status == ProfileControllerStatus.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller.loadSummary();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;

        return MarketplaceShellScaffold(
          title: 'Profile',
          body: switch (state.status) {
            ProfileControllerStatus.loading => const Center(
              child: CupertinoActivityIndicator(),
            ),
            ProfileControllerStatus.empty => _EmptyProfileState(
              onEditProfile: widget.onEditProfile,
              onDesignSystemDemo: widget.onDesignSystemDemo,
            ),
            ProfileControllerStatus.loaded || ProfileControllerStatus.updated
              when state.profile != null => _LoadedProfileState(
                profile: state.profile!,
                authController: widget.authController,
                onEditProfile: widget.onEditProfile,
                onChangeRole: widget.onChangeRole,
                onDesignSystemDemo: widget.onDesignSystemDemo,
                onSignedOut: widget.onSignedOut,
              ),
            ProfileControllerStatus.error => Center(
              child: Text(
                state.failure?.message ?? 'Something went wrong. Please try again.',
                textAlign: TextAlign.center,
              ),
            ),
            _ => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class _EmptyProfileState extends StatelessWidget {
  const _EmptyProfileState({this.onEditProfile, this.onDesignSystemDemo});

  final VoidCallback? onEditProfile;
  final VoidCallback? onDesignSystemDemo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: BringlySpacing.lg),
        Text(
          'Complete your basic profile to personalize Bringly.',
          textAlign: TextAlign.center,
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
        const SizedBox(height: BringlySpacing.md),
        BringlyButton(label: 'Edit profile', onPressed: onEditProfile),
        const SizedBox(height: BringlySpacing.sm),
        CupertinoButton(
          onPressed: onDesignSystemDemo,
          child: const Text('View Design System'),
        ),
      ],
    );
  }
}

class _LoadedProfileState extends StatelessWidget {
  const _LoadedProfileState({
    required this.profile,
    this.authController,
    this.onEditProfile,
    this.onChangeRole,
    this.onDesignSystemDemo,
    this.onSignedOut,
  });

  final UserProfile profile;
  final AuthController? authController;
  final VoidCallback? onEditProfile;
  final VoidCallback? onChangeRole;
  final VoidCallback? onDesignSystemDemo;
  final VoidCallback? onSignedOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          profile.displayName.value,
          textAlign: TextAlign.center,
          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
        ),
        const SizedBox(height: BringlySpacing.sm),
        Text(profile.countryCity.displayValue, textAlign: TextAlign.center),
        const SizedBox(height: BringlySpacing.sm),
        Text(_languageLabel(profile.preferredLanguage.value), textAlign: TextAlign.center),
        const SizedBox(height: BringlySpacing.md),
        Text(_titleCase(profile.marketplaceRole.name)),
        const SizedBox(height: BringlySpacing.xs),
        Text(
          'Email confirmation: ${_emailLabel(profile.emailConfirmationStatus)}',
        ),
        const SizedBox(height: BringlySpacing.xs),
        Text('Verification: ${_verificationLabel(profile.verificationStatus)}'),
        const SizedBox(height: BringlySpacing.xs),
        Text('Account: ${_accountLabel(profile.accountRestriction)}'),
        if (profile.accountRestriction != AccountRestriction.active) ...<Widget>[
          const SizedBox(height: BringlySpacing.md),
          const Text(
            'Protected marketplace actions are unavailable right now.',
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: BringlySpacing.md),
        BringlyButton(label: 'Edit profile', onPressed: onEditProfile),
        const SizedBox(height: BringlySpacing.sm),
        CupertinoButton(onPressed: onChangeRole, child: const Text('Change role')),
        if (authController != null) ...<Widget>[
          const SizedBox(height: BringlySpacing.sm),
          LogoutAction(
            controller: authController!,
            onSignedOut: onSignedOut,
          ),
        ],
        const SizedBox(height: BringlySpacing.sm),
        CupertinoButton(
          onPressed: onDesignSystemDemo,
          child: const Text('View Design System'),
        ),
      ],
    );
  }

  String _titleCase(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  String _languageLabel(String code) {
    return switch (code) {
      'es' => 'Spanish',
      'fr' => 'French',
      _ => 'English',
    };
  }

  String _emailLabel(EmailConfirmationStatus status) {
    return switch (status) {
      EmailConfirmationStatus.pending => 'Pending',
      EmailConfirmationStatus.expired => 'Expired',
      EmailConfirmationStatus.unavailable => 'Unavailable',
      EmailConfirmationStatus.confirmed => 'Confirmed',
    };
  }

  String _verificationLabel(VerificationStatus status) {
    return switch (status) {
      VerificationStatus.incomplete => 'Incomplete',
      VerificationStatus.underReview => 'Under review',
      VerificationStatus.verified => 'Verified',
      VerificationStatus.rejected => 'Rejected',
      VerificationStatus.blocked => 'Blocked',
      VerificationStatus.unavailable => 'Unavailable',
    };
  }

  String _accountLabel(AccountRestriction restriction) {
    return switch (restriction) {
      AccountRestriction.active => 'Active',
      AccountRestriction.suspended => 'Suspended',
      AccountRestriction.blocked => 'Blocked',
      AccountRestriction.forcedLogoutRequired => 'Forced logout required',
    };
  }
}