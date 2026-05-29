# Bringly Mobile App — Spec Kit MVP Implementation Plan

## Executive Summary

Bringly is a security-first peer-to-peer assisted shopping and traveler delivery marketplace. The platform connects shoppers who want goods from other countries with verified travelers who can bring approved items using their available luggage capacity.

The MVP must not be treated as an open global marketplace. It should launch as a controlled marketplace with one initial travel corridor, low-risk approved item categories, verified users, manual operational review, backend-controlled transaction states, and payment protection.

The product objective is to create a trusted marketplace where neither the shopper nor the traveler depends on blind trust. Every critical action must be verified, recorded, and controlled by the backend. This creates a zero-trust workflow where identity, trip proof, item approval, payment status, purchase evidence, delivery confirmation, disputes, and payouts are all governed by platform rules.

The mobile app will be built with Flutter using an iOS-first Cupertino experience. The visual direction should be inspired by Airbnb’s marketplace clarity: clean cards, strong hierarchy, high whitespace, trust indicators, simple calls to action, and premium visual confidence. The app must not copy Airbnb branding, protected layouts, colors, assets, icons, or trade dress.

Spec Kit will be used to manage the implementation phase by phase. Each phase should produce a clear specification, plan, tasks, checklist, and implementation output. Codex GPT-5.5 should be used as the implementation assistant, but the source of truth must remain the written specification and project constitution.

The target is not “100% security,” because that is not a realistic engineering claim. The correct target is security by design: no known critical or high vulnerabilities before release, backend-controlled authorization, privacy-safe logging, secure storage, signed file uploads, verified transaction states, audit logs, and automated tests for abuse cases.

---

## Product Vision

Bringly enables people to safely request approved goods from another country and match with verified travelers who can bring those goods for a reward.

The platform creates value for:

- **Shoppers** who want access to goods from foreign markets.
- **Travelers** who want to monetize unused luggage capacity.
- **The platform** by providing verification, payment protection, evidence collection, dispute handling, and trust infrastructure.

---

## MVP Strategy

The MVP should be launched in a limited and controlled way.

### MVP Scope

- One initial origin-destination corridor.
- Low-risk item categories only.
- Verified shoppers and travelers.
- Manual admin approval for items and trips.
- Backend-controlled transaction lifecycle.
- Payment protection before traveler purchase or delivery.
- Evidence-based purchase and delivery verification.
- OTP or QR-based handover confirmation.
- Dispute and refund handling.
- Ratings after completed transactions.

### Out of MVP Scope

- Fully automated global marketplace.
- Advanced AI matching.
- High-risk item categories.
- Fully automated compliance decisions.
- In-app admin dashboard.
- Real escrow claims before legal/payment review.
- Multi-country expansion before operational validation.

---

## Non-Negotiable Product Principles

### 1. Security Before Features

No feature should bypass security, verification, or backend authorization.

Rules:

- No sensitive decision is made only on the mobile client.
- No API endpoint relies on client-provided trust.
- No secrets, private keys, payment credentials, or admin capabilities exist in the mobile app.
- No sensitive identity, payment, travel, or document data is logged.
- No direct database access from the mobile app.

### 2. Zero-Trust Marketplace Lifecycle

Every important action must have evidence and backend validation.

Critical actions include:

- User verification.
- Trip verification.
- Item approval.
- Offer acceptance.
- Payment secured.
- Purchase evidence submitted.
- Delivery handover.
- Dispute opening.
- Payout release.

### 3. Backend as Source of Truth

The Flutter app displays states and requests actions, but the backend owns all critical decisions.

The backend controls:

- User verification status.
- Traveler eligibility.
- Item approval.
- Match eligibility.
- Offer status.
- Payment status.
- Purchase evidence status.
- Delivery status.
- Dispute status.
- Payout status.
- Account suspension.

### 4. Privacy and Data Minimization

The app should collect and expose only what is necessary.

Rules:

- Do not expose full identity documents to the opposite party.
- Do not expose full travel proof to shoppers.
- Do not expose payment data.
- Do not expose internal risk scores.
- Do not send PII to analytics or crash reporting.

### 5. MVP Discipline

The MVP is designed to validate the operating model, not to automate everything.

The first release should prioritize:

- Safety.
- Manual review.
- Trust.
- Evidence.
- Payment protection.
- Operational control.

---

## Recommended Flutter Architecture

The mobile app should use a feature-first clean architecture.

```text
lib/
  app/
    app.dart
    router/
    theme/
    localization/
    config/
  core/
    network/
    security/
    errors/
    logging/
    analytics/
    storage/
    widgets/
    utils/
  design_system/
    tokens/
    components/
    layouts/
    cupertino_adapters/
  features/
    onboarding/
    auth/
    verification/
    shopper_requests/
    traveler_trips/
    matching/
    offers/
    payments/
    evidence/
    delivery/
    disputes/
    ratings/
    notifications/
    profile/
    support/
test/
integration_test/
```

### Recommended Mobile Stack

| Area | Recommendation |
|---|---|
| Framework | Flutter |
| Design direction | iOS-first Cupertino style |
| State management | Riverpod |
| Routing | go_router |
| API client | Dio + generated OpenAPI client |
| Models | freezed + json_serializable |
| Secure token storage | flutter_secure_storage behind abstraction |
| Local cache | Drift or Hive for non-sensitive data only |
| Notifications | Firebase Cloud Messaging or equivalent |
| Crash reporting | Sentry or Firebase Crashlytics |
| Analytics | Privacy-filtered product analytics |
| File uploads | Backend-issued signed upload URLs |
| Tests | Unit, widget, integration, and golden tests |

---

## Suggested Backend Architecture Boundary

The mobile app should not be a client-driven Firebase-style marketplace. The product requires a backend-controlled state machine.

```text
Flutter Mobile App
        ↓
Backend API / BFF
        ↓
Domain Services
- Auth
- Verification
- Item Compliance
- Matching
- Offers
- Payments
- Evidence
- Delivery
- Disputes
- Ratings
- Notifications
        ↓
Database / Object Storage / Payment Provider / KYC Provider
        ↓
Admin Dashboard
```

---

## Main Transaction Lifecycle

```text
DRAFT
UNDER_REVIEW
REJECTED
PUBLISHED
MATCHED
OFFER_ACCEPTED
PAYMENT_PENDING
PAYMENT_SECURED
PURCHASE_PENDING
PURCHASE_CONFIRMED
IN_TRANSIT
ARRIVED
HANDOVER_PENDING
DELIVERED
COMPLETED
DISPUTED
CANCELLED
REFUNDED
```

---

# Spec Kit Implementation Phases

Each phase should follow the same Spec Kit workflow:

```text
$speckit-specify
$speckit-clarify
$speckit-plan
$speckit-tasks
$speckit-checklist
$speckit-analyze
$speckit-implement
```

If skills mode is not enabled, use the slash-command format:

```text
/speckit.specify
/speckit.clarify
/speckit.plan
/speckit.tasks
/speckit.checklist
/speckit.analyze
/speckit.implement
```

---

## Phase 0 — Constitution, Foundation, and Security Baseline

### Goal

Create the Flutter project foundation, architecture baseline, security constraints, CI setup, design system base, and testing structure.

### Main Deliverables

- Project constitution.
- Flutter app shell.
- Environment configuration for dev, staging, and production.
- Routing foundation.
- Secure storage abstraction.
- Typed network client foundation.
- Error handling model.
- Privacy-safe logging abstraction.
- Privacy-safe analytics abstraction.
- Design system token foundation.
- Testing foundation.
- CI-ready commands.

### Functional Requirements

- App launches successfully.
- Placeholder navigation works.
- Environment variables are separated by environment.
- Network calls go through a typed client.
- Secure storage is abstracted and mockable.
- Logging redacts sensitive values.
- Loading, empty, error, blocked, and offline UI states exist.

### Security Requirements

- No hardcoded secrets.
- No sensitive values in logs.
- No sensitive values in analytics.
- No direct database access from mobile.
- No local storage for sensitive documents.
- Backend authorization required for all future secured actions.

### Completion Criteria

- `flutter analyze` passes.
- Unit tests pass.
- Widget test setup works.
- App shell runs.
- CI commands are documented.
- Security baseline checklist is complete.

---

## Phase 1 — Design System and App Experience Shell

### Goal

Build the reusable UI foundation before business features.

### Main Deliverables

- App theme.
- Cupertino-first navigation shell.
- Shopper tab placeholder.
- Traveler tab placeholder.
- Activity tab placeholder.
- Profile tab placeholder.
- Reusable UI components.
- Design system demo screen.

### Key Components

- `BringlyButton`
- `BringlyCard`
- `BringlyTextField`
- `TrustBadge`
- `StatusChip`
- `PriceBreakdownCard`
- `TravelerCard`
- `RequestCard`
- `EvidenceTile`
- `VerificationStatusBanner`
- `CupertinoBottomActionSheet`
- Loading, empty, blocked, and error screens.

### UX Requirements

- iOS-first feel.
- Clean marketplace cards.
- Strong call-to-action hierarchy.
- Trust indicators.
- High whitespace.
- Accessible text scaling.
- Clear status visibility.

### Completion Criteria

- Core components are implemented.
- Components have widget tests.
- Components support loading, disabled, error, and normal states.
- Components contain no business logic.

---

## Phase 2 — Authentication and User Profile

### Goal

Allow users to register, log in, restore sessions, log out, and manage basic profile information.

### Main Deliverables

- Onboarding flow.
- Register screen.
- Login screen.
- Session restoration.
- Logout.
- Profile summary.
- Role selection: shopper, traveler, or both.
- Verification status display.
- Suspended account handling.

### Functional Requirements

- User can register.
- User can log in.
- User can log out.
- Session persists after app restart.
- Expired session is handled safely.
- User can see role and verification state.
- Marketplace actions are blocked if verification is incomplete.

### Security Requirements

- Tokens stored only in secure storage.
- Tokens never logged.
- Raw backend errors are not exposed directly to users.
- Backend remains source of truth for account status.
- Forced logout works when the backend suspends the account.

### Completion Criteria

- Auth flow works in mocked or integrated environment.
- Logout clears secure storage.
- Expired session flow is tested.
- Blocked account state is tested.

---

## Phase 3 — Identity Verification and Trust Layer

### Goal

Implement user verification screens and evidence upload flows.

### Main Deliverables

- Verification overview screen.
- Phone verification status.
- Email verification status.
- Government ID status.
- Selfie/liveness status.
- Payment/payout readiness status.
- Traveler eligibility status.
- Signed document upload flow.
- Submitted, under review, approved, rejected, and resubmit states.

### Functional Requirements

- User can view verification progress.
- User can submit verification documents.
- User can see under-review status.
- User can resubmit after rejection.
- User sees privacy explanation before uploading documents.
- User sees what the other party can and cannot view.

### Security Requirements

- Documents uploaded through backend-issued signed URLs.
- Identity documents are not exposed to other users.
- ID images are not permanently stored on-device.
- Verification status comes only from backend.
- Sensitive filenames and metadata are not logged.

### Completion Criteria

- All verification states are supported.
- Upload failure, retry, cancel, and expired signed URL are handled.
- Widget tests cover all verification statuses.

---

## Phase 4 — Shopper Item Request and Compliance Review

### Goal

Allow shoppers to create item requests and submit them for platform approval.

### Main Deliverables

- Create item request form.
- Draft saving.
- Product link input.
- Product name.
- Origin and destination.
- Quantity.
- Estimated price.
- Estimated size and weight.
- Desired delivery deadline.
- Product image upload or product image URL.
- Request status timeline.
- Rejection and resubmission flow.
- Shopper request list.

### Functional Requirements

- Shopper can create request draft.
- Shopper can submit request for review.
- Shopper can view request status.
- Shopper can edit draft.
- Rejected requests show clear explanation.
- Approved requests can become visible for matching.

### Compliance Requirements

- Allowed, restricted, and rejected item states are supported.
- Prohibited categories are blocked.
- Restricted categories require manual review.
- Shopper confirms customs responsibility notice.
- Shopper confirms item authenticity notice.
- Shopper confirms no prohibited goods.

### Security Requirements

- Backend determines item compliance status.
- Client validation is only UX assistance.
- Product links are sanitized.
- Uploaded images use signed upload URLs.
- User cannot publish directly without approval.
- Material edits after approval reset review status.

### Completion Criteria

- Request can move from draft to under review.
- Approved request becomes published.
- Rejected request cannot be matched.
- Status timeline is clear.

---

## Phase 5 — Traveler Trip Management

### Goal

Allow travelers to add trips, luggage capacity, preferred categories, and travel proof.

### Main Deliverables

- Add trip form.
- Origin city/country.
- Destination city/country.
- Departure date/time.
- Arrival date/time.
- Available luggage weight.
- Available luggage volume.
- Preferred item categories.
- Travel proof upload.
- Trip status timeline.
- Active, pending, completed, and cancelled trip lists.

### Functional Requirements

- Traveler can create trip.
- Traveler can upload travel proof.
- Traveler can edit trip before verification.
- Traveler can cancel trip.
- Traveler can view matching eligibility.
- Verified trips can receive matches.

### Security Requirements

- Travel proof is uploaded through signed URLs.
- Travel documents are not visible to shoppers.
- Backend determines trip verification status.
- Unverified trips cannot receive matches.
- Editing key trip fields resets verification status.
- Cancelled trips cannot accept offers.

### Completion Criteria

- Trip can be submitted for review.
- Trip remains under verification until backend approval.
- Verified trip can receive matches.
- Cancelled and expired trips are excluded from matching.

---

## Phase 6 — Matching and Offer Flow

### Goal

Connect approved shopper requests with verified traveler trips through backend-generated matches.

### Main Deliverables

- Compatible requests screen for travelers.
- Match cards.
- Send offer screen.
- Shopper offer list.
- Accept offer flow.
- Reject offer flow.
- Offer expiration.
- Offer status timeline.

### Functional Requirements

- Traveler sees compatible approved requests.
- Traveler can send offer with reward, expected handover date, and notes.
- Shopper can view offers.
- Shopper can accept one offer.
- Shopper can reject offers.
- Other offers become unavailable after one is accepted.

### Security Requirements

- Backend generates match eligibility.
- Client cannot create unauthorized matches.
- Sensitive traveler data is masked until offer acceptance.
- Sensitive shopper contact data is masked until payment is secured.
- Offer acceptance requires shopper verification and approved request.
- Traveler cannot accept their own shopper request.

### Completion Criteria

- Traveler can send offer only for eligible matches.
- Shopper can accept one offer.
- Accepted offer moves request to offer accepted.
- Unauthorized offer attempts fail safely.

---

## Phase 7 — Payment Protection and Transaction Lifecycle

### Goal

Implement payment state UI and transaction lifecycle visibility. The mobile app does not control payment release or payouts.

### Main Deliverables

- Price breakdown screen.
- Payment authorization screen.
- Payment pending state.
- Payment secured state.
- Payment failed state.
- Refund pending state.
- Refunded state.
- Traveler payout pending state.
- Traveler payout released state.
- Transaction timeline.

### Functional Requirements

- Shopper sees item price.
- Shopper sees traveler reward.
- Shopper sees platform fee.
- Shopper sees payment fee.
- Shopper sees customs/duty buffer if applicable.
- Shopper sees total payable.
- Traveler is not instructed to purchase until payment is secured.

### Security Requirements

- Mobile app does not handle raw card data unless using certified payment provider SDK.
- Mobile app does not decide payment release.
- Backend controls payment status.
- Backend controls payout status.
- Payment status is read-only from mobile perspective.
- Payment provider errors are user-safe.
- No payment data is logged or sent to analytics.

### Completion Criteria

- Payment secured status unlocks purchase workflow.
- Payment failure does not create an active transaction.
- Refund and payout statuses are clear.
- Payment state tampering from client is not possible.

---

## Phase 8 — Purchase Evidence and In-Transit Tracking

### Goal

Allow travelers to upload purchase proof and show safe transaction progress to both parties.

### Main Deliverables

- Purchase pending screen.
- Receipt upload.
- Item photo upload.
- Package photo upload.
- Optional serial number field for eligible categories.
- Evidence review status.
- Purchase confirmed status.
- In-transit status.
- Arrival status.
- Shared timeline.
- Evidence rejection and resubmission flow.

### Functional Requirements

- Traveler uploads required purchase evidence.
- Shopper sees purchase confirmed after backend approval.
- Missing evidence blocks next state.
- Rejected evidence requires resubmission.
- Both parties see transaction progress.

### Security Requirements

- Evidence uploaded through signed URLs.
- Receipts may be masked when shown to shopper.
- Sensitive metadata is removed or ignored.
- Backend determines whether evidence is accepted.
- Traveler cannot move to in transit without required evidence.
- Shopper cannot alter evidence state.

### Completion Criteria

- Required evidence can be uploaded.
- Backend review states are represented.
- Missing or rejected evidence blocks progress.
- Timeline is clear to both parties.

---

## Phase 9 — Delivery Handover with OTP or QR

### Goal

Implement secure delivery confirmation using backend-generated OTP or QR code.

### Main Deliverables

- Handover pending screen.
- Shopper OTP generation.
- Shopper QR generation.
- Traveler OTP entry.
- Traveler QR scan.
- Shopper item received confirmation.
- Traveler item handed-over confirmation.
- Failed OTP handling.
- Code expiration handling.
- Post-delivery rating prompt.

### Functional Requirements

- Shopper generates OTP or QR during physical handover.
- Traveler confirms delivery using OTP or QR.
- OTP expires after configured period.
- OTP is single-use.
- Failed attempts are handled safely.
- Delivery completion triggers payout pending state.

### Security Requirements

- OTP generated by backend.
- OTP cannot be guessed through unlimited attempts.
- QR must not contain sensitive transaction details.
- Backend completes delivery state transition.
- Dispute option remains available during the configured window.

### Completion Criteria

- Delivery cannot complete without valid backend confirmation.
- Invalid or expired OTP fails safely.
- Completed delivery updates both users consistently.
- Payout pending status appears after successful delivery.

---

## Phase 10 — Disputes, Ratings, and Support

### Goal

Handle marketplace failure cases such as wrong item, damaged item, missing item, late delivery, and handover conflict.

### Main Deliverables

- Open dispute flow.
- Dispute reason selection.
- Dispute explanation field.
- Dispute evidence upload.
- Dispute timeline.
- Admin review pending state.
- Resolution state.
- Refund/payout status visibility.
- Shopper rating flow.
- Traveler rating flow.
- Support contact screen.

### Dispute Reasons

- Traveler did not buy item.
- Wrong item.
- Damaged item.
- Missing item.
- Late delivery.
- Shopper did not appear.
- Traveler claims delivery but shopper denies.
- Customs issue.
- Other.

### Security Requirements

- Dispute freezes payout where applicable.
- Dispute evidence uses signed upload URLs.
- Users cannot edit submitted evidence after review starts unless admin allows it.
- Ratings are only allowed after completed eligible transactions.
- Users cannot rate themselves.
- Backend controls dispute outcome.

### Completion Criteria

- Dispute can be opened only during allowed states.
- Payout release is blocked while dispute is active.
- Resolution state is clear.
- Ratings cannot be submitted before delivery completion.

---

## Phase 11 — Notifications and Activity Center

### Goal

Keep users informed about verification, requests, offers, payments, evidence, delivery, disputes, and payouts.

### Main Deliverables

- Activity center.
- Push notification permission flow.
- In-app notification list.
- Mark as read.
- Notification deep links.
- Notification preferences.
- Critical transaction alerts.

### Functional Requirements

- User receives important transaction updates.
- User can open notification and land on the correct screen.
- User can manage notification preferences.
- User can view unread and read notifications.

### Security Requirements

- Push content must not expose sensitive item, payment, identity, or travel document data.
- Deep links must re-check authorization.
- Notifications must not reveal private information on locked screen.
- Backend controls notification generation.

### Completion Criteria

- Notification deep links work safely.
- Unauthorized deep links fail safely.
- Sensitive notifications use generic wording.
- Activity center reflects transaction updates accurately.

---

## Phase 12 — Security Hardening, QA, and Beta Release

### Goal

Prepare the MVP for a controlled beta release on one corridor with approved items and verified users.

### Main Deliverables

- Critical flow integration tests.
- Manual QA checklist.
- Security checklist.
- Release readiness checklist.
- Staging build.
- Production build configuration.
- TestFlight or beta distribution preparation.
- MVP beta release notes.

### Critical Flows to Test

- Shopper creates item request.
- Item request is approved.
- Traveler creates trip.
- Trip is verified.
- Traveler sends offer.
- Shopper accepts offer.
- Shopper pays.
- Payment becomes secured.
- Traveler uploads evidence.
- Evidence is approved.
- Item enters in-transit status.
- Arrival is confirmed.
- Delivery is completed by OTP or QR.
- Rating is submitted.
- Dispute path is tested separately.

### Security Test Areas

- No hardcoded secrets.
- No sensitive logs.
- No sensitive analytics events.
- Token lifecycle.
- Forced logout.
- Suspended account state.
- Unauthorized deep links.
- File upload abuse cases.
- Payment state tampering.
- OTP brute-force protection.
- Evidence access control.
- Verification status manipulation.

### Completion Criteria

- All automated tests pass.
- Manual QA checklist is complete.
- Security checklist is complete.
- No known critical or high vulnerabilities remain open.
- Staging build is validated.
- Beta release notes are ready.

---

# Recommended Branching Strategy

```text
main
develop
phase-00-foundation
phase-01-design-system
phase-02-auth-profile
phase-03-verification
phase-04-shopper-requests
phase-05-traveler-trips
phase-06-matching-offers
phase-07-payments
phase-08-evidence-tracking
phase-09-delivery-handover
phase-10-disputes-ratings
phase-11-notifications
phase-12-hardening-beta
```

---

# Recommended Spec Folder Structure

```text
specs/
  000-constitution/
    constitution.md
  001-foundation-security-baseline/
    spec.md
    plan.md
    tasks.md
    checklists/
      security.md
      qa.md
  002-design-system-app-shell/
    spec.md
    plan.md
    tasks.md
    checklists/
      security.md
      qa.md
  003-auth-profile/
    spec.md
    plan.md
    tasks.md
    checklists/
      security.md
      qa.md
```

Continue the same pattern for all phases.

---

# Codex Implementation Rules

Add these rules to `AGENTS.md` or the Codex project instructions.

```text
You are building Bringly, a security-first Flutter marketplace app.

Non-negotiable rules:

1. Never add hardcoded secrets, API keys, tokens, private keys, passwords, or payment credentials.
2. Never store sensitive identity documents, receipts, payment details, or travel documents in normal local storage.
3. Use secure storage only for small sensitive values such as auth tokens.
4. Never log PII, tokens, documents, receipts, payment data, or internal risk scores.
5. Never make authorization decisions only in the Flutter app.
6. Backend API is the source of truth for user status, verification status, item approval, payment status, delivery status, dispute status, and payout status.
7. All file uploads must use backend-issued signed upload URLs.
8. All critical state transitions must call backend APIs.
9. Every feature must include tests for success, failure, unauthorized, loading, empty, and edge states.
10. Any generated code that violates these rules must be rejected and redesigned.
```

---

# MVP Release Boundary

| Area | MVP Decision |
|---|---|
| Auth and profile | Include |
| Identity verification UI | Include |
| Shopper item requests | Include |
| Item approval status | Include |
| Traveler trip creation | Include |
| Trip verification status | Include |
| Matching and offers | Include |
| Payment protection UI | Include |
| Evidence upload | Include |
| OTP or QR handover | Include |
| Disputes | Include |
| Ratings | Include |
| Notifications | Include |
| Advanced AI matching | Exclude |
| Fully automated compliance | Exclude |
| Global route expansion | Exclude |
| High-risk item categories | Exclude |
| In-app admin dashboard | Exclude |
| Real escrow claims | Exclude until legal/payment review |

---

# Final Implementation Order

```text
0. Constitution, foundation, and security baseline
1. Design system and app experience shell
2. Authentication and user profile
3. Identity verification and trust layer
4. Shopper item request and compliance review
5. Traveler trip management
6. Matching and offer flow
7. Payment protection and transaction lifecycle
8. Purchase evidence and in-transit tracking
9. Delivery handover with OTP or QR
10. Disputes, ratings, and support
11. Notifications and activity center
12. Security hardening, QA, and beta release
```

This order prevents the team from building matching or payment flows before the trust, verification, compliance, and transaction-state foundations are ready.
