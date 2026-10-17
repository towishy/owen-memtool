# UI Quality Audit Rubric

Use this rubric after executable browser checks. A manual observation is not a test result, and a numerical summary is never an automated gate.

## Blocking Findings

- A primary workflow cannot be completed by keyboard or loses focus after a modal, menu, or popover closes.
- A control has no accessible name, visible focus state, disabled semantics, or error association.
- Text, icons, or focus indicators fail the applicable contrast threshold.
- Content overlaps, clips, or becomes unreachable at supported viewport widths.
- Motion ignores `prefers-reduced-motion`, cannot be paused when required, or obscures state.
- UI copy presents invented proof, metrics, customers, testimonials, or capabilities as facts.

## High-Confidence Design Findings

- Information hierarchy does not reveal the primary task and current state within a quick scan.
- Repeated cards, nested cards, decorative pills, oversized headings, or equal-weight sections weaken operational scanning.
- Navigation, footer, or hero structure is generic and mismatched to the product's actual number of destinations or actions.
- Hover, focus, active, disabled, loading, error, success, empty, and offline states required by the component's behavior are absent or visually ambiguous.
- Decorative assets compete with the real product, data, workflow, or evidence the user needs to inspect.
- One-off color, spacing, radius, typography, icon, elevation, or motion values bypass an established token or component contract without a local reason.
- Different parts of the screen disagree on radius, spacing rhythm, surface depth, type roles, icon family, color roles, or motion personality.
- No single element establishes the primary task, or secondary actions visually compete with the main action.
- A reference-derived rule has no evidence, confidence, allowed range, counterexample, or transfer check on a specimen absent from the source set.
- Clickable labels wrap, hit targets shift between states, or state changes alter border width and move layout.
- Multiple icon families, fake browser or device chrome, or unsupported stock imagery create an inconsistent visual language.

## Recommendations, Not Universal Rules

Judge these in context and do not fail a design solely for them:

- Italic headings, pure white or black, neutral gray, gradients, centered heroes, serif or system fonts.
- A strict 4 px spacing scale, OKLCH-only colors, fixed accent-area percentages, or a fixed number of font families.
- A universal one-accent rule when the product has stable semantic or categorical color roles.
- Theme rotation, macrostructure rotation, mandatory CSS stamps, project-memory logs, or automatic token export.
- A requirement that every component display eight states when some states do not exist in its product contract.
- A fixed `80/100` pass threshold produced by an LLM without executable evidence and repeated calibration.

## Review Output

For each finding include:

- Severity: blocker, high, medium, or recommendation.
- Evidence: executable report field, screenshot, DOM behavior, or file reference.
- User impact: what task, audience, or viewport is affected.
- Repair: the smallest change compatible with the existing design system.
- Confidence: high for reproduced behavior, medium or low for aesthetic inference.

End with executable gates run, viewport coverage, warnings requiring visual confirmation, and residual risk.