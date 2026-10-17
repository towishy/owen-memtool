---
schema_version: 1
reference_study: true
output_job: "show current weather as readable data beside a bounded animated atmospheric scene"
surface: "compact weather widget, ambient status surface, and small contextual dashboard module"
evidence: ["gabriel.ux Threads post DcGV6IIk3cn, 720x720, 8.7 seconds", "author caption naming Figma, orb generator, Claude embedding, and transitions.dev number pop", "independent Owen UI Lab transfer specimen", "public comments questioning blur over readable copy"]
confidence: high
axes_covered: ["typography", "color", "spacing", "radius", "borders", "shadows", "layout", "hierarchy", "iconography", "imagery", "motion", "interaction"]
unresolved_axes: []
allowed_range: "One primary weather metric, one sibling orb scene, explicit location/view/unit/language filters, up to two supporting weather widgets, and bounded metric transitions. Keep 20-24px between filters and widgets and between sibling widgets."
counterexample: "Do not place a blurred pane over the focal orb or readable copy, turn every dashboard card into an ambient scene, hide weather meaning inside the orb, or leave infinite motion running under reduced-motion preferences."
transfer_specimen: "lib/ui-lab/src/weather-orb-widget-study.tsx"
---

# Reference Study: Weather Orb Widget

## Source Pattern

The public `gabriel.ux` Threads post `DcGV6IIk3cn` presents an 8.7-second square weather widget. Its caption names a Figma mock, an orb generator, Claude-assisted animation embedding, PP Formula and Inter, and a transitions.dev number pop-in. The visual centers a dimensional atmospheric orb, a large temperature value, compact weather copy, and a translucent panel.

The source is evidence for composition and behavior, not a code or asset source. The Lab specimen does not copy the original orb, typography, labels, exact geometry, source video, or visual asset. It uses CSS layers, Korean and English data, three locations, explicit filters, and the existing `GlintWidget` API.

## Decision

The transferable value is the separation of semantic weather data from a contextual animated scene:

- the temperature and condition remain readable without interpreting the orb;
- the orb is a decorative sibling layer, not a foreground blur covering copy;
- location, current/outlook mode, unit, and language are explicit filters above the widget group;
- a changed metric uses one bounded pop transition while the weather scene changes state;
- supporting humidity, wind, air quality, sunrise, and forecast data remain opaque enough to scan;
- filter-to-grid and widget-to-widget spacing stays between 20px and 24px.

The public comments are useful counter-evidence: a blur pane can feel forced when it hides work that could remain readable on the background. Owen therefore keeps the orb and data in sibling grid tracks and reserves glass for the widget boundary and filter controls.

## Motion Contract

| Motion | Full-motion behavior | Reduced-motion behavior |
| --- | --- | --- |
| Orb drift | Slow bounded translation and rotation | Static final position |
| Cloud layers | Two small opposing translations | Static cloud placement |
| Rain | Repeating local texture offset only in rain state | Static rain texture |
| Metric change | One 420ms opacity, translate, and scale entry | Immediate value replacement |

Motion never supplies weather meaning. Condition text, temperature, high/low, humidity, wind, and forecast remain complete in the static state. No animation plays indefinitely when product or OS reduced motion is active.

## Filter And Spacing Contract

- Filters appear before the widget grid and use native buttons with `aria-pressed`.
- Location, view, unit, and language are separate named groups.
- Filter controls keep input-appropriate targets and never shrink text to preserve one row.
- Desktop uses 24px between the filter bar and widget grid and 24px between widgets.
- Narrow containers use 20px while reflowing filters and widgets to one column.
- Filter selection changes data and orb state together without moving surrounding layout.

## Foundation Mapping

| Pattern | Owner |
| --- | --- |
| Semantic weather shell, metric, description, visual slot, footer | `GlintWidget` |
| Location/view/unit/language state | Consumer or Lab composition |
| CSS atmospheric orb | Consumer-owned decorative visual slot |
| Bounded number transition | Consumer-owned metric content |
| Reusable transfer specimen | `WeatherOrbWidgetStudy` |

No new public component is required. `GlintWidget` already provides the correct semantic owner and hides the decorative visual from assistive technology. The Weather Orb specimen remains a composition reference until two real products need identical filters and state ownership.

## Deliberate Exclusions

- PP Formula is not added to the Foundation font stack.
- The external orb generator, original source video, and generated asset are not vendored.
- The source's blur placement is not reproduced over the focal content.
- The weather widget does not become a generic dashboard default.
- The orb is not exposed as a standalone decorative component or action button.