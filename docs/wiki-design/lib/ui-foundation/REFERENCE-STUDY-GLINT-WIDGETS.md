---
schema_version: 1
reference_study: true
output_job: "show one compact status, value, or temporal signal inside a contextual glass widget"
surface: "small telemetry, weather, schedule, battery, and activity widgets"
evidence: ["user-provided Glint Glass Widgets reference image", "independent Korean UI Lab transfer specimen"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "motion", "interaction"]
unresolved_axes: ["imagery"]
allowed_range: "One primary value or time signal, one compact decorative instrument, short supporting text, and an optional footer inside an olive or neutral translucent square or wide widget."
counterexample: "Do not apply this material to dense tables, settings bodies, long text, generic page sections, or a full dashboard without opaque work surfaces."
transfer_specimen: "lib/ui-lab/src/glint-widget-study.tsx"
---

# Reference Study: Glint Widgets

## Source pattern

The user-provided reference presents compact square widgets on a subdued green field. The visual language combines translucent olive surfaces, a bright inner rim, broad low-alpha shadow, ivory typography, tabular numerals, small outline icons, orange or yellow signal marks, dot matrices, segmented fills, and radial gauges.

No source code, brand asset, exact text, exact grid, or proprietary widget was copied. The UI Lab specimen uses Korean copy, different data, six widgets, and independent CSS instruments.

## Decision

The transferable pattern is a compact contextual instrument, not a general glass card:

- one primary value, time, or status owns the hierarchy;
- square geometry is preferred, with a wide variant only for short comparative status;
- olive glass is the default reference profile and neutral glass is available for mixed operational surfaces;
- ivory text and icons maintain readable contrast over the tint;
- one semantic signal color highlights a current state, target, or warning;
- dot matrices, segmented fills, and radial ticks stay decorative while the same value remains available as semantic text or native progress state;
- a footer may hold a short forecast or range, never a second nested card.

## Material construction

| Layer | Responsibility |
| --- | --- |
| Context | A restrained image or color field may show through the widget; it must not reduce text contrast. |
| Surface | Two directional translucent fills carry the olive or neutral tint. |
| Rim | A 1px border and top inset highlight define the glass edge. |
| Depth | Broad low-alpha shadow and a quiet lower inset establish elevation without glow. |
| Data substrate | Progress tracks and detailed labels use higher-opacity local surfaces where needed. |
| Signal | Orange is the default warning/current signal; lime is reserved for success; ivory is neutral. |

## Usage contract

- Use `GlintWidget` for small telemetry, weather, schedule, battery, activity, and device-status surfaces.
- Use `InstrumentPanel` when the screen needs a primary metric, explicit target, several supporting stats, and nearby commands.
- Use `GlassFrameWindow` for a non-interactive visual thumbnail without semantic metric content.
- Keep visible copy localized to the product language. The Korean specimen does not expose Japanese labels.
- Consumer-owned custom instruments must repeat their value through text, `progressbar`, `time`, or another native semantic element.
- Do not add controls inside the decorative `visual` slot because that region is intentionally hidden from assistive technology.

## Responsive and accessibility contract

- The square widget keeps stable geometry and never shrinks text or targets to fit a narrow viewport.
- Grids collapse from three columns to two and then one based on container width.
- The visual slot is `aria-hidden`; meaningful values remain in headings, metric text, descriptions, children, or footer content.
- Signal color never carries meaning by itself.
- Forced-colors mode removes blur and shadows and restores Canvas colors and visible borders.
- The component adds no motion; reduced-motion mode therefore requires no alternate animation.

## Foundation mapping

| Pattern | Owner |
| --- | --- |
| Compact glass shell, heading, metric, semantic body, footer | `GlintWidget` |
| Large target-oriented telemetry | `InstrumentPanel` |
| Non-interactive visual frame | `GlassFrameWindow` |
| Responsive Korean transfer specimen | `GlintWidgetStudy` |
