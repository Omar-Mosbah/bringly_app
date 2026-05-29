# Figma Component Reference

This document records how Bringly can use the community Figma file
`iOS 26 Interface Builder: Quick Start Your iOS Project` as a visual and
interaction reference for the Phase 1 design system.

## Source File

- Figma file key: `Hwjqrq4tBBw4lr2ZJb2Fg3`
- Shared URL:
  `https://www.figma.com/design/Hwjqrq4tBBw4lr2ZJb2Fg3/iOS-26-Interface-Builder--Quick-Start-Your-iOS-Project--Community-?node-id=15-0`

## How Bringly Should Use It

- Use it as a component reference, not a direct product design source of truth.
- Prefer Bringly tokens, copy, trust cues, and marketplace-specific states over
  literal visual duplication.
- Keep Cupertino-first interaction patterns where they support the existing app
  shell and mobile UX goals.
- Do not inherit unrelated template content, placeholder marketing layouts, or
  non-marketplace flows from the community kit.

## High-Value Reference Areas

### Native Components

- Page: `1. Native Components`
- Page node: `15:0`
- Useful for:
  - tab bar proportions and icon rhythm
  - top and bottom toolbar spacing
  - text field shell treatment
  - action sheet and context menu structure
  - alert hierarchy and overlay behavior

### Permission Alerts

- Page: `⤷ 1.1. Permission Alerts`
- Useful for:
  - Bringly blocked and gated states
  - trust-oriented messaging patterns
  - Face ID and passkey prompt styling references for future auth work

### Extended Components

- Page: `⤷ 1.2. Extended Components`
- Useful for:
  - cards
  - tabs
  - badges
  - empty-state composition
  - text hierarchy

## Bringly Mapping

| Bringly area | Current code | Figma reference |
|---|---|---|
| App shell tab bar | `lib/design_system/layouts/marketplace_shell_scaffold.dart` | `Tab Bar` on `1. Native Components` |
| Primary button treatment | `lib/design_system/components/bringly_button.dart` | `Button` component set on `1. Native Components` |
| Text field shell | `lib/design_system/components/bringly_text_field.dart` | `Text Field` on `1. Native Components` and `⤷ 1.2. Extended Components` |
| Cards and list rows | `lib/design_system/components/bringly_card.dart`, `request_card.dart`, `traveler_card.dart` | `Cards`, `Table View Raw`, `Table Header`, `Table Footer` |
| Status and trust badges | `status_chip.dart`, `trust_badge.dart`, `verification_status_banner.dart` | `Badges` and alert patterns from `⤷ 1.2. Extended Components` and `⤷ 1.1. Permission Alerts` |
| Empty and blocked states | `bringly_state_view.dart`, `baseline_state_view.dart` | `Empty State` and permission alert layouts |
| Sheets and destructive choice UI | `cupertino_bottom_action_sheet.dart` | `Action Sheet`, `Context Menu`, `Overlay` |

## Adaptation Rules

- Keep Bringly colors from `lib/design_system/tokens/bringly_colors.dart` as
  the source of truth unless we intentionally revise tokens.
- Keep all new widgets inside `lib/design_system/` or the relevant
  `lib/features/.../presentation/` area following Clean Architecture.
- Match native spacing, density, and hierarchy from the kit where it improves
  clarity, but preserve Bringly branding and security-first copy.
- If the Figma kit and product requirements disagree, product requirements and
  Bringly specs win.

## Recommended Next Uses

1. Refine `BringlyButton` with a more native height, radius, and pressed-state
   treatment inspired by the Figma `Button` set.
2. Refine `BringlyTextField` with stronger label, helper, and error hierarchy
   using the Figma text field shells.
3. Refresh shell navigation visuals in
   `marketplace_shell_scaffold.dart` using the `Tab Bar` reference.
4. Use the alert and empty-state references when expanding blocked, loading,
   and unauthorized views across features.
