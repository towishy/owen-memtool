---
schema_version: 1
reference_study: true
output_job: "show one operational rate against an explicit target and nearby actions"
surface: "compact analytics instrument, benchmark widget, telemetry summary"
evidence: ["public Threads UI motion reference by disarto.digital", "independent white UI Lab transfer specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "motion", "interaction"]
unresolved_axes: ["imagery"]
allowed_range: "One primary percentage, one explicit target marker, up to three supporting values, and a small set of contextual commands on a white neutral instrument surface."
counterexample: "Do not turn every dashboard card into an instrument, hide state behind color, use decorative fake telemetry, or copy the reference's dark trade dress and wording."
transfer_specimen: "lib/ui-lab/src/white-instrument-study.tsx"
---

# Reference Study: White Instrument

## Source pattern

The public Threads reference presents a compact opt-in-rate widget with one large percentage, a reporting-period selector, an explicit target on a segmented gauge, benchmark context, and a nearby action disclosure. The reference is dark and highly stylized; no source code, product copy, exact dimensions, or distinctive visual assets were copied.

## Decision

The transferable value is the relationship between metric, target, evidence, and commands. Owen UI Foundation implements that relationship in a white cool-neutral profile:

- one primary metric uses tabular numerals;
- the segmented gauge retains an exact `progressbar` value;
- an optional target marker is visible and repeated in `aria-valuetext`;
- status says `Above target` or `Below target` instead of relying on green or orange alone;
- period and product-specific commands remain consumer-owned controls;
- header actions are an explicit slot with density-appropriate targets;
- supporting values are capped at three to keep the main decision signal dominant.

The default light canvas is white/cool-neutral rather than OLED black or warm beige. Green is reserved for successful target attainment, while borders and neutral text establish most of the hierarchy.

## Interaction contract

| Control | Required behavior |
| --- | --- |
| Reporting period | Changes the real displayed value and resets temporary refresh state |
| Target action | Updates both visible target and progressbar `aria-valuetext` |
| Refresh | Changes data only after an explicit user action and announces completion |
| Export CSV | Creates an actual downloadable CSV rather than showing a decorative success message |
| Copy link | Reports success only after a clipboard write succeeds |
| Expand | Changes panel width without delaying keyboard state |
| Close | Removes the instrument but leaves a restore command |

Action disclosure uses native `details`/`summary` semantics in the Lab composition. If a production app needs collision-aware positioning, roving focus, nested items, or submenus, it should promote the command surface to an approved Base UI menu primitive rather than extending the Lab disclosure.

## Visual decisions

- Use a white translucent header/footer over a `#f7f9fb` instrument canvas.
- Use a cool neutral border around the framed tool; do not add a left accent rail.
- Keep radius at the Foundation 8px panel token.
- Use the dot or grid motif only inside telemetry instruments, never as a page-wide decoration.
- Keep controls input-appropriate even when the panel becomes narrow.
- Use one green signal for target attainment and neutral fills for unfilled gauge segments.
- Preserve a single focal metric; supporting values stay smaller and quieter.

## Motion contract

- Width expansion may use the Foundation 200ms ease-out transition.
- Period, target, and keyboard state update immediately.
- Reduced-motion mode removes the width transition.
- Do not animate segmented progress on initial load or loop fake telemetry.

## Accessibility contract

- `progressbar` exposes exact value, minimum, maximum, and target context.
- Icon-only expand and close actions have accessible names and input-appropriate targets.
- Status includes text in addition to semantic color.
- Feedback uses a polite live region.
- Native select and disclosure remain keyboard operable.
- Desktop and mobile specimens must pass axe and horizontal-overflow checks.

## Foundation mapping

| Pattern | Owner |
| --- | --- |
| Metric, segmented progress, target marker, header action slot | `InstrumentPanel` |
| Icon command | `ActionButton` |
| Reporting period and command contents | consuming app or mockup |
| White responsive transfer specimen | `WhiteInstrumentStudy` |

The executable specimen and browser checks live in `../ui-lab/src/white-instrument-study.tsx` and `../ui-lab/tests/ui-lab.spec.ts`.
