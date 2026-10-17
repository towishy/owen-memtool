# better-* skills adoption boundary

Source: [jakubkrehel/skills](https://github.com/jakubkrehel/skills)
Commit: d01493b0a7b976a74bfcedc80c783d60c7995910
License: MIT
Reviewed: 2026-08-11

The upstream source was reviewed as advisory knowledge, not installed as a second design system.

## Adopted

- Resolve review scope before judging and state excluded surfaces.
- Route findings through owning domains: accessibility, layout, writing, typography, color, and visual polish.
- Require source or rendered evidence; do not infer runtime defects from code or screenshots alone.
- Expand change scope one consumer hop by default and cap review breadth when full coverage is not credible.
- For change-scoped reviews, record exact base/head refs, excluded generated files, and expanded surfaces.
- Inspect removed lines for lost labels, semantics, responsive rules, reduced-motion branches, and token usage.
- Classify change-scoped findings as `Introduced`, `Regression`, or `Pre-existing`; keep pre-existing findings separate from the change verdict.
- Keep review read-only unless implementation is explicitly requested.

## Not adopted

- Upstream visible focus-ring requirements conflict with the repository's explicit no-focus-rim contract. Owen UI Foundation remains authoritative and requires keyboard semantics plus non-focus-only state clarity without outline, ring, colored border, lift, or shadow.
- Generic spacing, color, radius, typography, and motion defaults do not override Foundation tokens or specimen contracts.
- Separate design manifests, hooks, or parallel skills were not installed.

## Evidence boundary

- The repository is documentation-only and does not provide executable browser, axe, keyboard, viewport, or screenshot validation.
- The related `interfaces.dev` site is editorial reference, not a conformance baseline. A 2026-08-11 audit of the home page and one free issue reproduced accessible-name, label, contrast, and narrow-viewport overflow defects.
- The repository MIT license does not establish reuse rights for paid magazine content, demo assets, or distinctive site presentation.
- Detailed review: [[interfaces-dev-skills-adoption-review]].
