---
schema_version: 1
reference_study: true
output_job: "let a visitor explore a short, fixed-order portfolio or product story through direct manipulation"
surface: "image-led portfolio, product story, limited lookbook, or editorial archive"
evidence: ["MengTo/sketchbook README and index.html at commit c1e477814c4c9e204452ebf9b298aa13629cbfc2 reviewed 2026-08-08", "live desktop interaction and keyboard navigation reviewed at mengto.com", "independent axe, desktop, mobile, overflow, and reduced-motion URL audit captured in dev/temp/ui-audit/mengto-sketchbook"]
confidence: medium
axes_covered: ["layout", "hierarchy", "imagery", "motion", "interaction", "shadows"]
unresolved_axes: ["typography", "color", "spacing", "radius", "borders", "iconography"]
allowed_range: "Use only when a small set of ordered, image-led spreads is the primary content and every page remains reachable by button, keyboard, and index navigation."
counterexample: "Do not use as an operational workspace, long-form reader, dense catalog, primary navigation, or a wrapper around unrelated page sections."
transfer_specimen: "lib/ui-lab/src/physical-book-interaction-study.tsx"
---

# Reference Study: Physical Book Interaction

## Source Pattern

[MengTo/sketchbook](https://github.com/MengTo/sketchbook) presents nine illustrated Singapore spreads as a directly manipulated book. Its value is not the paper palette, botanical decoration, artwork, typefaces, or brass magnifier. The reusable part is the interaction model that keeps pointer movement, page geometry, lighting, and settle behavior in one continuous state transition.

The reviewed repository is a static `index.html` with local artwork and fonts and no build dependency. The repository API reported `license: null`, and neither a root `LICENSE` file nor an explicit software license was present on 2026-08-08. Do not vendor or translate its HTML, CSS, JavaScript, images, fonts, or distinctive trade dress. This study records independently implementable behavior and validation boundaries only.

## Decision

Treat the physical book as an opt-in narrative reference composition, not a Foundation primitive or general navigation pattern. It fits when all of the following are true:

- the collection is small and deliberately ordered;
- each spread carries one image-led message;
- sequence and tactility add meaning beyond a carousel;
- the same destination is available through explicit controls and an index;
- the complete experience can reduce to an immediate, non-spatial state change.

Prefer a normal document, gallery, `FeatureShowcase`, or product workspace when scanning, comparison, search, deep linking, or repeated action matters more than sequence.

## Reusable Interaction Model

### 1. One explicit turn state

Represent a turn as one controlled transition with direction, source page, target page, and normalized progress from 0 to 1. Pointer drag, tap, previous/next commands, keyboard commands, and index jumps must enter the same state machine instead of maintaining separate visual paths.

The stable states are:

1. idle on the current spread;
2. directly tracking a turn;
3. settling toward commit;
4. settling toward cancel;
5. idle on the resulting spread.

New input may finish or retarget the current transition, but must not leave two page turns competing for the same surface.

### 2. Direct manipulation before animation

- Derive progress from pointer displacement relative to the book width.
- Keep the page under 1:1-enough tracking that the surface does not feel detached from the pointer.
- On release, decide commit or cancel from both progress and recent velocity.
- Continue from the current progress and velocity with an interruptible settle; do not restart from a canned keyframe.
- Treat a short movement as a tap command rather than a failed drag.

Thresholds, strip count, curvature, stiffness, and damping are implementation variables to tune against the target size and content. The source values are observations, not Foundation tokens.

### 3. Curved leaf, not a flat door

A convincing page needs widthwise deformation. Approximate the leaf with a bounded strip chain or another measured mesh whose tangent changes across the page. Each segment needs front and back content ownership, hidden backfaces where appropriate, and stable texture mapping throughout the turn.

Curvature should be zero at both endpoints and peak near the middle of the transition. This makes the page rest flat before and after the turn. A single `rotateY()` panel is acceptable only for an intentionally graphic card flip, not for a paper claim.

### 4. Lighting follows geometry

- Tie cast shadow, fold shade, and specular response to turn progress and local surface angle.
- Keep shadows soft and bounded to the physical relationship between raised leaf, gutter, and page below.
- Remove the turning layer after settle so idle pages do not retain unnecessary transformed DOM.
- Avoid animated blur and large filter stacks unless profiling shows a stable frame budget.

Texture and lighting support the geometry; they cannot rescue incorrect clipping, front/back mapping, or turn direction.

### 5. Independent coordinate spaces for physical props

An optional prop such as a magnifier should have a reason to exist. If used, keep it in the untransformed stage coordinate space and render magnified content from a synchronized copy or dedicated sampling layer. The prop should not inherit book parallax, and its sampled content must fade or clip when the lens leaves the valid page region.

Resolve collisions explicitly. A turning page may move the prop to a safe resting point, but the motion must be cancelable and must not begin another page gesture. On coarse pointers, remove a cursor-dependent prop instead of exposing an unusable imitation.

The magnifier is not required by this composition. Product detail can use a conventional zoom dialog, native image viewer, or no zoom at all.

## Input And Accessibility Contract

- Provide visible previous and next buttons with accessible names.
- Support Arrow Left and Arrow Right without intercepting editable fields or modified shortcuts.
- Provide an index that identifies the current page and jumps directly to every spread.
- Preserve vertical document scrolling with an appropriate `touch-action`; horizontal book gestures must not trap the page.
- On coarse pointer or touch, use tap/buttons/index as the reliable path and remove hover-only or cursor-dependent features.
- Under `prefers-reduced-motion` or a product motion override, skip opening sequences, parallax, rotation, and spring travel. Commit the semantic page state immediately.
- Announce the current title and position after settle, for example “3 of 9, Product detail,” without narrating intermediate animation frames.
- Keep labels, page metadata, and index text at WCAG AA contrast. Decorative faint ink is not a reason to reduce functional text contrast.
- The experience must remain complete at 200% zoom and narrow widths without horizontal document overflow.

Autoplay is not the default. An opening riffle may be offered only as a short, nonessential, once-per-session introduction with skip/pause behavior and a complete static first state. Do not delay access to the first spread while assets animate.

## Content And Responsive Contract

- Use a stable spread aspect ratio and reserve its dimensions before assets decode.
- Preload only the bounded set needed for a seamless first interaction; expose a static poster and usable controls while remaining assets load.
- Keep one focal subject per spread and define mobile-safe crops or alternate single-page assets.
- Scale the stage inside the viewport; never rely on `overflow-x: hidden` to conceal an oversized interactive canvas.
- Reduce decorative props before shrinking readable content or input-appropriate controls.
- Keep captions outside the moving texture so labels remain readable during and after the turn.
- Preserve direct URLs or an equivalent index path when individual works need sharing or search discovery.

## Observed Gaps To Avoid

The live reference was audited rather than treated as an automatic quality baseline. The 2026-08-08 audit found:

- a serious color-contrast violation across small section labels and plate metadata, with several measured near 2.05:1;
- horizontal overflow at 320, 375, 414, and 768px viewports;
- wrapped plate labels at the narrowest widths;
- no console, failed-resource, or broken-image errors in the audited states.

These are source observations, not accepted Foundation behavior. An independent implementation must pass axe, intrinsic stage overflow checks, keyboard navigation, coarse-pointer behavior, reduced motion, and page announcement checks before adoption.

## Foundation Mapping

| Need | Owner |
| --- | --- |
| Portfolio or product narrative shell | consuming app; reference composition only |
| Previous, next, zoom, and index commands | native buttons or `ActionButton` where its visual contract fits |
| Turn state and gesture arbitration | consuming app state machine |
| Curved page renderer | consuming app CSS strip chain, canvas, or proven rendering engine |
| Current-page announcement | app-owned live status tied to settled semantic state |
| Long index overflow | `FrostedScrollArea` only when the index becomes a bounded vertical panel |
| Reduced motion | immediate final-state path plus CSS media-query defense |

Do not export `Book`, `PageTurn`, or `Flipbook` from the Foundation package until two independent Owen products need the same state model and both pass desktop, mobile, keyboard, axe, reduced-motion, visual regression, and performance validation.

## Validation Checklist

- Drag slowly, release before and after the commit boundary, and fling in both directions.
- Interrupt settle with a new command and verify one coherent final page.
- Compare front and back artwork, gutter clipping, shadow direction, and caption timing at progress 0, 0.25, 0.5, 0.75, and 1.
- Navigate every spread with buttons, keyboard, and index.
- Verify current title and page position with a screen reader after settle.
- Test 320, 375, 414, 768, 1280, and 1440px widths, 200% zoom, and intrinsic stage bounds.
- Test coarse pointer, hover/fine pointer, reduced motion, asset failure, slow decode, and font fallback.
- Profile drag frames and confirm that geometry and lighting do not create sustained long tasks or visible dropped frames.
- Run axe and confirm functional text reaches WCAG AA contrast.

## Sources

- [MengTo/sketchbook](https://github.com/MengTo/sketchbook)
- [README at reviewed commit](https://github.com/MengTo/sketchbook/blob/c1e477814c4c9e204452ebf9b298aa13629cbfc2/README.md)
- [Implementation at reviewed commit](https://github.com/MengTo/sketchbook/blob/c1e477814c4c9e204452ebf9b298aa13629cbfc2/index.html)
- [Live site](https://mengto.com)
