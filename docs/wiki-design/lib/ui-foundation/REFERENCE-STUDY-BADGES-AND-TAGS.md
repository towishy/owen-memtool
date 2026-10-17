---
schema_version: 1
reference_study: true
output_job: "distinguish reference status, unread counts, selectable filters and removable tags"
surface: "State language UI Lab reference review specimen"
evidence: ["official Shields, shadcn, Flowbite, Badgen and HyperUI documentation reviewed 2026-09-06", "local StatusBadge source", "integrated browser presentation 2026-09-06"]
confidence: medium
axes_covered: ["color", "spacing", "radius", "borders", "layout", "hierarchy", "iconography", "interaction"]
unresolved_axes: ["typography", "shadows", "imagery", "motion"]
allowed_range: "Reuse existing StatusBadge for noninteractive state; compose native buttons and links for app-owned filters, tags and commands."
counterexample: "Do not turn a styled span into a button, treat a cached badge as live evidence, or install a second component library solely for badges."
transfer_specimen: "lib/ui-lab/src/badge-tag-study.tsx"
---

# Badges And Tags

## Sources

- [Shields](https://shields.io/) and [endpoint contract](https://shields.io/badges/endpoint-badge)
- [shadcn Badge](https://ui.shadcn.com/docs/components/badge)
- [Flowbite Badge](https://flowbite.com/docs/components/badge/)
- [Badgen](https://badgen.net/help)
- [HyperUI Badges](https://www.hyperui.dev/components/application/badges)
- [Source review and rights boundaries](D:/GITHUB/wiki/dev/local-ai-tools-review/2026-09-06-reference-intake-review.md)

## Transfer

Separate label, state, count, link, filter and removal into distinct semantic jobs.
State text remains visible beside a decorative icon. A capped visual count exposes
the real value; zero is explicit. Filter selection changes the actual result set,
not only its color. Removing a tag removes the corresponding filter and restores
focus to the next removal command or the All control. Multiple selected statuses
use OR semantics. Clearing every filter restores all records.

The implementation reuses package-root `StatusBadge` and `ActionButton`, Lab
Clear Glass commands and the isolated preview's existing `FrostedScrollArea`.
No new scroll region, dependency, Foundation primitive or public API was added.
The six reference rows and 128 initial notifications are explicitly sample data,
not a connection to provider services or a live operational review queue.

## Ownership And Presentation

`lib/ui-lab/src/badge-tag-study.tsx` owns bilingual sample copy and state;
`badge-tag-study.css` owns only specimen layout. The existing main Lab and
isolated `state-language` route render the same component while retaining the
original async-state examples. Foundation status-badge source is unchanged.

Implementation approval: user requested "구현 반영해서 보여줘" on 2026-09-06.
Typecheck and editor diagnostics passed. Korean desktop and English narrow
presentation were inspected in the VS Code integrated browser. The English
Adapt selection displayed three rows and its removal tag. Browser DOM inspection
at actual width 310px found no overflowing content, excluding the intentional
one-pixel visually hidden heading. Requested viewport dimensions are not used
as measured evidence because the integrated browser retained its own width.

Post-presentation follow-up approval: user "후속작업 다 진행해" on 2026-09-06.
Four KO/EN desktop/mobile tests passed filter OR semantics, keyboard selection,
deletion focus recovery, count/reset, light/dark axe and input-appropriate target checks.
Six viewport full-page audits and the consumer typecheck/build passed.
The count uses the status region's accessible name rather than an invalid
generic span label; language commands reuse ActionButton with visible selection.
The existing Foundation scroll specimen passed desktop/mobile drag and axe.
The [intake ledger](D:/GITHUB/wiki/dev/ui-portal-intakes/badge-tag-review/intake.json)
tracks generated Registry and preview evidence separately from runtime checks.

Presentation URL: `http://127.0.0.1:4175/?mode=preview&specimen=state-language&lang=ko`.
The dedicated loopback Vite server leaves the Controller's authentication and
existing services unchanged; retain it while the user reviews this screen.
