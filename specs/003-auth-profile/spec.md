# Feature Specification: Authentication and User Profile

**Feature Branch**: `003-auth-profile`

**Created**: 2026-05-29

**Status**: Draft

**Input**: User description: "Create a specification for Phase 2 - Authentication and User Profile from PLAN.md file"

## Clarifications

### Session 2026-05-30

- Q: What sign-in method must Phase 2 support for MVP registration and login? -> A: Email and password only
- Q: Which basic profile fields are in scope for Phase 2? -> A: Display name, avatar, country/city, and preferred language
- Q: Should Phase 2 include password recovery? -> A: Include password reset by email
- Q: Should email confirmation gate protected marketplace actions in Phase 2? -> A: Require email confirmation before marketplace actions
- Q: Should Phase 2 require a local app unlock after login? -> A: Require biometric or device PIN app unlock after login

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Create Account and Start Safely (Priority: P1)

A new visitor can understand the onboarding path, create a Bringly account, choose whether they want to shop, travel, or do both, and land in the app with a clear profile and verification status.

**Why this priority**: Registration is the entry point for every controlled marketplace workflow and establishes the user's role before they attempt shopper or traveler actions.

**Independent Test**: Can be fully tested by registering a new account, selecting a role, and confirming the profile summary shows the selected role and current verification state.

**Acceptance Scenarios**:

1. **Given** a new visitor has opened the app, **When** they complete onboarding and submit valid registration details, **Then** the account is created and they are taken to their profile or app shell with their role and verification state visible.
2. **Given** a new visitor submits invalid or incomplete registration details, **When** the account creation attempt fails, **Then** they see a safe, actionable message without raw backend or provider details.
3. **Given** a newly registered user has not completed required verification, **When** they try to start a protected marketplace action, **Then** the action is blocked and the user is guided toward verification.
4. **Given** a newly registered user has not confirmed their email address, **When** they try to start a protected marketplace action, **Then** the action is blocked and the user is guided to confirm their email.

---

### User Story 2 - Log In and Restore Session (Priority: P1)

A returning user can log in, unlock the app with biometric authentication or device PIN after login, and have their session restored after restarting the app, while expired or invalid sessions are handled safely.

**Why this priority**: Users need reliable access to marketplace state without repeatedly signing in, and the app must not continue with stale or invalid authorization.

**Independent Test**: Can be tested by logging in, closing and reopening the app, confirming the session restores, then simulating an expired session and confirming the app returns to a safe signed-out or re-authentication state.

**Acceptance Scenarios**:

1. **Given** a registered user provides valid credentials, **When** they log in, **Then** they enter the app and can view their profile summary.
2. **Given** a signed-in user has a valid session on a device that supports biometric authentication or device PIN, **When** the app is opened after login, **Then** local unlock is required before account content is shown.
3. **Given** a signed-in user restarts the app with a valid session and completes local unlock, **When** the app opens, **Then** the session is restored and the latest account status is refreshed.
4. **Given** a stored session is expired, revoked, malformed, or otherwise invalid, **When** the app attempts restoration, **Then** access is denied safely, sensitive local session values are cleared as appropriate, and the user is asked to log in again.
5. **Given** local unlock fails or is cancelled, **When** the app remains protected, **Then** account content and protected marketplace areas are not shown.

---

### User Story 3 - Log Out and Clear Access (Priority: P1)

A signed-in user can log out, ending local access to their account and clearing sensitive session values from secure storage.

**Why this priority**: Logout is a core account safety control, especially on shared or lost devices.

**Independent Test**: Can be tested by logging in, logging out, restarting the app, and confirming no authenticated screens or protected actions remain accessible without logging in again.

**Acceptance Scenarios**:

1. **Given** a signed-in user, **When** they choose logout and confirm if prompted, **Then** they are returned to the signed-out experience and cannot access protected marketplace areas.
2. **Given** logout is requested while network connectivity is unavailable, **When** local session removal can still proceed, **Then** local access ends and the user sees a safe status message if server confirmation is pending or unavailable.

---

### User Story 4 - Recover Account Access (Priority: P2)

A registered user who forgets their password can request a password reset by email and return to login without support intervention.

**Why this priority**: Password recovery is necessary for an email/password MVP and reduces account lockout risk.

**Independent Test**: Can be tested by requesting a password reset for a registered email, confirming a safe confirmation message, completing the reset path, and logging in with the new password.

**Acceptance Scenarios**:

1. **Given** a registered user has forgotten their password, **When** they request a password reset by email, **Then** the system provides a safe confirmation message and starts the recovery flow.
2. **Given** a user submits an unknown or malformed email address for password reset, **When** the request is processed, **Then** the response remains safe and does not expose whether an account exists.
3. **Given** a user completes a valid password reset, **When** they log in with the new password, **Then** access is restored and prior invalid credentials no longer work.

---

### User Story 5 - View and Manage Basic Profile (Priority: P2)

A signed-in user can view and update basic profile information, see their role selection, and understand their verification and account status.

**Why this priority**: The profile is the user's trust surface and the place where role, verification, and account restrictions become understandable.

**Independent Test**: Can be tested by opening the profile summary, updating allowed profile fields, changing role selection within permitted rules, and confirming status information remains accurate.

**Acceptance Scenarios**:

1. **Given** a signed-in user opens the profile area, **When** profile data loads successfully, **Then** they see their display name, avatar, country/city, preferred language, role selection, verification state, and account status in plain language.
2. **Given** a signed-in user updates permitted basic profile details, **When** the update succeeds, **Then** the profile reflects the new information without exposing sensitive account internals.
3. **Given** profile information cannot be loaded, **When** the user opens the profile area, **Then** they see a retryable error state that does not leak sensitive details.

---

### User Story 6 - Handle Suspended or Blocked Accounts (Priority: P2)

A user whose account is suspended, blocked, or otherwise restricted is prevented from marketplace actions and receives clear next steps.

**Why this priority**: A controlled marketplace must honor backend account restrictions immediately and consistently.

**Independent Test**: Can be tested by simulating a backend account status change to suspended and confirming the app blocks protected actions, refreshes the profile status, and forces logout when required.

**Acceptance Scenarios**:

1. **Given** the backend marks a signed-in account as suspended, **When** the app refreshes account status or receives an authorization failure, **Then** protected marketplace actions are blocked and the suspension state is shown safely.
2. **Given** the backend requires forced logout for an account, **When** the app receives that status, **Then** the session ends locally and the user is returned to the signed-out experience.

### Edge Cases

- Registration or login is attempted while the device is offline.
- Password reset is requested for an unknown, malformed, or rate-limited email address.
- Password reset link or recovery token is expired, already used, or invalid.
- User submits malformed, incomplete, or already-used account details.
- Session restoration starts while account status cannot be refreshed.
- Biometric authentication is unavailable, disabled, cancelled, locked out, or falls back to device PIN.
- Stored session values are missing, corrupted, revoked, or expired.
- User role data is missing or no longer permitted.
- Verification status changes while the user is in the app.
- Email confirmation is pending, expired, or completed on another device.
- Account is suspended after login but before a marketplace action.
- Logout is requested during an in-progress profile update.
- Profile data is empty, partially unavailable, or delayed.
- Multiple rapid login or logout attempts occur.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide an onboarding path that explains the account entry point and leads new users to registration or returning users to login.
- **FR-002**: System MUST allow new users to register using email and password credentials for the MVP.
- **FR-003**: System MUST validate required registration input before submission and show safe, actionable validation messages.
- **FR-004**: System MUST allow registered users to log in with valid email and password credentials.
- **FR-005**: System MUST show safe failure states for invalid credentials, unavailable service, rate limiting, blocked accounts, and unknown authentication failures.
- **FR-006**: System MUST restore a valid signed-in session after app restart.
- **FR-007**: System MUST detect expired, revoked, corrupted, missing, or otherwise invalid sessions and return the user to a safe signed-out or re-authentication state.
- **FR-008**: System MUST require biometric authentication or device PIN local app unlock after login before showing account content.
- **FR-009**: System MUST keep account content and protected marketplace areas hidden when local app unlock fails, is cancelled, or is locked out.
- **FR-010**: System MUST allow signed-in users to log out.
- **FR-011**: System MUST clear sensitive local session values when logout completes locally.
- **FR-012**: System MUST allow users to request a password reset by email.
- **FR-013**: Password reset responses MUST remain safe and must not reveal whether an email address belongs to an account.
- **FR-014**: System MUST handle expired, invalid, already-used, and rate-limited password reset attempts safely.
- **FR-015**: System MUST display a profile summary for signed-in users.
- **FR-016**: Profile summary MUST include display name, avatar, country/city, preferred language, selected marketplace role, verification status, and account status.
- **FR-017**: System MUST allow users to select the role of shopper, traveler, or both, subject to account eligibility.
- **FR-018**: System MUST allow users to view and update display name, avatar, country/city, and preferred language.
- **FR-019**: System MUST prevent users from editing restricted trust, verification, account status, or marketplace eligibility fields directly.
- **FR-020**: System MUST show verification status in a way that distinguishes at least incomplete, under review, verified, rejected, and blocked states when those states are returned for the account.
- **FR-021**: System MUST block protected marketplace actions when required verification is incomplete, rejected, blocked, or unavailable.
- **FR-022**: System MUST block protected marketplace actions when email confirmation is incomplete.
- **FR-023**: System MUST refresh account, role, email confirmation, verification, and suspension status after login and during session restoration.
- **FR-024**: System MUST handle suspended, blocked, or forced-logout account states by preventing protected actions and showing safe next steps.
- **FR-025**: System MUST provide loading, empty, error, unauthorized, blocked, success, and edge states for authentication and profile experiences.
- **FR-026**: System MUST avoid exposing raw backend, identity provider, policy, or security error details to users.
- **FR-027**: System MUST preserve a clear signed-out experience when no valid session exists.
- **FR-028**: System MUST support testable success, failure, unauthorized, loading, empty, blocked, and edge paths for registration, login, local app unlock, password reset, session restoration, logout, profile summary, role selection, email confirmation gating, verification gating, and suspension handling.

### Security & Privacy Requirements *(mandatory for Bringly)*

- **SPR-001**: Critical authorization and marketplace state changes MUST be validated by backend-controlled Supabase policies, Edge Functions, RPCs, or backend APIs.
- **SPR-002**: The mobile app MUST NOT log or send analytics for PII, auth tokens, payment data, identity documents, travel proof, receipts, or internal risk data.
- **SPR-003**: File uploads involving documents, receipts, package photos, or dispute evidence MUST use backend-issued signed upload URLs.
- **SPR-004**: Sensitive data MUST NOT be stored in normal local storage; secure storage is limited to small sensitive values such as auth/session tokens.
- **SPR-005**: User-facing errors MUST be safe, actionable, and must not expose raw backend, Supabase, payment, or provider internals.
- **SPR-006**: Auth/session tokens MUST be stored only in secure storage through a mockable storage abstraction.
- **SPR-007**: Auth/session tokens, credential values, account identifiers, verification details, and suspension reasons containing sensitive context MUST NOT be logged.
- **SPR-008**: Backend account status MUST remain the source of truth for verification state, role eligibility, suspension, forced logout, and marketplace access.
- **SPR-009**: The app MUST NOT make final authorization decisions for protected marketplace actions based only on locally cached profile or role data.
- **SPR-010**: Forced logout from the backend MUST end local authenticated access and clear sensitive session values.
- **SPR-011**: Profile and status screens MUST expose only user-safe status labels and next steps, not internal risk scores, policy details, or operational review notes.

### Key Entities *(include if feature involves data)*

- **User Account**: Represents a registered Bringly user with account identity, account status, and eligibility to access the app.
- **Session**: Represents the current signed-in state, including expiry and validity, without exposing token contents in normal app state or logs.
- **Local App Unlock**: Represents device-level biometric authentication or device PIN required before a signed-in user's account content is shown.
- **Password Reset Request**: Represents a user-initiated request to recover account access by email without revealing whether the account exists.
- **User Profile**: Represents user-facing profile information including display name, avatar, country/city, preferred language, selected role, and profile completeness.
- **Marketplace Role**: Represents whether the user intends to act as a shopper, traveler, or both, subject to backend eligibility.
- **Verification Status**: Represents user trust readiness, including incomplete, under review, verified, rejected, and blocked states.
- **Email Confirmation Status**: Represents whether the user's email address has been confirmed for protected marketplace access.
- **Account Restriction**: Represents backend-controlled restrictions such as suspended, blocked, or forced-logout states.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: At least 90% of test users can complete registration and role selection in under 3 minutes without assistance.
- **SC-002**: At least 95% of valid returning sessions restore to the correct signed-in or signed-out state within 3 seconds after app launch under normal network conditions.
- **SC-003**: 100% of expired, revoked, or corrupted session test cases prevent access to protected marketplace areas.
- **SC-004**: 100% of logout test cases remove local authenticated access after completion, including after app restart.
- **SC-005**: 100% of suspended or forced-logout account test cases block protected marketplace actions.
- **SC-006**: 100% of local unlock failure, cancellation, lockout, and fallback test cases keep account content hidden until successful unlock or sign-out.
- **SC-007**: 100% of unconfirmed-email test cases block protected marketplace actions while still allowing the user to view safe account guidance.
- **SC-008**: Users can identify their role and verification status from the profile summary within 5 seconds in usability review.
- **SC-009**: 100% of password reset responses use account-enumeration-safe messaging for unknown, malformed, and valid email submissions.
- **SC-010**: No authentication or profile test logs contain auth tokens, raw credential values, sensitive account identifiers, internal risk scores, or raw provider errors.
- **SC-011**: Authentication and profile test coverage includes success, failure, unauthorized, loading, empty, blocked, and edge states before the phase is considered complete.

## Assumptions

- The MVP supports email and password registration and login in this phase; social login, phone OTP login, and passwordless magic-link login are outside this phase.
- Biometric authentication or device PIN is a local app unlock after login and does not replace backend authentication, account verification, or authorization.
- Profile management in this phase is limited to basic user-facing fields, role selection, verification status display, and account restriction handling.
- Identity document collection, selfie/liveness checks, and detailed verification submission flows belong to Phase 3.
- Shopper request, traveler trip, payment, evidence, delivery, dispute, rating, and notification features remain outside this phase except where authentication or verification gating must block access.
- Backend systems provide authoritative account status, role eligibility, verification state, session validity, and forced-logout signals.
- The app may cache non-sensitive profile display data for UX, but it must refresh backend status before protected marketplace actions.
