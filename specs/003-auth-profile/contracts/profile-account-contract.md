# Contract: Profile and Account Status

## Purpose

Define the Phase 2 contract for loading and updating safe profile data while
keeping account status, verification, role eligibility, and restrictions
backend authoritative.

## Operations

### Load Profile Summary

**Input**:

- Current authenticated session

**Success result**:

- Display name
- Avatar reference or placeholder
- Country/city
- Preferred language
- Marketplace role
- Email confirmation status
- Verification status
- Account restriction
- Safe next-step guidance for blocked states

**Failure result**:

- Loading
- Empty profile
- Unauthorized
- Suspended/blocked
- Offline/service unavailable
- Safe unknown failure

**Rules**:

- Raw account identifiers, internal risk scores, policy details, and operational
  notes are not exposed to UI, logs, or analytics.
- Email confirmation, verification, restriction, and eligibility status are
  read-only from the mobile app perspective.

### Update Basic Profile

**Input**:

- Display name
- Avatar reference
- Country/city
- Preferred language

**Success result**:

- Updated profile summary

**Failure result**:

- Invalid display name
- Invalid avatar reference
- Invalid country/city
- Unsupported language
- Unauthorized
- Suspended/blocked
- Offline/service unavailable
- Safe unknown failure

**Rules**:

- Legal name, address, phone verification, government ID, liveness, payment, and
  travel details are out of scope.
- Avatar upload, if added, must use a safe backend-controlled upload policy and
  must not store sensitive files in normal local storage.

### Update Marketplace Role

**Input**:

- Shopper, traveler, or both

**Success result**:

- Updated role and refreshed eligibility/status summary

**Failure result**:

- Role unavailable
- Backend rejected eligibility
- Unauthorized
- Suspended/blocked
- Offline/service unavailable
- Safe unknown failure

**Rules**:

- Role selection does not grant protected marketplace access by itself.
- Protected access still requires backend confirmation, required verification,
  and active account status.

## Protected Marketplace Gate

Protected marketplace actions remain blocked when any of the following are
true:

- No valid authenticated session
- Local app unlock has not succeeded
- Email confirmation is pending, expired, or unavailable
- Required verification is incomplete, rejected, blocked, under review, or
  unavailable
- Account is suspended or blocked
- Backend indicates forced logout
- Backend eligibility rejects the requested role/action
