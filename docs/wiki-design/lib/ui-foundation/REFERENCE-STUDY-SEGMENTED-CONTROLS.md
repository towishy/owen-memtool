---
schema_version: 1
reference_study: true
output_job: "choose one or more closely related peer options for the same object, mode or view"
surface: "compact segmented selection control on an opaque or restrained Clear interaction surface"
evidence: ["public Threads post @heinhtoohtookyaw/Dd6Sp7RlPo9 reviewed 2026-10-01", "four static Weekday Design Dictionary image cards", "existing Owen capsule-track, Clear controls and shadcn ToggleGroup owners"]
confidence: medium
axes_covered: ["typography", "spacing", "radius", "layout", "hierarchy", "iconography", "interaction"]
unresolved_axes: ["color", "borders", "shadows", "imagery", "motion"]
allowed_range: "Use for 2-5 peer choices by default. On a sufficiently wide surface, 6-7 short choices may remain segmented when every segment keeps equal width, consistent content anatomy, legible labels and the required target size."
counterexample: "Do not use for unrelated commands, long or strongly unequal labels, deep navigation, more options than fit without compression, or as a visual substitute for radio, tab and toggle semantics."
transfer_specimen: "lib/ui-lab/src/glass-control-study.tsx"
preview_url: "/repo/dev/ui-portal-intakes/threads-segmented-controls/presentation-reference-study.png"
---

# Segmented Controls Reference Study

## Source And Rights

- [Threads share URL](https://www.threads.com/share/BBhaFOqTkb/)
- [Canonical public post](https://www.threads.com/@heinhtoohtookyaw/post/Dd6Sp7RlPo9)
- Author: `@heinhtoohtookyaw`
- Series: `Day 23 - Segmented Controls / The Weekday Design Dictionary`

The public post was reviewed as untrusted visual evidence. No reusable license was identified. Source images, typography, icons, copy, gradient treatment, dotted stages and exact dimensions are not stored or redistributed in Foundation.

## Visible Evidence

The four static cards make four claims:

1. A segmented control is a linear set of two or more closely related choices for the same object or view.
2. Sibling segments should have equal widths; labels should be shortened when one segment would otherwise dominate.
3. A group should use one content format instead of mixing icon-only and text-only segments.
4. Wider screens can hold about five to seven segments, while the illustrated iPhone example should use no more than five.

The examples use short labels, one horizontal row, an opaque neutral track and a lighter selected segment. They do not demonstrate runtime semantics, localization, keyboard behavior, focus, forced colors, motion or a responsive fallback.

## Foundation Decision

Adopt the relationship and capacity rules, not the source's visual presentation.

- A segmented control represents peer options at one conceptual level. It is not a container for unrelated commands.
- Use 2-5 segments by default. Permit 6-7 only when the available inline size, label length and target contract have been measured on a wide surface.
- Give segments equal shares when their labels fit legibly. If equal shares cause truncation, target reduction or ambiguous abbreviations, use a different control instead of preserving the segmented silhouette.
- Keep one content anatomy across siblings: all text, all icon-only, or all icon-plus-text. Icon-only segments require distinct accessible names and designed help where the symbol is not universally understood.
- Preserve the semantic owner. A visual track does not erase the distinction between a form radio group, view tabs and a single- or multi-select toggle group.

The source's iPhone limit is treated as a bounded observation rather than a universal device breakpoint. Owen uses the more conservative 2-5 default across narrow surfaces and evaluates the 6-7 exception by actual container capacity.

## Semantic Router

| Selection job | Owner | Required state |
| --- | --- | --- |
| Choose one form value | native radio group or the owning form control | checked value, label, description and error relationships |
| Switch among panels in one view | tabs | selected tab and associated tab panel |
| Toggle one or more peer states | button or ToggleGroup | explicit pressed state and single/multiple selection policy |
| Choose from a long, dynamic or localized list | Select, Combobox, menu or another task-specific owner | do not compress the list into segments |

Visual sameness is not a reason to substitute one semantic owner for another.

## Responsive And Localization Contract

- Measure localized labels, including the longer supported locale, before accepting the control.
- Do not shrink text, reduce targets, hide options, mix abbreviations with full labels or allow uneven widths to keep one row.
- A segment group should not wrap into a visually ambiguous multi-row pill. Move the responsibility to a task-appropriate control or layout.
- Keep all options discoverable without horizontal scrolling when the control is used for primary mode or form selection.
- If an icon-plus-text format is selected, every sibling reserves the same icon and label slots even when a particular label is shorter.

## Relationship To Existing Owen Owners

- `vibe:features-tabbed-feature-switcher` remains the preferred visual reference for a content-width capsule track.
- `lab:glass-controls` remains the Clear interaction-material specimen; this study does not promote it to a new public Foundation component.
- shadcn ToggleGroup remains a source-grounded anatomy reference where toggle semantics are correct.
- Native radios and tabs retain their own semantics even when styled as a segmented track.

This study adds capacity, equal-share and content-anatomy rules. It does not change the existing 44px target, capsule edge spacing, opaque content-surface or narrow reflow contracts.

## Do Not Adopt

- The source gradient, dotted canvas, oversized presentation card, typography, icons or exact geometry
- Red and green approval markers as a product-state pattern
- Unequal segment widths driven by label length
- Mixed icon-only and text-only siblings
- Device-name checks in place of container measurement
- A universal segmented component that obscures radio, tab or toggle semantics

## Validation Boundary

This approved change registers documentation and AI routing only. It does not modify the existing Lab specimen, create an original-runtime replica, claim source fidelity, or validate a product implementation. A future component change must show Korean and English labels, wide and narrow capacity, keyboard semantics, accessible names, target size, forced colors and overflow in the actual owner.
