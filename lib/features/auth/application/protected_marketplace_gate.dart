import 'package:bringly_app/features/auth/domain/entities/auth_session.dart';
import 'package:bringly_app/features/auth/domain/entities/email_confirmation_status.dart';
import 'package:bringly_app/features/profile/domain/entities/account_restriction.dart';
import 'package:bringly_app/features/profile/domain/entities/verification_status.dart';

enum ProtectedMarketplaceGateReason {
  allowed,
  signedOut,
  localUnlockRequired,
  emailConfirmationRequired,
  verificationRequired,
  restricted,
}

class ProtectedMarketplaceGateResult {
  const ProtectedMarketplaceGateResult({
    required this.reason,
    required this.title,
    required this.message,
  });

  final ProtectedMarketplaceGateReason reason;
  final String title;
  final String message;

  bool get isAllowed => reason == ProtectedMarketplaceGateReason.allowed;
}

class ProtectedMarketplaceGate {
  const ProtectedMarketplaceGate();

  ProtectedMarketplaceGateResult call({
    required AuthSession session,
    required EmailConfirmationStatus emailConfirmationStatus,
    required VerificationStatus verificationStatus,
    required AccountRestriction accountRestriction,
  }) {
    if (!session.isSignedIn) {
      return const ProtectedMarketplaceGateResult(
        reason: ProtectedMarketplaceGateReason.signedOut,
        title: 'Sign in required',
        message: 'Sign in to continue to protected marketplace actions.',
      );
    }

    if (session.blocksProtectedContent) {
      return const ProtectedMarketplaceGateResult(
        reason: ProtectedMarketplaceGateReason.localUnlockRequired,
        title: 'Unlock required',
        message: 'Unlock the app to continue to protected marketplace actions.',
      );
    }

    if (!emailConfirmationStatus.allowsProtectedAccess) {
      return const ProtectedMarketplaceGateResult(
        reason: ProtectedMarketplaceGateReason.emailConfirmationRequired,
        title: 'Confirm your email',
        message: 'Confirm your email before using protected marketplace actions.',
      );
    }

    if (!verificationStatus.allowsProtectedMarketplaceAccess) {
      return const ProtectedMarketplaceGateResult(
        reason: ProtectedMarketplaceGateReason.verificationRequired,
        title: 'Verification still needed',
        message: 'Complete account verification before using protected marketplace actions.',
      );
    }

    if (accountRestriction.blocksProtectedMarketplace) {
      return const ProtectedMarketplaceGateResult(
        reason: ProtectedMarketplaceGateReason.restricted,
        title: 'Account access is limited',
        message: 'Protected marketplace actions are not available for this account right now.',
      );
    }

    return const ProtectedMarketplaceGateResult(
      reason: ProtectedMarketplaceGateReason.allowed,
      title: 'Protected access allowed',
      message: 'Protected marketplace actions are available.',
    );
  }
}